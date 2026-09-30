{ inputs, ... }: {
  perSystem = { pkgs, ... }: {
    packages.myWaybar = inputs.wrapper-modules.wrappers.waybar.wrap {
      inherit pkgs;

      settings = {
        layer = "top";
        position = "left";
        width = 34;
        spacing = 6;

        modules-left = [ "dwl/tags" "tray" ];
        modules-center = [ "wireplumber" "mpris" ];
        modules-right = [
          "temperature"
          "cpu"
          "memory"
          "custom/clipboard"
          "backlight"
          "battery"
          "clock"
          "custom/session"
        ];

        "dwl/tags".num-tags = 9;

        tray = {
          icon-size = 16;
          spacing = 6;
        };

        wireplumber = {
          format = "<span size='large'>{icon}</span>\n{volume}";
          justify = "center";
          format-muted = "<span size='large'>󰖁</span>";
          format-icons = [ "󰕿" "󰖀" "󰕾" ];
          on-click = "dwl-cmd mute";
          on-scroll-up = "dwl-cmd vol-up";
          on-scroll-down = "dwl-cmd vol-down";
        };

        mpris = {
          format = "<span size='large'>󰎈</span>";
          format-paused = "<span size='large'>󰏤</span>";
          tooltip-format = "{artist} - {title}";
        };

        temperature = {
          format = "<span size='large'>󰔏</span>\n{temperatureC}°";
          justify = "center";
          interval = 2;
          critical-threshold = 85;
        };
        cpu = {
          format = "<span size='large'>󰍛</span>\n{usage}%";
          justify = "center";
          interval = 2;
        };
        memory = {
          format = "<span size='large'></span>\n{percentage}%";
          justify = "center";
          interval = 2;
        };

        backlight = {
          format = "<span size='large'>󰃠</span>\n{percent}%";
          justify = "center";
          tooltip-format = "Brightness {percent}%";
          on-scroll-up = "dwl-cmd bri-up";
          on-scroll-down = "dwl-cmd bri-down";
        };

        battery = {
          format = "<span size='large'>{icon}</span>\n{capacity}%";
          justify = "center";
          format-charging = "<span size='large'>󰂄</span>\n{capacity}%";
          format-icons = [ "󰁺" "󰁼" "󰁾" "󰂀" "󰁹" ];
          states.warning = 15;
        };

        clock = {
          format = "{:%H\n%M}";
          justify = "center";
          tooltip-format = "{:%A, %d/%m/%Y}";
        };

        "custom/clipboard" = {
          format = "<span size='large'>󰅍</span>";
          on-click = "dwl-cmd clipboard";
          tooltip = false;
        };
        "custom/session" = {
          format = "<span size='large'>⏻</span>";
          on-click = "dwl-cmd session";
          tooltip = false;
        };
      };

      "style.css".path = pkgs.writeText "waybar.css" ''
        * {
          font-family: "MesloLGS Nerd Font Propo";
          font-size: 12px;
          font-weight: 500;
          min-height: 0;
          border: none;
          border-radius: 0;
        }
        window#waybar {
          background: #282828;
          color: #ebdbb2;
        }
        tooltip {
          background: #282828;
          border: 2px solid #d65d0e;
        }
        #tags button {
          padding: 4px 0;
          color: #a89984;
          background: transparent;
        }
        #tags button.occupied { color: #ebdbb2; }
        #tags button.focused { background: #d65d0e; color: #282828; }
        #tags button.urgent { background: #cc241d; color: #282828; }
        #tray, #wireplumber, #mpris, #temperature, #cpu, #memory,
        #custom-clipboard, #backlight, #battery, #clock, #custom-session {
          padding: 4px 0;
        }
        #wireplumber.muted, #battery.warning:not(.charging), #temperature.critical {
          color: #cc241d;
        }
      '';
    };
  };
}
