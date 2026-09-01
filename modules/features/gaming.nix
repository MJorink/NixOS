{ self, inputs, ... }: {
	flake.nixosModules.FlatGames = { lib, pkgs, ... }: {
		programs.steam.enable = true;
		environment.systemPackages = with pkgs; [
			protonup-qt
		];

		preservation.preserveAt."/persistent" = {
			users.jorink.directories = [
				".steam"
				".local/share/Steam"
			];
		};
	};

	flake.nixosModules.VRGames = { lib, pkgs, ... }: {
		# Use on top of FlatGames
		services.wivrn = {
			enable = true;
			openFirewall = true;
			autoStart = true;
		};

		# Fix SteamVR
		# systemd.tmpfiles.rules = [
		#   "L+ /bin/bash - - - - ${pkgs.bash}/bin/bash"
		# ];
		programs.nix-ld.enable = true;
		programs.steam.remotePlay.openFirewall = true;
		# networking.firewall.allowedUDPPorts = [ 10400 10401 ];
		systemd.services.steamvr-setcap = {
		  description = "Grant cap_sys_nice to SteamVR vrcompositor-launcher";
		  wantedBy = [ "multi-user.target" ];
		  serviceConfig = {
		    Type = "oneshot";
		    ExecStart = "${pkgs.libcap}/bin/setcap cap_sys_nice+ep /home/jorink/.local/share/Steam/steamapps/common/SteamVR/bin/linux64/vrcompositor-launcher";
		    RemainAfterExit = true;
		  };
		  unitConfig.ConditionPathExists = "/home/jorink/.local/share/Steam/steamapps/common/SteamVR/bin/linux64/vrcompositor-launcher";
		};
		
		environment.systemPackages = with pkgs; [
			xrizer
		];

		preservation.preserveAt."/persistent" = {
			users.jorink.directories = [
				".config/wivrn"
			];
		};
	};
}
