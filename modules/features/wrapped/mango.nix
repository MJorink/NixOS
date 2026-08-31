{ self, inputs, ... }: {
	flake.nixosModules.mango = { lib, pkgs, ... }: {
		imports = [
			inputs.mangowm.nixosModules.mango
			self.nixosModules.noctalia
		];
		programs.mango = {
			enable = true;
			package = self.packages.${pkgs.stdenv.hostPlatform.system}.myMango;
		};
		xdg.portal = {
			enable = true;
			extraPortals = with pkgs; [ xdg-desktop-portal-gtk xdg-desktop-portal-wlr ];
			config.common = {
				default = [ "gtk" ];
				"org.freedesktop.impl.portal.ScreenCast" = [ "wlr" ];
				"org.freedesktop.impl.portal.Screenshot" = [ "wlr" ];
				"org.freedesktop.impl.portal.Secret" = [ "gnome-keyring" ];
			};
		};
		services.upower.enable = true;
		services.gnome.gnome-keyring.enable = true;

		systemd.packages = [ self.packages.${pkgs.stdenv.hostPlatform.system}.myMango ]; # For hot-reloading
	};

	perSystem = { lib, pkgs, ... }: {
		packages.myMango = inputs.wrapper-modules.wrappers.mangowc.wrap {
			inherit pkgs;
			package = inputs.mangowm.packages.${pkgs.stdenv.hostPlatform.system}.mango;
			runtimePkgs = [
				self.packages.${pkgs.stdenv.hostPlatform.system}.myNoctalia
				self.packages.${pkgs.stdenv.hostPlatform.system}.myFoot
				pkgs.cliphist
				pkgs.wl-clip-persist
				pkgs.wl-clipboard
			];
			hotReload.enable = true;
			autostart_sh = ''
				wl-clip-persist --clipboard regular --reconnect-tries 0 &
				wl-paste --type text --watch cliphist store &
				noctalia &
				mullvad-vpn
			'';
			settings = {
				exec-once = [
					"systemctl --user start mango-reload.service"
				];
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
					"appid:yazi,isfloating:1"
					"appid:rebuild,isfloating:1"
				];
				bind = [
					# Spawn
					"SUPER, Return, spawn, foot"
					"SUPER+SHIFT, Return, spawn, foot"
					"SUPER+SHIFT, e, spawn, foot yazi ~/NixOS/modules"
					"SUPER+CTRL, e, spawn, foot yazi ~/repos"
					"SUPER, e, spawn, foot --app-id yazi yazi"
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
					"SUPER,l,spawn,noctalia msg session lock"
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
					"SUPER+CTRL, Left, resizewin, -50, 0"
					"SUPER+CTRL, Right, resizewin, +50, 0"
					"SUPER+CTRL, Up, resizewin, 0, -50"
					"SUPER+CTRL, Down, resizewin, 0, +50"
					"SUPER+SHIFT, Up, tagmon, up"
					"SUPER+SHIFT, Down, tagmon, down"
					"SUPER+SHIFT, Left, exchange_client, left"
					"SUPER+SHIFT, Right, exchange_client, right"

					# Focus
					"ALT, Tab, focusstack, next"
					"SUPER, Left, focusdir, left"
					"SUPER, Right, focusdir, right"
					"SUPER, Up, focusdir, up"
					"SUPER, Down, focusdir, down"

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
				animations=0;
				layer_animations=0;

				# Blur/Shadows
				blur=0;
				blur_layer=0;
				shadows=0;
				layer_shadows=0;
				focused_opacity = 1.0;
				unfocused_opacity = 1.0;

				# Behaviour
				enable_hotarea = 0;
				focus_on_activate = 1;
				sloppyfocus = 1;
				warpcursor 	= 1;
				focus_cross_monitor = 1;
				allow_tearing=2;
				drag_lock = 0;
				drag_tile_to_tile = 1;
				drag_tile_small = 0;

				# Cursor
				cursor_size = 16;
				cursor_theme = "Bibata-Modern-Amber";

				# Keyboard
				repeat_rate = 40;
				repeat_delay = 250;
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
				rootcolor = "0x231d1bff";
				bordercolor = "0x76655fff";
				dropcolor = "0xb85a3080";
				splitcolor = "0xd8a657ff";
				focuscolor = "0xb85a30ff";
				maximizescreencolor = "0x8b9a5aff";
				urgentcolor = "0xc25d4eff";
				scratchpadcolor = "0xd8a657ff";
				globalcolor = "0x421b0aff";
				overlaycolor = "0x2f3616ff";
				jump_label_decorate_fg_color = "0xe6dbd3ff";
				jump_label_decorate_bg_color = "0x3a302cff";
				jump_label_decorate_focus_fg_color = "0x1d1816ff";
				jump_label_decorate_focus_bg_color = "0xb85a30ff";
				jump_label_decorate_border_color = "0x76655fff";
				group_bar_decorate_fg_color = "0xe6dbd3ff";
				group_bar_decorate_bg_color = "0x3a302cff";
				group_bar_decorate_focus_fg_color = "0x1d1816ff";
				group_bar_decorate_focus_bg_color = "0xb85a30ff";
				group_bar_decorate_border_color = "0x76655fff";
			};
		};
	};
}

