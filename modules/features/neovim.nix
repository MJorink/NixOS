{inputs, ...}: {
  flake.nixosModules.neovim = {
    lib,
    pkgs,
    ...
  }: {
    imports = [inputs.nvf.nixosModules.default];

    programs.nvf = {
      enable = true;

      settings.vim = {
        statusline.lualine.enable = true;
        telescope.enable = true;
        lsp = {
          enable = true;
          formatOnSave = true;
          trouble.enable = true;
        };
        autocomplete.blink-cmp.enable = true;
        binds.whichKey.enable = true;

        undoFile.enable = true;
        searchCase = "smart";

        clipboard = {
          enable = true;
          registers = "unnamedplus";
        };

        mini.hues = {
          enable = true;
          setupOpts = {
            background = "#231d1b";
            foreground = "#e6dbd3";
            accent = "orange";
          };
        };

        autopairs.nvim-autopairs.enable = true;
        comments.comment-nvim.enable = true;
        utility.surround.enable = true;
        tabline.nvimBufferline.enable = true;

        visuals = {
          indent-blankline.enable = true;
          nvim-web-devicons.enable = true;
        };

        keymaps = [
          {
            key = "<leader>f/";
            mode = "n";
            silent = true;
            action = "<cmd>Telescope current_buffer_fuzzy_find<CR>";
            desc = "Fuzzy find in current buffer [Telescope]";
          }
        ];

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
            format.type = ["csharpier"];
          };
        };
      };
    };
  };
}
