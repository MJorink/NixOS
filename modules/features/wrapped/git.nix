{ self, inputs, ... }: {
	perSystem = { lib, pkgs, ... }: {
		packages.myGit = inputs.wrapper-modules.wrappers.git.wrap {
			inherit pkgs;
			runtimePkgs = [
				pkgs.git-credential-oauth
				pkgs.lazygit
			];
			
			configFile.content = ''
				[init]
					defaultBranch = main
				[user]
					name = Jorink
					email = maxjorink@gmail.com
				[credential]
					helper = store
					helper = oauth
				[credential "https://gitlab.windesheim.nl"]
					oauthClientId = df9234c956328152bd180824d4ebaf9ab7b758477234be94a1fd89fd48924e1b
			'';			
		};
	};
}
