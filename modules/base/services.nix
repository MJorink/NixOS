{ self, inputs, ... }: {
	flake.nixosModules.base = {
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
	};
}
