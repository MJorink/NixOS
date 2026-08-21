{ self, inputs, ... }: {
	flake.nixosModules.hostNixPad = { config, lib, pkgs, modulesPath, ... }: {
		imports = [ (modulesPath + "/installer/scan/not-detected.nix") ];

		boot.initrd.availableKernelModules = [
			"xhci_pci"
			"nvme"
			"usb_storage"
			"sd_mod"
			"rtsx_pci_sdmmc"
		];
		
		nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
		
		hardware.bluetooth.enable = true;
		preservation.preserveAt."/persistent" = {
			directories = [
				"/var/lib/bluetooth"
			];
		};

		hardware.graphics = {
			enable = true;
			extraPackages = with pkgs; [
				intel-compute-runtime-legacy1
				intel-media-driver
				intel-vaapi-driver
				libva-vdpau-driver
				mesa
			];
		};
		
		hardware.cpu = {
			x86.msr.enable = true;
			intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
		};

		services.undervolt = {
			enable = true;
			coreOffset = -80;
			uncoreOffset = -80;
			gpuOffset = -80;
			temp = 90;
			useTimer = true;
		};
	};
}
