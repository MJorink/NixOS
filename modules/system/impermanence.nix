# What survives a reboot. Feature modules add their own paths to
# environment.persistence."/persist"; this file has only the base system.
{ inputs, ... }:
{
  flake.modules.nixos.impermanence = {
    imports = [ inputs.impermanence.nixosModules.impermanence ];

    environment.persistence."/persist" = {
      hideMounts = true;
      directories = [
        "/var/lib/nixos" # uid/gid map
        "/var/lib/systemd/timers" # missed timers (nix gc) run after boot
      ];
      files = [ "/etc/machine-id" ];
      users.jorink.directories = [
        "repos"
        "Downloads"
        "Documents"
        { directory = ".ssh"; mode = "0700"; }
        ".local/state" # shell history, git credentials, brightness, wireplumber, nvim
      ];
    };
  };
}
