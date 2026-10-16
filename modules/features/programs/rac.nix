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

      # Pick a fork from ~/repos/rac that has a build and one of its branches, then launch it.
      # Switching branch rebuilds with ./setup.sh (incremental) in the dev shell first.
      rac1-launch = pkgs.writeShellScript "rac1-launch" ''
        PATH=${lib.makeBinPath [ myPkgs.myFuzzel myPkgs.myFoot pkgs.git pkgs.libnotify config.nix.package ]}:$PATH
        menu() { fuzzel --dmenu --prompt "$1: " --lines "$(echo "$2" | wc -l)" <<< "$2"; }
        fail() { notify-send -a rac1 "Ratchet & Clank" "$1"; exit 1; }

        cd ~/repos/rac || exit 1
        forks=$(for d in */; do [ -x "$d/build/rac1-native" ] && echo "''${d%/}"; done)
        [ -n "$forks" ] || fail "No built fork in ~/repos/rac"
        fork=$(menu rac1 "$forks") || exit 0
        cd "$fork" || exit 1

        # Current branch first (marked), then the other local and origin branches
        current=$(git branch --show-current)
        others=$(git for-each-ref --format='%(refname:lstrip=2)' refs/heads refs/remotes/origin \
          | sed 's|^origin/||' | grep -vx -e HEAD -e origin -e "$current" | sort -u)
        branch=$(menu branch "* $current''${others:+$'\n'$others}") || exit 0
        branch=''${branch#\* }

        if [ "$branch" != "$current" ]; then
          [ -z "$(git status --porcelain --untracked-files=no)" ] || fail "$fork has uncommitted changes, not switching to $branch"
          git switch -q "$branch" || fail "Could not switch $fork to $branch"
          ok=$(mktemp)
          foot -T "rac1 setup: $fork ($branch)" nix-shell ../shell.nix --run "./setup.sh && rm $ok"
          [ ! -e "$ok" ] || { rm "$ok"; fail "Setup of $fork ($branch) failed, see build/setup-build.log"; }
        fi

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
