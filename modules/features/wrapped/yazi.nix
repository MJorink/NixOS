{ self, inputs, ... }: {
	perSystem = { lib, pkgs, ... }: {
		packages.myYazi = inputs.wrapper-modules.wrappers.yazi.wrap {
			inherit pkgs;
			runtimePkgs = [ pkgs.micro ];
			
			settings.yazi = {
				mgr.show_hidden = true;
				opener.edit = [ { run = "micro %s"; block = true; } ];
			};
		};
	};
}
