{ self, inputs, ... }: {
	perSystem = { lib, pkgs, ... }: {
		packages.myYazi = inputs.wrapper-modules.wrappers.yazi.wrap {
			inherit pkgs;
			runtimePkgs = [ pkgs.micro pkgs.mpv ];
			settings.yazi = {
				mgr.show_hidden = true;
				opener.play = [ { run = "mpv %s"; orphan = true; } ];
				opener.edit = [ { run = "micro %s"; block = true; } ];
			};
		};
	};
}
