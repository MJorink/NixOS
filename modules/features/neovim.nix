{ self, inputs, ... }: {
  flake.nixosModules.neovim = { lib, pkgs, ... }: {
    imports = [ inputs.nvf.nixosModules.default ];

    programs.nvf = {
      enable = true;

      settings.vim = {
        telescope.enable = true;
        lsp.enable = true;
        binds.whichKey.enable = true;

        filetree.nvimTree = {
          enable = true;
          mappings.toggle = "<leader>e";
        };

        terminal.toggleterm = {
          enable = true;
          lazygit.enable = true;
        };

        languages = {
          enableTreesitter = true;
          enableFormat = true;

          nix.enable = true;
          csharp = {
            enable = true;
            format.type = [ "csharpier" ];
          };
        };
      };
    };
  };
}
