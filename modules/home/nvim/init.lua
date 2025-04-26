vim.g.mapleader = " "
vim.g.maplocalleader = " "
vim.g.have_nerd_font = true -- If Nerd Font installed
-- [[ Setting options ]] -- See `:help vim.opt` - For more options, you can see `:help option-list`
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.mouse = "a"
vim.opt.showmode = false -- Already in status line
vim.opt.clipboard = "unnamedplus" -- Sync clipboard with OS
vim.opt.breakindent = true -- Enable break indent
vim.opt.undofile = true -- Save undo history
vim.opt.ignorecase = true -- Case-insensitive searching UNLESS \C or capital in search
vim.opt.smartcase = true
vim.opt.signcolumn = "yes" -- Keep signcolumn on by default
vim.opt.updatetime = 250 -- Decrease update time
-- Decrease mapped sequence wait time - Displays which-key popup sooner
vim.opt.timeoutlen = 300

-- Configure how new splits should be opened
vim.opt.splitright = true
vim.opt.splitbelow = true

-- Sets how neovim will display certain whitespace in the editor.
vim.opt.list = true --  See `:help 'list'`
vim.opt.listchars = { tab = "» ", trail = "·", nbsp = "␣" } --  and `:help 'listchars'`
vim.opt.inccommand = "split" -- Preview substitutions live, as you type!
vim.opt.cursorline = true
vim.opt.scrolloff = 10

-- [[ Basic Keymaps ]] - See `:help vim.keymap.set()`
-- Set highlight on search, but clear on pressing <Esc> in normal mode
vim.opt.hlsearch = true
vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>")

-- Diagnostic keymaps
vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, { desc = "Go to previous [D]iagnostic message" })
vim.keymap.set("n", "]d", vim.diagnostic.goto_next, { desc = "Go to next [D]iagnostic message" })
vim.keymap.set("n", "<leader>e", vim.diagnostic.open_float, { desc = "Show diagnostic [E]rror messages" })
vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist, { desc = "Open diagnostic [Q]uickfix list" })

-- Resize vertical window splits with arrow keys
local moveLeftDesc = { expr = true, replace_keycodes = false, desc = "Decrease window width" }
vim.keymap.set("n", "<C-Left>", '"<Cmd>vertical resize -" . v:count1 . "<CR>"', moveLeftDesc)
local moveRightDesc = { expr = true, replace_keycodes = false, desc = "Increase window width" }
vim.keymap.set("n", "<C-Right>", '"<Cmd>vertical resize +" . v:count1 . "<CR>"', moveRightDesc)

-- Open and new file in insert mode
vim.keymap.set("n", "<leader>nf", "<cmd>ene | startinsert<CR>", { desc = "Open new file in insert mode" })

-- Setup inbuilt terminal with custom keymap to exit terminal mode
vim.keymap.set("t", "<Esc><Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })
vim.api.nvim_create_autocmd("TermOpen", {
	group = vim.api.nvim_create_augroup("custom-term-open", { clear = true }),
	callback = function()
		vim.opt.number = false
		vim.opt.relativenumber = false
	end,
})

-- Keybinds to make split navigation easier. See `:help wincmd` for a list of all window commands
vim.keymap.set("n", "<C-h>", "<C-w><C-h>", { desc = "Move focus to the left window" })
vim.keymap.set("n", "<C-l>", "<C-w><C-l>", { desc = "Move focus to the right window" })
vim.keymap.set("n", "<C-j>", "<C-w><C-j>", { desc = "Move focus to the lower window" })
vim.keymap.set("n", "<C-k>", "<C-w><C-k>", { desc = "Move focus to the upper winow" })

vim.api.nvim_create_autocmd("TextYankPost", { -- Highlight when yanking (copying) text
	desc = "Highlight when yanking (copying) text",
	group = vim.api.nvim_create_augroup("highlight-yank", { clear = true }),
	callback = function()
		vim.highlight.on_yank()
	end,
})

-- [[ Install `lazy.nvim` plugin manager ]] See `:help lazy.nvim.txt`
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	local lazyrepo = "https://github.com/folke/lazy.nvim.git"
	vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
end ---@diagnostic disable-next-line: undefined-field
vim.opt.rtp:prepend(lazypath)

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

require("lazy").setup({
	{ "tpope/vim-sleuth" }, -- Detect tabstop and shiftwidth automatically
	{ "mg979/vim-visual-multi" }, -- Multi cursor functionality = very nice
	{ "sindrets/diffview.nvim" },
	{ "nvim-tree/nvim-web-devicons" },
	{ "rmagatti/auto-session" }, -- Automatic session management
	{ "nvim-lualine/lualine.nvim", opts = { theme = "catpuccin" }, dependencies = { "nvim-tree/nvim-web-devicons" } },
	{ "windwp/nvim-autopairs", event = "InsertEnter", config = true },
	{ "nvim-neorg/neorg", version = "*", config = true },
	require("plugins.orgmode"),
	require("plugins.vim-tmux-navigator"),
	require("plugins.theme"),
	require("plugins.conform"),
	require("plugins.telescope"),
	require("plugins.harpoon"),
	require("plugins.snacks"),
	require("plugins.which-key"),
	require("plugins.mini"),
	require("plugins.todo-comments"),
	require("plugins.oil"),
	require("plugins.gitsigns"),
	require("plugins.zen-mode"),
	require("plugins.nvim-ts-autotag"),
	require("plugins.ts-comments"),
	-- TODO: add vim Dadbod for database stuff

	require("plugins.cmp"), -- Completion
	require("plugins.indent_line"),

	require("plugins.lsp-config"),
	require("plugins.treesitter"),
	require("plugins.debug"),
}, options)

vim.cmd("set expandtab")
vim.cmd("set tabstop=2")
vim.cmd("set softtabstop=2")
vim.cmd("set shiftwidth=2")

-- The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et
