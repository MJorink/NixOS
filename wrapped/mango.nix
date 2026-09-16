{
  self,
  inputs,
  ...
}:
{
  perSystem =
    {
      lib,
      pkgs,
      ...
    }:
    {
      packages.myMango = inputs.wrapper-modules.wrappers.mangowc.wrap {
        inherit pkgs;

        runtimePkgs = with pkgs; [
          self.packages.${pkgs.stdenv.hostPlatform.system}.myFoot
          self.packages.${pkgs.stdenv.hostPlatform.system}.myNoctalia
          bibata-cursors
          wl-clip-persist
          wl-clipboard
          cliphist
        ];

        hotReload.enable = true;

        autostart_sh = ''
          wl-clip-persist --clipboard regular --reconnect-tries 0 &
          wl-paste --type text --watch cliphist store &
          ${lib.getExe pkgs.swaybg} -i ${../assets/wallpaper.png} -m fill &
          ${lib.getExe self.packages.${pkgs.stdenv.hostPlatform.system}.myNoctalia} &
          command -v mullvad-vpn >/dev/null && mullvad-vpn
        '';

        settings = {
          exec-once = [ "systemctl --user start mango-reload.service" ];

          monitorrule = [
            "name:^HDMI-A-1$,width:2560,height:1440,refresh:144,x:0,y:1080"
            "name:^eDP-1$,width:1920,height:1080,refresh:60,x:0,y:0"
          ];

          mousebind = [
            "SUPER, btn_left, moveresize, curmove"
            "SUPER, btn_right, moveresize, curresize"
          ];

          tagrule = [
            "id:1, layout_name:fair"
            "id:2, layout_name:fair"
            "id:3, layout_name:fair"
            "id:4, layout_name:fair"
            "id:5, layout_name:fair"
            "id:6, layout_name:fair"
            "id:7, layout_name:fair"
            "id:8, layout_name:fair"
            "id:9, layout_name:fair"
          ];

          windowrule = [
            "appid:rebuild,isfloating:1"
          ];

          bind = [
            # Spawn
            "SUPER, Return, spawn, foot"
            "SUPER+SHIFT, Return, spawn, foot"
            "SUPER+SHIFT, e, spawn, foot yazi ~/NixOS"
            "SUPER+CTRL, e, spawn, foot yazi ~/repos"
            "SUPER, e, spawn, foot yazi"
            "SUPER, m, spawn, spotify"
            "SUPER, u, spawn, foot --hold --app-id rebuild nh os switch"
            "SUPER, b, spawn, librewolf"

            # Noctalia
            "SUPER+CTRL, r, spawn, noctalia"
            "NONE,XF86AudioRaiseVolume,spawn,noctalia msg volume-up"
            "NONE,XF86AudioLowerVolume,spawn,noctalia msg volume-down"
            "NONE,XF86AudioMute,spawn,noctalia msg volume-mute"
            "NONE,XF86AudioMicMute,spawn,noctalia msg mic-mute"
            "NONE,XF86MonBrightnessUp,spawn,noctalia msg brightness-up all"
            "NONE,XF86MonBrightnessDown,spawn,noctalia msg brightness-down all"
            "SUPER,space,spawn,noctalia msg panel-toggle launcher"
            "SUPER,s,spawn,noctalia msg panel-toggle control-center"
            "SUPER+SHIFT,s,spawn,noctalia msg screenshot-region"
            "SUPER,comma,spawn,noctalia msg settings-toggle"
            "SUPER+SHIFT,p,spawn,noctalia msg session lock"
            "SUPER,p,spawn,noctalia msg panel-toggle session"

            # Common binds
            "SUPER, q, killclient"
            "SUPER+SHIFT, m, quit"
            "SUPER, i, minimized"
            "SUPER+SHIFT, i, restore_minimized"
            "SUPER, backslash, togglefloating"
            "SUPER, f, togglemaximizescreen"
            "SUPER+SHIFT, f, togglefullscreen"

            # Move/Resize
            "SUPER+CTRL, h, resizewin, -50, 0"
            "SUPER+CTRL, l, resizewin, +50, 0"
            "SUPER+CTRL, k, resizewin, 0, -50"
            "SUPER+CTRL, j, resizewin, 0, +50"
            "SUPER+SHIFT, k, tagmon, up"
            "SUPER+SHIFT, j, tagmon, down"
            "SUPER+SHIFT, h, exchange_client, left"
            "SUPER+SHIFT, l, exchange_client, right"

            # Focus
            "ALT, Tab, focusstack, next"
            "SUPER, h, focusdir, left"
            "SUPER, l, focusdir, right"
            "SUPER, k, focusdir, up"
            "SUPER, j, focusdir, down"

            # Tags
            "SUPER, 1, view, 1, 0"
            "SUPER, 2, view, 2, 0"
            "SUPER, 3, view, 3, 0"
            "SUPER, 4, view, 4, 0"
            "SUPER, 5, view, 5, 0"
            "SUPER, 6, view, 6, 0"
            "SUPER, 7, view, 7, 0"
            "SUPER, 8, view, 8, 0"
            "SUPER, 9, view, 9, 0"
            "SUPER+SHIFT, 1, tag, 1, 0"
            "SUPER+SHIFT, 2, tag, 2, 0"
            "SUPER+SHIFT, 3, tag, 3, 0"
            "SUPER+SHIFT, 4, tag, 4, 0"
            "SUPER+SHIFT, 5, tag, 5, 0"
            "SUPER+SHIFT, 6, tag, 6, 0"
            "SUPER+SHIFT, 7, tag, 7, 0"
            "SUPER+SHIFT, 8, tag, 8, 0"
            "SUPER+SHIFT, 9, tag, 9, 0"
          ];

          # Animations
          animations = 0;
          layer_animations = 0;

          # Blur/Shadows
          blur = 0;
          blur_layer = 0;
          shadows = 0;
          layer_shadows = 0;
          focused_opacity = 1.0;
          unfocused_opacity = 1.0;

          # Behaviour
          enable_hotarea = 0;
          focus_on_activate = 1;
          sloppyfocus = 1;
          warpcursor = 1;
          focus_cross_monitor = 1;
          allow_tearing = 2;
          drag_lock = 0;
          drag_tile_to_tile = 1;
          drag_tile_small = 0;

          # Cursor
          cursor_size = 16;
          cursor_theme = "Bibata-Modern-Ice";

          # Keyboard
          repeat_rate = 35;
          repeat_delay = 200;
          xkb_rules_layout = "us";
          xkb_rules_variant = "intl";

          # Mouse/Trackpad
          trackpad_accel_profile = 1;
          trackpad_accel_speed = 0.75;
          mouse_natural_scrolling = 0;
          mouse_accel_profile = 1;
          mouse_accel_speed = -0.5;
          tap_to_click = 0;
          tap_and_drag = 0;

          # Layout
          new_is_master = 0;
          default_mfact = 0.5;

          # Gaps/Border
          no_border_when_single = 0;
          border_radius = 16;
          borderpx = 2;
          smartgaps = 0;
          gappih = 5;
          gappiv = 5;
          gappoh = 10;
          gappov = 10;

          # Colors
          rootcolor = "0x282828ff";
          bordercolor = "0x665c54ff";
          dropcolor = "0xd65d0e80";
          splitcolor = "0xd79921ff";
          focuscolor = "0xd65d0eff";
          maximizescreencolor = "0x98971aff";
          urgentcolor = "0xcc241dff";
          scratchpadcolor = "0xd79921ff";
          globalcolor = "0xaf3a03ff";
          overlaycolor = "0x79740eff";
          jump_label_decorate_fg_color = "0xebdbb2ff";
          jump_label_decorate_bg_color = "0x3c3836ff";
          jump_label_decorate_focus_fg_color = "0x282828ff";
          jump_label_decorate_focus_bg_color = "0xd65d0eff";
          jump_label_decorate_border_color = "0x665c54ff";
          group_bar_decorate_fg_color = "0xebdbb2ff";
          group_bar_decorate_bg_color = "0x3c3836ff";
          group_bar_decorate_focus_fg_color = "0x282828ff";
          group_bar_decorate_focus_bg_color = "0xd65d0eff";
          group_bar_decorate_border_color = "0x665c54ff";
        };
      };
    };
}
