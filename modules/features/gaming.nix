{ self, inputs, ... }: {
	flake.nixosModules.steam = { lib, pkgs, ... }: {
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

	# Use on top of steam module
	flake.nixosModules.vr = { lib, pkgs, ... }: {
		# Wireless vr without SteamVR
		services.wivrn = {
			enable = true;
			openFirewall = true;
			autoStart = true;
		};

		environment.systemPackages = with pkgs; [
			xrizer
		];

		preservation.preserveAt."/persistent" = {
			users.jorink.directories = [
				".config/wivrn"
			];
		};

		# SteamVR fixes
		programs.nix-ld.enable = true;
		programs.steam.remotePlay.openFirewall = true;
		# networking.firewall.allowedUDPPorts = [ 10400 10401 ]; # Might not be needed? As we do openFirewall?
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
	};
}
