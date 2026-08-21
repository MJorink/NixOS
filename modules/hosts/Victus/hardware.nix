{ self, inputs, ... }: {
	flake.nixosModules.hostVictus = { config, lib, pkgs, modulesPath, ... }: {
		imports = [ (modulesPath + "/installer/scan/not-detected.nix") ];

		boot.initrd.availableKernelModules = [
			"xhci_pci"
			"nvme"
			"usbhid"
			"rtsx_pci_sdmmc"
		];
		
		boot.kernelModules = [ "kvm-intel" ];

		nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
		hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;

		hardware.graphics = {
			enable = true;
			extraPackages = with pkgs; [
				mesa
			];
		};
		
		services.xserver.videoDrivers = [ "nvidia" ];
		
		hardware.nvidia = {
			modesetting.enable = true;
			# powerManagement.enable = false;
			# powerManagement.finegrained = false;
			open = true;
			nvidiaSettings = false;
			
			prime.sync.enable = true;
			prime.intelBusId = "PCI:0:2:0";
			prime.nvidiaBusId = "PCI:1:0:0";
		};
	};
}
