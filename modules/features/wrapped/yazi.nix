{ self, inputs, ... }: {
	perSystem = { lib, pkgs, ... }: {
		packages.myYazi = inputs.wrapper-modules.wrappers.yazi.wrap {
			inherit pkgs;
			runtimePkgs = [ pkgs.micro ];

			plugins.lazygit = pkgs.yaziPlugins.lazygit;

			settings.yazi = {
				mgr.show_hidden = true;
				opener.edit = [ { run = "micro %s"; block = true; } ];
			};

			settings.keymap.mgr.prepend_keymap = [
				{
					on   = [ "g" "i" ];
					run  = "plugin lazygit";
					desc = "run lazygit";
				}
			];
		};
	};
}
