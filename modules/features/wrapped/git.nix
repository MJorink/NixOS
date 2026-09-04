{ self, inputs, ... }: {
	perSystem = { lib, pkgs, ... }: {
		packages.myGit = inputs.wrapper-modules.wrappers.git.wrap {
			inherit pkgs;			
			configFile.content = ''
				[init]
					defaultBranch = main
				[user]
					name = Jorink
					email = maxjorink@gmail.com
				[credential]
					helper = store
			'';			
		};
	};
}
