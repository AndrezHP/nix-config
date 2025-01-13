{
  lib,
  outputs,
  inputs,
  specialArgs,
  config,
  options,
  modulesPath,
  pkgs,
}: {
  programs.nvf = {
    enable = true;

    settings.vim = {
      # Custom imported plugin
      extraPlugins = with pkgs.vimPlugins; {
        harpoon = {
          package = harpoon;
          setup = "require('harpoon').setup {}";
          # after = ["aerial"]; # place harpoon configuration after aerial
        };
      };
      startPlugins = [
        pkgs.vimPlugins.oil-nvim
        # "harpoon"
        # "oil-nvim" # Does not work :(
        # "blink-cmp"
      ];
      viAlias = false;
      vimAlias = true;

      theme = {
        enable = true;
        name = "catppuccin";
        style = "mocha";
        transparent = false;
      };
      statusline.lualine = {
        enable = true;
        theme = "catppuccin";
      };

      # Globals
      globals = {
        mapleader = " ";
        maplocalleader = " ";
        have_nerd_font = true;
      };

      # Options
      options = {
        number = true;
        relativenumber = false;
        mouse = "a";
        clipboard = "unnamedplus";
        breakindent = true;
        undofile = true;
        ignorecase = true;
        smartcase = true;
        signcolumn = "yes";
        updatetime = 250;
        timeoutlen = 300;
        splitright = true;
        splitbelow = true;
        list = true;
        inccommand = "split";
        cursorline = true;
        scrolloff = 10;
        hlsearch = true;
      };

      # LSP stuff
      lsp = {
        enable = true;
        formatOnSave = true;
        trouble.enable = true;
        lspSignature.enable = true;
      };

      # Debugger stuff
      debugger.nvim-dap = {
        enable = true;
        ui.enable = true;
      };

      # Language stuff
      languages = {
        enableDAP = true;
        enableFormat = true;
        enableLSP = true;
        enableTreesitter = true;

        # Languages
        nix.enable = true;
        rust.enable = true;
        rust.crates.enable = true;
        go.enable = true;
        python.enable = true;
        clang.enable = true;
        zig.enable = true;
        ts.enable = true;
        lua.enable = true;
        haskell.enable = true;
        bash.enable = true;
        svelte.enable = false;
        assembly.enable = true;
        ocaml.enable = true;
        sql.enable = true;
        java.enable = true;
      };

      visuals = {
        fidget-nvim.enable = true;
        highlight-undo.enable = true;
        cinnamon-nvim.enable = true;
      };
      telescope.enable = true;
      autocomplete.nvim-cmp.enable = true;
      autopairs.nvim-autopairs.enable = true;
      snippets.luasnip.enable = true;
      filetree.neo-tree.enable = true;
      treesitter.context.enable = true;
      comments.comment-nvim.enable = true;

      binds = {
        whichKey.enable = true;
        cheatsheet.enable = true;
      };
      notes = {
        neorg.enable = true;
        todo-comments.enable = true;
      };
      git = {
        enable = true;
        gitsigns.enable = true;
      };

      keymaps = [
        # {key=""; mode=[""]; silent=true; action=""; desc="";}
        {
          key = "<ESC>";
          mode = ["n"];
          action = "<cmd>nohlsearch<CR>";
          desc = "";
        }
        {
          key = "[d";
          mode = ["n"];
          action = "vim.diagnostic.goto_prev";
          desc = "Go to previous [D]iagnostic message";
        }
        {
          key = "]d";
          mode = ["n"];
          action = "vim.diagnostic.goto_next";
          desc = "Go to next [D]iagnostic message";
        }
        {
          key = "<leader>e";
          mode = ["n"];
          action = "vim.diagnostic.open_float";
          desc = "Show diagnostic [E]rror messages";
        }
        {
          key = "<leader>q";
          mode = ["n"];
          action = "vim.diagnostic.setloclist";
          desc = "Open diagnostic [Q]uickfix list";
        }
        {
          key = "<Esc><Esc>";
          mode = ["t"];
          silent = true;
          action = "<C-\\><C-n>";
          desc = "Exit terminal mode";
        }
      ];

      # Straight lua part of config
      luaConfigRC.TextYankPost = ''
        vim.api.nvim_create_autocmd("TextYankPost", {
          desc = "Highlight when yanking (copying) text",
          group = vim.api.nvim_create_augroup("kickstart-highlight-yank", { clear = true }),
          callback = function()
            vim.highlight.on_yank()
          end,
        })

        vim.cmd("set expandtab")
        vim.cmd("set tabstop=2")
        vim.cmd("set softtabstop=2")
        vim.cmd("set shiftwidth=2")

        local options = {
          ui = {
            -- If you have a Nerd Font, set icons to an empty table which will use the
            -- default lazy.nvim defined Nerd Font icons otherwise define a unicode icons table
            icons = vim.g.have_nerd_font and {} or {
              cmd = "⌘",
              config = "🛠",
              event = "📅",
              ft = "📂",
              init = "⚙",
              keys = "🗝",
              plugin = "🔌",
              runtime = "💻",
              require = "🌙",
              source = "📄",
              start = "🚀",
              task = "📌",
              lazy = "💤 ",
            },
          },
        }
        require("oil").setup()
      '';

      # Plugins needed
      # require("plugins.vim-tmux-navigator"),
      # { "numToStr/Comment.nvim", opts = {} },
      # { -- Adds git related signs to the gutter, as well as utilities for managing changes
      # 	"lewis6991/gitsigns.nvim",
      # 	opts = {
      # 		signs = {
      # 			add = { text = "+" },
      # 			change = { text = "~" },
      # 			delete = { text = "_" },
      # 			topdelete = { text = "‾" },
      # 			changedelete = { text = "~" },
      # 		},
      # 	},
      # },
      # require("plugins.telescope"),
      # 		{ "folke/neodev.nvim", opts = {} },
      # 		{ "j-hui/fidget.nvim", opts = {} },
    };
  };
}
