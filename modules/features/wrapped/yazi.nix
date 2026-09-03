{ self, inputs, ... }: {
	perSystem = { lib, pkgs, ... }: {
		packages.myYazi = inputs.wrapper-modules.wrappers.yazi.wrap {
			inherit pkgs;
			runtimePkgs = [
				pkgs.micro
				pkgs.yaziPlugins.lazygit
			];
			
			settings.yazi = {
				mgr.show_hidden = true;
				mgr.prepend_keymap = {
					on   = [ "g" ];
					run  = "plugin lazygit";
					desc = "run lazygit";
				};
				opener.edit = [ { run = "micro %s"; block = true; } ];
			};
		};
	};
}
