# X270: i5-7200U, HD 620, Intel 8265 Wi-Fi/BT, NVMe.
{
  flake.modules.nixos.thinkpad = { pkgs, ... }: {
    networking.hostName = "thinkpad";
    nixpkgs.hostPlatform = "x86_64-linux";

    boot.initrd.availableKernelModules = [ "xhci_pci" "nvme" "usb_storage" "sd_mod" ];
    boot.kernelModules = [ "kvm-intel" ];
    hardware.cpu.intel.updateMicrocode = true;

    # Only the firmware this laptop loads (packages repo), not all of linux-firmware
    hardware.firmware = [ pkgs.firmware-x270 ];
    hardware.wirelessRegulatoryDatabase = true;

    hardware.graphics = {
      enable = true;
      extraPackages = [ pkgs.intel-media-driver ]; # VA-API (iHD) for H.264/VP9
    };

    system.stateVersion = "26.05";
  };
}
