return {
	"folke/snacks.nvim",
	priority = 1000,
	lazy = false,
	opts = {
		bigfile = { enabled = true },
		input = { enabled = true },
		notifier = { enabled = true },
		quickfile = { enabled = true },
		statuscolumn = { enabled = true },
		words = { enabled = true },
	},

	keys = {
		{ "<leader>gb", function() require('snacks').git.blame_line() end,     desc = "Git blame for current line" },
		{ "<leader>cR", function() require('snacks').rename.rename_file() end, desc = "Rename File" },
		{ "<leader>gb", function() require('snacks').git.blame_line() end,     desc = "Git Blame Line" },
		{ "<leader>gf", function() require('snacks').lazygit.log_file() end,   desc = "Lazygit Current File History" },
		{ "<leader>lg", function() require('snacks').lazygit() end,            desc = "Lazygit" },
		{ "<leader>gl", function() require('snacks').lazygit.log() end,        desc = "Lazygit Log (cwd)" },
		{ "<leader>.",  function() require('snacks').scratch() end,            desc = "Toggle Scratch Buffer" },
		{ "<leader>S",  function() require('snacks').scratch.select() end,     desc = "Select Scratch Buffer" },
		{
			"<leader>gB",
			function() require('snacks').gitbrowse() end,
			desc = "Git Browse",
			mode = { "n", "v" }
		},
		{
			"<leader>N",
			desc = "Neovim News",
			function()
				require('snacks').win({
					file = vim.api.nvim_get_runtime_file("doc/news.txt", false)[1],
					width = 0.6,
					height = 0.6,
					wo = {
						spell = false,
						wrap = false,
						signcolumn = "yes",
						statuscolumn = " ",
						conceallevel = 3,
					},
				})
			end,
		},
		{ "<c-/>", function() require('snacks').terminal() end,                desc = "Toggle Terminal", mode = { "n", "t" }, },
		{ "]]",    function() require('snacks').words.jump(vim.v.count1) end,  desc = "Next Reference",  mode = { "n", "t" }, },
		{ "[[",    function() require('snacks').words.jump(-vim.v.count1) end, desc = "Prev Reference",  mode = { "n", "t" }, },
	},
}
