{ inputs, ... }:
let
  keymap = key: mode: action: {
    inherit key mode action;
    silent = true;
  };

  vimSettings = pkgs: {
    # Core
    globals = {
      mapleader = " ";
      mkdp_browser = "librewolf";
    };

    options = {
      shiftwidth = 2;
      tabstop = 2;
      softtabstop = 2;
      hlsearch = false;
      incsearch = true;
      scrolloff = 8;
      updatetime = 50;
      wrap = false;
      guicursor = "n-v-i-c:block-Cursor";
    };

    searchCase = "smart";

    clipboard = {
      enable = true;
      registers = "unnamedplus";
    };

    undoFile.enable = true;

    # UI
    theme = {
      enable = true;
      name = "gruvbox";
      style = "dark";
    };

    statusline.lualine.enable = true;

    tabline.nvimBufferline.enable = true;

    visuals = {
      indent-blankline.enable = true;
      nvim-web-devicons.enable = true;
    };

    treesitter.context = {
      enable = true;
      setupOpts = {
        max_lines = 5;
        multiline_threshold = 1;
        trim_scope = "inner";
      };
    };

    # Editing
    autopairs.nvim-autopairs.enable = true;

    # Close with semicolon when editing a .nix file
    lazy.plugins.nvim-autopairs.after = ''
      local npairs = require("nvim-autopairs")
      for open, close in pairs({ ["{"] = "}", ["["] = "]" }) do
        npairs.get_rule(open):replace_endpair(function(opts)
          if vim.bo[opts.bufnr].filetype == "nix"
            and opts.line:sub(1, opts.col - 1):match("=%s*$") then
            return close .. ";"
          end
          return close
        end)
      end
    '';

    comments.comment-nvim.enable = true;

    utility.surround.enable = true;

    # Navigation
    telescope.enable = true;

    navigation.harpoon.enable = true;

    utility.undotree.enable = true;

    binds.whichKey.enable = true;

    luaConfigRC.netrwStartup = ''
      vim.api.nvim_create_autocmd("VimEnter", {
        callback = function()
          if vim.fn.argc() == 0 then
            vim.cmd("Explore")
          end
        end,
      })
    '';

    # Languages / LSP
    languages = {
      enableTreesitter = true;
      enableFormat = true;

      nix.enable = true;
      bash.enable = true;
      json.enable = true;
      toml.enable = true;
      markdown = {
        enable = true;
        extensions.render-markdown-nvim.enable = true;
      };
      csharp = {
        enable = true;
        lsp.servers = [ "roslyn-ls" ];
        format.type = [ "csharpier" ];
      };
    };

    lsp = {
      enable = true;
      trouble.enable = true;
    };

    # Tools
    terminal.toggleterm = {
      enable = true;
      lazygit.enable = true;
    };

    utility.preview.markdownPreview = {
      enable = true;
      alwaysAllowPreview = true;
    };

    assistant.copilot = {
      enable = true;
      setupOpts.suggestion.auto_trigger = true;
      mappings.suggestion = {
        accept = "<A-a>";
        acceptLine = "<A-l>";
        next = "<A-]>";
        prev = "<A-[>";
        dismiss = "<A-e>";
      };
    };

    extraPackages = [
      pkgs.nodejs-slim
    ];

    # Keymaps
    keymaps = [
      # Keep cursor centered
      (keymap "<C-d>" [ "n" "v" ] "<C-d>zz")
      (keymap "<C-u>" [ "n" "v" ] "<C-u>zz")
      (keymap "n" [ "n" ] "nzzzv")
      (keymap "N" [ "n" ] "Nzzzv")
      (keymap "(" [ "n" ] "(zzzv")
      (keymap ")" [ "n" ] ")zzzv")

      # Move/join lines
      (keymap "J" [ "v" ] ":m '>+1<CR>gv=gv")
      (keymap "K" [ "v" ] ":m '<-2<CR>gv=gv")
      (keymap "J" [ "n" ] "mzJ`z")

      # Leader binds
      (keymap "<leader>pv" [ "n" ] "<Cmd>Ex<CR>")
      (keymap "<leader>u" [ "n" ] "<Cmd>UndotreeToggle<CR>")
      (keymap "<leader>md" [ "n" ] "<Cmd>MarkdownPreviewToggle<CR>")
    ];
  };
in
{
  perSystem =
    { system, ... }:
    let
      pkgs = import inputs.nixpkgs {
        inherit system;
        config.allowUnfree = true;
      };
    in
    {
      packages.myNeovim =
        (inputs.nvf.lib.neovimConfiguration {
          inherit pkgs;
          modules = [ { vim = vimSettings pkgs; } ];
        }).neovim;
    };
}
