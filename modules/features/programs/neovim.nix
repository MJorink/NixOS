{inputs, ...}: {
  flake.nixosModules.neovim = {
    lib,
    pkgs,
    ...
  }: {
    imports = [inputs.nvf.nixosModules.default];

    programs.nvf = {
      enable = true;

      extraPlugins = {
        vim-be-good.package = pkgs.vimPlugins.vim-be-good;
      };

      settings.vim = {
        globals.mapleader = " ";

        autocomplete.blink-cmp.enable = true;

        binds.whichKey.enable = true;

        undoFile.enable = true;

        utility.undotree.enable = true;

        searchCase = "smart";

        autopairs.nvim-autopairs.enable = true;

        comments.comment-nvim.enable = true;

        utility.surround.enable = true;

        tabline.nvimBufferline.enable = true;

        statusline.lualine.enable = true;

        telescope.enable = true;

        navigation.harpoon.enable = true;

        lsp = {
          enable = true;
          formatOnSave = true;
          trouble.enable = true;
        };

        options = {
          shiftwidth = 2;
          tabstop = 2;
          softtabstop = 2;
          hlsearch = false;
          incsearch = true;
          scrolloff = 8;
          updatetime = 50;
        };

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

        luaConfigRC.netrwStartup = ''
          vim.api.nvim_create_autocmd("VimEnter", {
            callback = function()
              if vim.fn.argc() == 0 then
                vim.cmd("Explore")
              end
            end,
          })
        '';

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

        keymaps = [
          {
            key = "<C-d>";
            mode = [
              "n"
              "v"
            ];
            silent = true;
            action = "<C-d>zz";
          }
          {
            key = "<leader>pv";
            mode = ["n"];
            silent = true;
            action = "<Cmd>Ex<CR>";
          }
          {
            key = "<leader>u";
            mode = ["n"];
            silent = true;
            action = "<Cmd>UndotreeToggle<CR>";
          }
          {
            key = "<C-u>";
            mode = [
              "n"
              "v"
            ];
            silent = true;
            action = "<C-u>zz";
          }
          {
            key = "J";
            mode = ["v"];
            silent = true;
            action = ":m '>+1<CR>gv=gv";
          }
          {
            key = "K";
            mode = ["v"];
            silent = true;
            action = ":m '<-2<CR>gv=gv";
          }
          {
            key = "J";
            mode = ["n"];
            silent = true;
            action = "mzJ`z";
          }
          {
            key = "n";
            mode = ["n"];
            silent = true;
            action = "nzzzv";
          }
          {
            key = "N";
            mode = ["n"];
            silent = true;
            action = "Nzzzv";
          }
        ];
      };
    };
  };
}
