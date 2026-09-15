{ ... }: {
  flake.nixosModules.VictusModule =
    {
      config,
      lib,
      pkgs,
      modulesPath,
      ...
    }:
    {
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

      # Keychron udev rules (for launcher.keychron.com)
      services.udev.packages = [
        (pkgs.writeTextFile {
          name = "keychron-udev-rules";
          destination = "/etc/udev/rules.d/60-keychron.rules";
          text = ''
            KERNEL=="hidraw*", SUBSYSTEM=="hidraw", ATTRS{idVendor}=="3434", TAG+="uaccess"
          '';
        })
      ];

      services.xserver.videoDrivers = [ "nvidia" ];

      hardware.nvidia = {
        modesetting.enable = true;
        powerManagement.enable = false;
        open = true;
        nvidiaSettings = false;

        prime.sync.enable = true;
        prime.intelBusId = "PCI:0:2:0";
        prime.nvidiaBusId = "PCI:1:0:0";
      };
    };
}
