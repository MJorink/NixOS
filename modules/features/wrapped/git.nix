{ self, inputs, ... }: {
	perSystem = { pkgs, lib, ... }: {
		packages.myGit = inputs.wrapper-modules.wrappers.git.wrap {
			inherit pkgs;
			runtimePkgs = [ pkgs.git-credential-oauth ];
			configFile.content = ''
				[init]
					defaultBranch = main
				[user]
					name = Jorink
					email = maxjorink@gmail.com
				[credential]
					helper = cache --timeout 21600
					helper = oauth
			'';			
		};
	};
}
