# School project My Media Content Kingdom (.NET MAUI on Linux via OpenMaui).
# `mmck` / the "My Media Content Kingdom" entry starts the Docker backend and the app.
{ ... }:
{
  flake.modules.nixos.mmck = { pkgs, lib, ... }:
    let
      repo = "/home/jorink/repos/v-ictoosdd_volleypool_project_studentversie";
      # Loaded with dlopen by OpenMaui (GTK/Skia window) and its MediaElement (GStreamer)
      libs = with pkgs; [
        gtk3 gtk4 cairo at-spi2-core cups libGL libglvnd vulkan-loader libva libvdpau
        wayland libxkbcommon fontconfig freetype
        libx11 libxcursor libxext libxi libxrandr
        gst_all_1.gstreamer gst_all_1.gst-plugins-base
      ];
      # gstreamer itself: the core plugins (queue, typefind); Nix's build has no default path
      gstPlugins = with pkgs.gst_all_1; [ gstreamer gst-plugins-base gst-plugins-good gst-plugins-bad gst-libav ];

      lockProps = pkgs.writeText "mmck-lockfile.props" ''
        <Project>
          <PropertyGroup>
            <NuGetLockFilePath>$(MSBuildProjectExtensionsPath)packages.lock.json</NuGetLockFilePath>
          </PropertyGroup>
        </Project>
      '';

      # The backend lives as long as the app: nothing keeps running after it closes.
      # extra: more shell to run on exit (ends with ;, no single quotes)
      backendUp = extra: ''
        trap '${extra}echo "stopping backend..."; docker compose stop api garage postgres >/dev/null 2>&1' EXIT
        trap exit HUP INT TERM
        docker compose up -d api
        echo "waiting for the API on :5243..."
        for _ in $(seq 120); do
          curl -s -o /dev/null http://localhost:5243 && break
          sleep 2
        done
      '';

      mmck = pkgs.writeShellApplication {
        name = "mmck";
        runtimeInputs = with pkgs; [ dotnet-sdk_10 docker curl ];
        text = ''
          cd ${repo}

          # Nix SDK installs workloads user-local in ~/.dotnet (persisted). A fresh install
          # records the workload but leaves no packs; the repair downloads them.
          if [ ! -d "$HOME/.dotnet/packs/Microsoft.Maui.Sdk" ]; then
            dotnet workload install maui-tizen
            dotnet workload repair
          fi

          ${backendUp ""}
          export LD_LIBRARY_PATH="${lib.makeLibraryPath libs}''${LD_LIBRARY_PATH:+:$LD_LIBRARY_PATH}"
          export GST_PLUGIN_SYSTEM_PATH_1_0="${lib.makeSearchPathOutput "lib" "lib/gstreamer-1.0" gstPlugins}"
          # Only the Linux target (Android needs its own workload). Build output goes outside the
          # repo: Docker owns the shared projects' bin/ and obj/ (API container volumes).
          # With one target the committed packages.lock.json would be rewritten; lockProps
          # sends each project's lock file to its obj/ folder there instead.
          dotnet run --project MyMediaContentKingdom.Maui -f net10.0 \
            -p:TargetFrameworks=net10.0 -p:CustomBeforeMicrosoftCommonProps=${lockProps} \
            --artifacts-path "$HOME/.cache/mmck-artifacts"
        '';
      };

      # Android SDK is unfree with its own license; a separate pkgs keeps base.nix's unfree list as is
      androidPkgs = import pkgs.path {
        inherit (pkgs.stdenv.hostPlatform) system;
        config = { allowUnfree = true; android_sdk.accept_license = true; };
      };
      androidSdk = (androidPkgs.androidenv.composeAndroidPackages {
        platformVersions = [ "36" ];
        buildToolsVersions = [ "36.0.0" ];
        includeEmulator = false;
        includeSystemImages = false;
      }).androidsdk;
      sdkDir = "${androidSdk}/libexec/android-sdk";
      appId = "com.companyname.mymediacontentkingdom.maui";

      # The android workload ships prebuilt Linux tools (llc, ld) that NixOS can't run outside an FHS
      androidDotnet = pkgs.buildFHSEnv {
        name = "mmck-android-dotnet";
        targetPkgs = p: with p; [ dotnet-sdk_10 zlib stdenv.cc.cc.lib icu openssl ];
        runScript = "dotnet";
      };

      mmck-android = pkgs.writeShellApplication {
        name = "mmck-android";
        # scrcpy's own adb has the same server protocol (1.0.41) as the SDK's
        runtimeInputs = [ androidDotnet androidSdk pkgs.scrcpy pkgs.dotnet-sdk_10 pkgs.docker pkgs.curl ];
        text = ''
          cd ${repo}

          # ~ and /tmp are a small tmpfs: the workload download needs the persisted disk
          if [ ! -d "$HOME/.dotnet/packs/Microsoft.Android.Sdk.Linux" ]; then
            mkdir -p "$HOME/.dotnet/tmp"
            TMPDIR="$HOME/.dotnet/tmp" dotnet workload install android
          fi

          # Debug builds embed this gitignored file; localhost reaches the laptop through adb reverse
          settings=MyMediaContentKingdom.Maui/Configuration/appsettings.local.json
          [ -f "$settings" ] || printf '{\n  "Api": {\n    "BaseUrl": "http://localhost:5243"\n  }\n}\n' > "$settings"

          echo "waiting for the phone (USB debugging on, allow this computer on the phone)..."
          adb wait-for-device
          adb reverse tcp:5243 tcp:5243 # API
          adb reverse tcp:3900 tcp:3900 # Garage (S3)

          # Phone screen in a window here (closed with the app); it keeps the screen on while open
          ${backendUp "kill $(jobs -p) 2>/dev/null || true; "}
          scrcpy --stay-awake --verbosity=error --window-title="My Media Content Kingdom (phone)" &
          # Builds, installs and starts the app on the phone. Same lock file redirect as mmck:
          # Nix's SDK pins another ILLink version than the committed packages.lock.json.
          mmck-android-dotnet build MyMediaContentKingdom.Maui -t:Run -f net10.0-android \
            -p:AndroidSdkDirectory=${sdkDir} -p:Aapt2ToolPath=${sdkDir}/build-tools/36.0.0 \
            -p:JavaSdkDirectory=${pkgs.jdk17}/lib/openjdk \
            -p:CustomBeforeMicrosoftCommonProps=${lockProps} \
            --artifacts-path "$HOME/.cache/mmck-android-artifacts"

          # Keep the backend up while the app runs; closing it, unplugging or closing this window ends it
          sleep 5
          echo "app running on the phone; close it there to stop the backend"
          while adb shell pidof ${appId} >/dev/null 2>&1; do sleep 3; done
        '';
      };
    in
    {
      environment.systemPackages = [
        mmck
        mmck-android
        (pkgs.makeDesktopItem {
          name = "mmck-android";
          desktopName = "My Media Content Kingdom (phone)";
          exec = "footclient --hold --title \"My Media Content Kingdom (phone)\" mmck-android";
          icon = "phone";
          categories = [ "Development" ];
        })
        (pkgs.makeDesktopItem {
          name = "mmck";
          desktopName = "My Media Content Kingdom";
          # footclient = the Terminal (dotfiles); --hold keeps the output readable after exit
          exec = "footclient --hold --title \"My Media Content Kingdom\" mmck";
          icon = "video-x-generic";
          categories = [ "Development" ];
        })
      ];

      environment.persistence."/persist".users.jorink.directories = [ ".dotnet" ];

      # The app's file picker (upload) asks xdg-desktop-portal; GTK provides the dialog
      xdg.portal = {
        enable = true;
        extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
        config.common.default = "gtk";
      };
    };
}
