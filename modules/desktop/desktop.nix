# glasswm session (started from ~/.profile on tty1) and its tools.
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
        glasswm # packages repo: macOS-style compositor (dwl based)
        slstatus
        bemenu
        (wrap foot { "--config" = "${df}/.config/foot/foot.ini"; })
        (wrap fnott { "--config" = "${df}/.config/fnott/fnott.ini"; })
        (wrap swaylock { "--config" = "${df}/.config/swaylock/config"; })
        swayidle
        wbg # wallpaper (dotfiles autostart)
        apple-cursor-macos # packages repo: macOS cursor as the default theme
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
      security.pam.services.swaylock = { }; # without /etc/pam.d/swaylock PAM uses "other", which denies every password

      fonts = {
        enableDefaultPackages = false;
        # Inter stands in for Apple's SF Pro (packages repo: the variable font only)
        packages = with pkgs; [ jetbrains-mono-nl-nerd-font inter-variable liberation_ttf noto-fonts-color-emoji ];
        fontconfig.defaultFonts = {
          monospace = [ "JetBrainsMonoNL Nerd Font Mono" ];
          sansSerif = [ "Inter Variable" "Liberation Sans" ];
          serif = [ "Liberation Serif" ];
          emoji = [ "Noto Color Emoji" ];
        };
      };
    };
}
