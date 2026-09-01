{ self, inputs, ... }: {
	flake.nixosModules.desktop = { lib, pkgs, ... }: {
	
		# General cross-desktop stuff, import standalone desktop module in host config
		services.mullvad-vpn.gui.enable = true;
		services.displayManager.ly.enable = true;
		services.pipewire.enable = true;
		services.pipewire.pulse.enable = true;

		security.polkit.enable = true;
		systemd.user.services.polkit-gnome-authentication-agent-1 = {
		  description = "polkit-gnome-authentication-agent-1";
		  wantedBy = [ "graphical-session.target" ];
		  wants = [ "graphical-session.target" ];
		  after = [ "graphical-session.target" ];
		  serviceConfig = {
		    Type = "simple";
		    ExecStart = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
		    Restart = "on-failure";
		    RestartSec = 1;
		    TimeoutStopSec = 10;
		  };
		};

		environment.systemPackages = with pkgs; [
			bibata-cursors
		];

		fonts.packages = with pkgs; [
			nerd-fonts.ubuntu
			nerd-fonts.ubuntu-mono
		];

		preservation.preserveAt."/persistent" = {
			users.jorink.directories = [
				".local/state/wireplumber"
				".local/share/keyrings"
				"Downloads"
				"Documents"
			];
		};
	};

	flake.nixosModules.desktopExtras = { lib, pkgs, ... }: {
		# Install personal packages here (for all hosts)
		environment.systemPackages = with pkgs; [
			librewolf
			proton-authenticator
			localsend
			filezilla
			qbittorrent
		];

		preservation.preserveAt."/persistent" = {
			users.jorink.directories = [
				".config/librewolf"
				".local/share/me.proton.authenticator"
			];
		};
	};
}
