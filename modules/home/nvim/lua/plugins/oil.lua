return {
	"stevearc/oil.nvim",
	---@module 'oil'
	-- @type oil.SetupOpts
	opts = {
		vim.keymap.set("n", "-", "<CMD>Oil<CR>", { desc = "Open parent directory" }),
	},
	dependencies = { "nvim-tree/nvim-web-devicons" },
}
