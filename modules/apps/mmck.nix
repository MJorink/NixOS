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
      gstPlugins = with pkgs.gst_all_1; [ gst-plugins-base gst-plugins-good gst-plugins-bad gst-libav ];

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

          # The backend lives as long as the app: nothing keeps running after it closes
          trap 'echo "stopping backend..."; docker compose stop api garage postgres >/dev/null 2>&1' EXIT
          trap exit HUP INT TERM
          docker compose up -d api
          echo "waiting for the API on :5243..."
          for _ in $(seq 120); do
            curl -s -o /dev/null http://localhost:5243 && break
            sleep 2
          done

          export LD_LIBRARY_PATH="${lib.makeLibraryPath libs}''${LD_LIBRARY_PATH:+:$LD_LIBRARY_PATH}"
          export GST_PLUGIN_SYSTEM_PATH_1_0="${lib.makeSearchPathOutput "lib" "lib/gstreamer-1.0" gstPlugins}"
          # Only the Linux target (Android needs its own workload). Build output goes outside the
          # repo: Docker owns the shared projects' bin/ and obj/ (API container volumes).
          dotnet run --project MyMediaContentKingdom.Maui -f net10.0 \
            -p:TargetFrameworks=net10.0 --artifacts-path "$HOME/.cache/mmck-artifacts"
        '';
      };
    in
    {
      environment.systemPackages = [
        mmck
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
