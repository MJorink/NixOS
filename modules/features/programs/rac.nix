{ self, ... }: {
  flake.nixosModules.rac = { config, lib, pkgs, ... }:
    let
      myPkgs = self.packages.${pkgs.stdenv.hostPlatform.system};

      # Libraries the game dlopens at run time (mirrors ~/repos/rac/shell.nix)
      runtimeLibs = with pkgs; [
        libGL
        libglvnd
        vulkan-loader
        wayland
        libxkbcommon
        libdecor
        libx11
        libxrandr
        libxinerama
        libxcursor
        libxi
        libxext
        alsa-lib
        libpulseaudio
        pipewire
        jack2
        dbus
        udev
      ];

      # Run on the dGPU when PRIME offload is set up (e.g. Victus)
      offload = lib.optionalString config.hardware.nvidia.prime.offload.enableOffloadCmd "nvidia-offload ";

      # Pick a fork from ~/repos/rac that has a build, then launch it
      rac1-launch = pkgs.writeShellScript "rac1-launch" ''
        cd ~/repos/rac || exit 1
        forks=$(for d in */; do [ -x "$d/build/rac1-native" ] && echo "''${d%/}"; done)
        [ -n "$forks" ] || exit 1
        fork=$(echo "$forks" | ${lib.getExe myPkgs.myFuzzel} --dmenu --prompt "rac1: " --lines "$(echo "$forks" | wc -l)") || exit 0
        cd "$fork" || exit 1
        export LD_LIBRARY_PATH="/run/opengl-driver/lib:${lib.makeLibraryPath runtimeLibs}"
        exec ${offload}${lib.getExe pkgs.mangohud} ./build/rac1-native
      '';
    in
    {
      environment.systemPackages = [
        (pkgs.makeDesktopItem {
          name = "rac1-native";
          desktopName = "Ratchet & Clank";
          icon = "applications-games";
          exec = toString rac1-launch;
        })
      ];

      preservation.preserveAt."/persistent" = {
        users.jorink.directories = [
          ".local/share/rac1-native"
        ];
      };
    };
}
