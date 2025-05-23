return {
	"folke/zen-mode.nvim",
	opts = {
		window = {
			backdrop = 0.95,
			width = 120, -- width of the Zen window
			height = 1, -- height of the Zen window
			options = {
				signcolumn = "no", -- disable signcolumn
				number = false, -- disable number column
				relativenumber = false, -- disable relative numbers
			},
		},
		plugins = {
			options = {
				enabled = true,
				ruler = true, -- disables the ruler text in the cmd line area
				showcmd = false, -- disables the command in the last line of the screen
				laststatus = 0, -- turn off the statusline in zen mode
			},
			twilight = { enabled = false }, -- enable to start Twilight when zen mode opens
			gitsigns = { enabled = true }, -- disables git signs
			tmux = { enabled = true }, -- disables the tmux statusline
		},
	},
	keys = {
		{
			"<leader>z",
			function()
				require("zen-mode").toggle({
					window = {
						width = 0.85,
					},
				})
			end,
			desc = "Toggle Zen Mode",
		},
	},
}
