{ ... }: {
  flake.nixosModules.syncthing = { ... }: {
    services.syncthing = {
      enable = true;
      user = "jorink";
      dataDir = "/home/jorink";
      # configDir = "/home/jorink/.config/syncthing";
      openDefaultPorts = true;

      settings = {
        devices.victus.id = "VGATET5-RRWQCIT-AADHMV4-443VIKB-QDVRAC4-J4B2DF5-LAH6JCH-T7Z2BAI";
        devices.nixpad.id = "2Y3XEMG-XPLTYRA-BDQZO5U-BVX2Y7J-NH5LZWT-CHTNPDZ-BV3LXUV-OJWCXAL";
        devices.nixnuc.id = "EGPWGET-OFK5A7C-MRSDPKH-HIMT3RG-GCNBKRM-P5B7YZI-7UKDCCR-BKG23QY";
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
  };
}
