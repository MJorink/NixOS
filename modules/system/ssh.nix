# sshd started by its socket on the first connection: no daemon at idle.
{
  flake.modules.nixos.ssh = {
    services.openssh = {
      enable = true;
      startWhenNeeded = true;
      settings = { PasswordAuthentication = false; PermitRootLogin = "no"; };
      hostKeys = [ { path = "/persist/etc/ssh/ssh_host_ed25519_key"; type = "ed25519"; } ];
    };
  };
}
