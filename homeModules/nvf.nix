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
      extraPackages = [];
      lazy.plugins = {
        "harpoon" = {
          enable = true;
          package = pkgs.vimPlugins.harpoon;
          setupModule = "harpoon";
          setupOpts = {
            option_name = true;
          };
          keys = [
            {
              key = "<leader>a";
              action = "function() harpoon:list():add() end";
              mode = "n";
            }
            {
              key = "<C-e>";
              action = "function() harpoon.ui.toggle_quick_menu(harpoon:list()) end";
              mode = "n";
            }
          ];
        };
      };
      startPlugins = [
        pkgs.vimPlugins.oil-nvim
        pkgs.vimPlugins.leetcode-nvim
        pkgs.vimPlugins.plenary-nvim
      ];
      viAlias = false;
      vimAlias = true;

      # Theme
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
        rust = {
          enable = true;
          crates.enable = true;
        };
        clang.enable = true;
        nix.enable = true;
        go.enable = true;
        python.enable = true;
        zig.enable = true;
        lua.enable = true;
        haskell.enable = true;
        ocaml.enable = true;
        java.enable = true;
        php.enable = true;
        ## Web stuff
        ts.enable = true;
        svelte.enable = true;
        ruby.enable = true;
        css.enable = true;
        ## Etc
        sql.enable = true;
        bash.enable = true;
        assembly.enable = true;

        markdown.enable = true;
        nu.enable = true;
      };

      # Nice stuff
      visuals = {
        fidget-nvim.enable = true;
        highlight-undo.enable = true;
        cinnamon-nvim.enable = true;
      };

      # Built in plugins
      telescope.enable = true;
      autocomplete.nvim-cmp.enable = true;
      autopairs.nvim-autopairs.enable = true;
      snippets.luasnip.enable = true;
      # filetree.neo-tree.enable = true;
      treesitter.context.enable = true;
      comments.comment-nvim.enable = true;
      binds.whichKey.enable = true;
      binds.cheatsheet.enable = true;

      # Notes stuff
      notes.neorg.enable = true;
      notes.todo-comments.enable = true;

      # Git stuff
      git = {
        enable = true;
        gitsigns.enable = true;
      };

      # Keymaps obviously
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

      # Straight lua config
      luaConfigRC.TextYankPost = ''
        vim.api.nvim_create_autocmd("TextYankPost", {
          desc = "Highlight when yanking (copying) text",
          group = vim.api.nvim_create_augroup("highlight-yank", { clear = true }),
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
        require("leetcode").setup()

      '';

      extraLuaFiles = [];
    };
  };
}
