{ ... }: {
  flake.nixosModules.jorink =
    {
      lib,
      pkgs,
      ...
    }:
    {
      users.users.jorink = {
        isNormalUser = true;
        hashedPasswordFile = "/persistent/passwd"; # mkpasswd -m yescrypt > /persistent/passwd
        extraGroups = [
          "wheel"
          "networkmanager"
        ];
      };

      preservation.preserveAt."/persistent" = {
        users.jorink = {
          home = "/home/jorink";
          directories = [
            "NixOS"
            "repos"
            ".config/git" # Git credentials are stored here
            ".ssh"
            ".config/github-copilot" # Copilot auth (neovim)
          ];
        };
      };
    };
}
