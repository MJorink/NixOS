# The only host: a ThinkPad X270. Lists the feature modules it uses.
{ inputs, config, ... }:
{
  flake.nixosConfigurations.thinkpad = inputs.nixpkgs.lib.nixosSystem {
    modules = with config.flake.modules.nixos; [
      thinkpad
      base
      boot
      disk
      impermanence
      users
      network
      ssh
      audio
      bluetooth
      desktop
      dotfiles
      browser
      dev
    ];
  };
}
