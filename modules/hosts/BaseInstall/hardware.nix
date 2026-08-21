{ self, inputs, ... }: {
	flake.nixosModules.hostBaseInstall = { config, lib, pkgs, modulesPath, ... }: {
		imports = [ (modulesPath + "/installer/scan/not-detected.nix") ];
		boot.initrd.availableKernelModules = [
			"xhci_pci"
			"nvme"
			"rtsx_pci_sdmmc"
		];

		nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";

		# Add more / make changes as needed based on your generated config:
		# nixos-generate-config --no-filesystems --flake --dir ~/generated-config

		# Remember this is just the base install, you can add more in your full config
	};
}
