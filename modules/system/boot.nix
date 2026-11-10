# Fast, quiet boot: systemd-boot without menu (hold Space for it). initrd is systemd (the only kind now).
{
  flake.modules.nixos.boot = {
    boot.loader.systemd-boot = { enable = true; editor = false; configurationLimit = 5; };
    boot.loader.efi.canTouchEfiVariables = true;
    boot.loader.timeout = 0;
    boot.consoleLogLevel = 3;
    boot.kernelParams = [ "quiet" "loglevel=3" ];
  };
}
