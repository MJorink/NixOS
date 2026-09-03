{ self, inputs, ... }: {
	flake.nixosModules.base = { lib, pkgs, ... }: {
		services = {
			mullvad-vpn.enable = true;
			auto-cpufreq = {
				enable = true;
				settings.charger = {
					governor = "performance";
					turbo = "auto";
				};
				settings.battery = {
					governor = "powersave";
					turbo = "never";
				};
			};
		};

		preservation.preserveAt."/persistent" = {
			directories = [ "/etc/mullvad-vpn" ];
			users.jorink.directories = [ ".config/Mullvad VPN" ];
		};
	};
}
