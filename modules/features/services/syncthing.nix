{ ... }: {
  flake.nixosModules.syncthing = { ... }: {
    services.syncthing = {
      enable = true;
      user = "jorink";
      dataDir = "/home/jorink";
      configDir = "/home/jorink/.config/syncthing";
      openDefaultPorts = true;

      settings = {
        devices.victus.id = "RB5HBV7-H5WJGZR-HWWVEWL-IMYWQWV-LR5M6DE-SGPTT7T-MJH4TOD-DE7L5QR";
        devices.nixpad.id = "IYAEDFY-TCF3NRB-TWSJNOR-CGPH3FX-THK5DCI-RU4B22L-UIINIWE-36CCTQP";
        devices.nixnuc.id = "TFOQX2M-J6RNRVE-PZAHUXB-KI7SJ7O-63WI4S4-YJMTUXD-MMPMBWY-EQBHOQC";
        folders."repos" = {
          path = "/home/jorink/repos";
          devices = [
            "victus"
            "nixpad"
            "nixnuc"
          ];
        };
      };
    };
    preservation.preserveAt."/persistent" = {
      users.jorink.directories = [
        ".config/syncthing"
      ];
    };
  };
}
