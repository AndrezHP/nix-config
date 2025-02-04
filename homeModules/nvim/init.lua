vim.g.mapleader = " "
vim.g.maplocalleader = " "
vim.g.have_nerd_font = true -- If Nerd Font installed
-- [[ Setting options ]] -- See `:help vim.opt`
-- For more options, you can see `:help option-list`
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
-- Decrease mapped sequence wait time
-- Displays which-key popup sooner
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

-- [[ Basic Keymaps ]]
--  See `:help vim.keymap.set()`

-- Set highlight on search, but clear on pressing <Esc> in normal mode
vim.opt.hlsearch = true
vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>")

-- Diagnostic keymaps
vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, { desc = "Go to previous [D]iagnostic message" })
vim.keymap.set("n", "]d", vim.diagnostic.goto_next, { desc = "Go to next [D]iagnostic message" })
vim.keymap.set("n", "<leader>e", vim.diagnostic.open_float, { desc = "Show diagnostic [E]rror messages" })
vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist, { desc = "Open diagnostic [Q]uickfix list" })

-- Resize windows with arrow keys
local moveLeftDesc = { expr = true, replace_keycodes = false, desc = "Decrease window width" }
vim.keymap.set("n", "<C-Left>", '"<Cmd>vertical resize -" . v:count1 . "<CR>"', moveLeftDesc)
local moveRightDesc = { expr = true, replace_keycodes = false, desc = "Increase window width" }
vim.keymap.set("n", "<C-Right>", '"<Cmd>vertical resize +" . v:count1 . "<CR>"', moveRightDesc)

-- local moveDownDesc = { expr = true, replace_keycodes = false, desc = "Decrease window height" }
-- vim.keymap.set("n", "<C-Down>", '"<Cmd>resize -"          . v:count1 . "<CR>"', moveDownDesc)
-- local moveUpDesc = { expr = true, replace_keycodes = false, desc = "Increase window height" }
-- vim.keymap.set("n", "<C-Up>", '"<Cmd>resize +"          . v:count1 . "<CR>"', moveUpDesc)

-- Open and new file in insert mode
vim.keymap.set("n", "<leader>nf", "<cmd>ene | startinsert<CR>", { desc = "Open new file in insert mode" })

-- Exit terminal mode in the builtin terminal with a shortcut that is a bit easier
-- for people to discover. Otherwise, you normally need to press <C-\><C-n>, which
-- is not what someone will guess without a bit more experience.
--
-- NOTE: This won't work in all terminal emulators/tmux/etc. Try your own mapping
-- or just use <C-\><C-n> to exit terminal mode
vim.keymap.set("t", "<Esc><Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })
vim.api.nvim_create_autocmd("TermOpen", {
	group = vim.api.nvim_create_augroup("custom-term-open", { clear = true }),
	callback = function()
		vim.opt.number = false
		vim.opt.relativenumber = false
	end,
})

-- TIP: Disable arrow keys in normal mode
vim.keymap.set("n", "<left>", '<cmd>echo "Use h to move!!"<CR>')
vim.keymap.set("n", "<right>", '<cmd>echo "Use l to move!!"<CR>')
vim.keymap.set("n", "<up>", '<cmd>echo "Use k to move!!"<CR>')
vim.keymap.set("n", "<down>", '<cmd>echo "Use j to move!!"<CR>')

-- Keybinds to make split navigation easier.
--  Use CTRL+<hjkl> to switch between windows
--  See `:help wincmd` for a list of all window commands
vim.keymap.set("n", "<C-h>", "<C-w><C-h>", { desc = "Move focus to the left window" })
vim.keymap.set("n", "<C-l>", "<C-w><C-l>", { desc = "Move focus to the right window" })
vim.keymap.set("n", "<C-j>", "<C-w><C-j>", { desc = "Move focus to the lower window" })
vim.keymap.set("n", "<C-k>", "<C-w><C-k>", { desc = "Move focus to the upper winow" })

-- [[ Basic Autocommands ]]
--  See `:help lua-guide-autocommands`
vim.api.nvim_create_autocmd("TextYankPost", { -- Highlight when yanking (copying) text
	desc = "Highlight when yanking (copying) text",
	group = vim.api.nvim_create_augroup("highlight-yank", { clear = true }),
	callback = function()
		vim.highlight.on_yank()
	end,
})

-- [[ Install `lazy.nvim` plugin manager ]]
--    See `:help lazy.nvim.txt` or https://github.com/folke/lazy.nvim for more info
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

-- remap open URL (only useful if using mini.operators)
vim.keymap.set("n", "<leader>gx", function()
	local url = vim.fn.expand("<cfile>")
	if url ~= "" then
		vim.cmd("silent !xdg-open " .. url .. " &")
	else
		print("No URL found under cursor")
	end
end, { silent = true, noremap = true })

require("lazy").setup({
	{
		"folke/ts-comments.nvim",
		opts = {},
		event = "VeryLazy",
		enabled = vim.fn.has("nvim-0.10.0") == 1,
	},
	{
		"windwp/nvim-ts-autotag",
		ops = {
			enable_close = true, -- Auto close tags
			enable_rename = true, -- Auto rename pairs of tags
			enable_close_on_slash = true, -- Auto close on trailing </
		},
		per_filetype = {
			["html"] = {
				enable_close = false,
			},
		},
	},
	{
		"iamcco/markdown-preview.nvim",
		cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
		ft = { "markdown" },
		build = function()
			vim.fn["mkdp#util#install"]()
		end,
	},

	{ "tpope/vim-sleuth" }, -- Detect tabstop and shiftwidth automatically
	{ "mg979/vim-visual-multi" }, -- Multi cursor functionality = very nice
	{ "ThePrimeagen/vim-be-good" },
	{ "sindrets/diffview.nvim" },
	{ "nvim-neorg/neorg", version = "*", config = true },
	{ "nvim-lualine/lualine.nvim", opts = { theme = "catpuccin" }, dependencies = { "nvim-tree/nvim-web-devicons" } },
	{ "windwp/nvim-autopairs", event = "InsertEnter", config = true },
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
	require("plugins.obsidian"),
	require("plugins.zen-mode"),
	-- require("plugins.noice"),
	-- TODO: add vim Dadbod for database stuff

	require("plugins.lsp-config"),
	require("plugins.treesitter"),
	require("plugins.cmp"), -- Completion

	require("plugins.debug"),
	require("plugins.indent_line"),
}, options)

vim.cmd("set expandtab")
vim.cmd("set tabstop=2")
vim.cmd("set softtabstop=2")
vim.cmd("set shiftwidth=2")

-- The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et
