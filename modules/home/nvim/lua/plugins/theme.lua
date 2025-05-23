return {
	"catppuccin/nvim",
	name = "catppuccin",
	priority = 1000, -- make sure to load this before all the other start plugins
	config = function()
		require("catppuccin").setup({
			default_integrations = true,
		})
		vim.cmd.colorscheme("catppuccin")
		vim.cmd.hi("Comment gui=none")
	end,
}
