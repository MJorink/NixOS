# Declarative users. The password hash lives in /persist (written by install.sh).
{
  flake.modules.nixos.users = {
    users.mutableUsers = false;
    users.users.root.hashedPassword = "!";
    users.users.jorink = {
      isNormalUser = true;
      uid = 1000;
      extraGroups = [ "wheel" "video" ];
      hashedPasswordFile = "/persist/passwords/jorink";
    };

    security.sudo.enable = false;
    security.doas = {
      enable = true;
      extraRules = [
        { groups = [ "wheel" ]; persist = true; } # one password per 5 minutes
        # session menu, MOD+CTRL+p (dotfiles .local/bin); last match wins in doas
        { users = [ "jorink" ]; noPass = true; cmd = "systemctl"; args = [ "suspend" ]; }
        { users = [ "jorink" ]; noPass = true; cmd = "systemctl"; args = [ "reboot" ]; }
        { users = [ "jorink" ]; noPass = true; cmd = "systemctl"; args = [ "poweroff" ]; }
        { users = [ "jorink" ]; noPass = true; }
      ];
    };
  };
}
