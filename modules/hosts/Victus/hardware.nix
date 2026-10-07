{ ... }: {
  flake.nixosModules.VictusModule = { config, lib, pkgs, modulesPath, ... }: {
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
      nvidiaPersistenced = true;
      dynamicBoost.enable = true;

      # PRIME sync is X11-only and does nothing under dwl (Wayland), so use
      # offload and route games to the dGPU explicitly (see Steam below)
      prime.offload.enable = true;
      prime.offload.enableOffloadCmd = true;
      prime.intelBusId = "PCI:0:2:0";
      prime.nvidiaBusId = "PCI:1:0:0";
    };

    # Run Steam (and every game it launches) on the NVIDIA GPU
    programs.steam.package = pkgs.steam.override {
      extraEnv = {
        __NV_PRIME_RENDER_OFFLOAD = "1";
        __NV_PRIME_RENDER_OFFLOAD_PROVIDER = "NVIDIA-G0";
        __GLX_VENDOR_LIBRARY_NAME = "nvidia";
        __VK_LAYER_NV_optimus = "NVIDIA_only";
      };
    };

    # Workaround to prevent crashing ( broken gpu :( )
    systemd.services.nvidia-clock-cap = {
      description = "Cap NVIDIA GPU clocks";
      wantedBy = [ "multi-user.target" ];
      after = [ "nvidia-persistenced.service" ];
      serviceConfig = {
        Type = "oneshot";
        RemainAfterExit = true;
        ExecStart = "${config.hardware.nvidia.package.bin}/bin/nvidia-smi -lgc 210,2200";
        ExecStop = "${config.hardware.nvidia.package.bin}/bin/nvidia-smi -rgc";
      };
    };
  };
}
