# dwl session (started from ~/.profile on tty1) and its tools.
# Programs that take a config path are wrapped to read it from the dotfiles input.
{ inputs, ... }:
{
  flake.modules.nixos.desktop = { pkgs, ... }:
    let
      df = inputs.dotfiles;
      wrap = package: flags: inputs.wrappers.lib.wrapPackage { inherit pkgs package flags; };
    in
    {
      environment.systemPackages = with pkgs; [
        dwl # packages repo: patched, config.h compiled in
        slstatus
        bemenu
        (wrap foot { "--config" = "${df}/.config/foot/foot.ini"; })
        (wrap fnott { "--config" = "${df}/.config/fnott/fnott.ini"; })
        (wrap swaylock { "--config" = "${df}/.config/swaylock/config"; })
        swayidle
        wlopm
        wlr-randr
        grim
        slurp
        wl-clipboard
        wl-clip-persist
        cliphist
        libnotify
        brightnessctl
        jq
        impala # Wi-Fi TUI (iwd)
        wiremix # audio TUI
        libva-utils
      ];

      # logind: lid and power key suspend; swayidle (dotfiles idle) locks before sleep
      services.logind.settings.Login = {
        HandleLidSwitch = "suspend";
        HandlePowerKey = "suspend";
      };
      services.udev.packages = [ pkgs.brightnessctl ]; # video group may set the backlight

      fonts = {
        enableDefaultPackages = false;
        packages = with pkgs; [ jetbrains-mono-nl-nerd-font liberation_ttf noto-fonts-color-emoji ];
        fontconfig.defaultFonts = {
          monospace = [ "JetBrainsMonoNL Nerd Font Mono" ];
          sansSerif = [ "Liberation Sans" ];
          serif = [ "Liberation Serif" ];
          emoji = [ "Noto Color Emoji" ];
        };
      };
    };
}
