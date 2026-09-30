{ ... }: {
  flake.nixosModules.syncthing = { ... }: {
    services.syncthing = {
      enable = true;
      user = "jorink";
      dataDir = "/home/jorink";
      configDir = "/home/jorink/.config/syncthing";
      openDefaultPorts = true;

      # settings = {
      #   devices.victus.id = "VGATET5-RRWQCIT-AADHMV4-443VIKB-QDVRAC4-J4B2DF5-LAH6JCH-T7Z2BAI";
      #   folders."shared" = {
      #     path = "/home/jorink/repos";
      #     devices = [ "victus" ];
      #   };
      # };
    };
  };
}
