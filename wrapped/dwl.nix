{ self, inputs, ... }: {
  perSystem = { lib, pkgs, ... }:
    let
      myPkgs = self.packages.${pkgs.stdenv.hostPlatform.system};

      dwl = (pkgs.dwl.override { configH = ./dwl-config.h; }).overrideAttrs {
        version = "0.10-dev";
        src = ../assets/dwl;
        outputs = [ "out" ];
      };

      # Keybind and bar-click actions: OSD, menus, screenshot
      dwl-cmd = pkgs.writeShellScriptBin "dwl-cmd" ''
        menu() { fuzzel --dmenu --prompt "$1: " --lines "$2"; }
        osd() {
          id=$(cat "$XDG_RUNTIME_DIR/dwl-osd-id" 2>/dev/null || echo 0)
          notify-send -a dwl -c osd -h "int:value:$2" -r "$id" -p "$1" "$2%" > "$XDG_RUNTIME_DIR/dwl-osd-id"
        }
        vol() {
          read -r _ v m < <(wpctl get-volume "$1")
          v=''${v:-0.00}
          osd "$2''${m:+ muted}" $((10#''${v/./}))
        }
        bri() { osd Brightness $(($(brightnessctl get) * 100 / $(brightnessctl max))); }

        case $1 in
          vol-up) wpctl set-volume -l 1.0 @DEFAULT_AUDIO_SINK@ 5%+ && vol @DEFAULT_AUDIO_SINK@ Volume ;;
          vol-down) wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%- && vol @DEFAULT_AUDIO_SINK@ Volume ;;
          mute) wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle && vol @DEFAULT_AUDIO_SINK@ Volume ;;
          mic-mute) wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle && vol @DEFAULT_AUDIO_SOURCE@ Microphone ;;
          bri-up) brightnessctl -q --min-value=5% set 5%+ && bri ;;
          bri-down) brightnessctl -q --min-value=5% set 5%- && bri ;;
          screenshot)
            # Freeze the screen, select on the frozen frame, then unfreeze
            # (wayfreeze runs the command via sh, so $PPID is wayfreeze)
            exec wayfreeze --hide-cursor --after-freeze-cmd 'dwl-cmd screenshot-region; kill $PPID'
            ;;
          screenshot-region)
            f=~/Pictures/Screenshots/$(date +%F_%H-%M-%S).png
            mkdir -p "''${f%/*}"
            region=$(slurp) && grim -g "$region" "$f" && wl-copy < "$f"
            ;;
          clipboard)
            sel=$(cliphist list | menu clipboard 15) && printf '%s' "$sel" | cliphist decode | wl-copy
            ;;
          session)
            case $(printf '%s\n' Lock Logout Suspend Reboot Shutdown | menu session 5) in
              Lock) swaylock ;;
              Logout) pkill -x dwl ;;
              Suspend) systemctl suspend ;; # swayidle locks before sleep
              Reboot) systemctl reboot ;;
              Shutdown) systemctl poweroff ;;
            esac
            ;;
          control)
            case $(printf '%s\n' Wi-Fi Bluetooth Audio | menu control 3) in
              Wi-Fi) foot nmtui ;;
              Bluetooth) foot bluetuith ;;
              Audio) foot wiremix ;;
            esac
            ;;
          *) echo "usage: dwl-cmd vol-up|vol-down|mute|mic-mute|bri-up|bri-down|screenshot|clipboard|session|control" >&2; exit 1 ;;
        esac
      '';

      autostart = pkgs.writeShellScript "dwl-autostart" ''
        dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP
        waybar &
        wl-clip-persist --clipboard regular --reconnect-tries 0 &
        wl-paste --type text --watch cliphist store &
        ${lib.getExe pkgs.swaybg} -i ${../assets/wallpaper.png} -m fill &
        mako &
        swayidle -w before-sleep swaylock &
        command -v mullvad-vpn >/dev/null && mullvad-vpn
      '';
    in
    {
      packages.myDwl = inputs.wrapper-modules.lib.wrapPackage {
        inherit pkgs;
        package = dwl;

        runtimePkgs = with pkgs; [
          myPkgs.myFoot
          myPkgs.myFuzzel
          myPkgs.myMako
          myPkgs.mySwaylock
          myPkgs.myWaybar
          dwl-cmd
          swayidle
          bibata-cursors
          wl-clip-persist
          wl-clipboard
          cliphist
          dbus
          grim
          slurp
          wayfreeze
          brightnessctl
          libnotify
          wireplumber
          bluetuith
          wiremix
        ];

        env.XDG_CURRENT_DESKTOP = "dwl";
        flags."-s" = "${autostart}";
      };
    };
}
