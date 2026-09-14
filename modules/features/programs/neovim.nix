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

        extraPlugins = {
          vim-be-good.package = pkgs.vimPlugins.vim-be-good;
        };

        luaConfigRC.netrwStartup = ''
          vim.api.nvim_create_autocmd("VimEnter", {
            callback = function()
              if vim.fn.argc() == 0 then
                vim.cmd("Explore")
              end
            end,
          })
        '';

        keymaps = [
          {
            key = "<C-d>";
            mode = ["n" "v"];
            silent = true;
            action = "<C-d>zz";
          }
          {
            key = "<C-u>";
            mode = ["n" "v"];
            silent = true;
            action = "<C-u>zz";
          }
        ];

        autopairs.nvim-autopairs.enable = true;
        comments.comment-nvim.enable = true;
        utility.surround.enable = true;
        tabline.nvimBufferline.enable = true;

        visuals = {
          indent-blankline.enable = true;
          nvim-web-devicons.enable = true;
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
