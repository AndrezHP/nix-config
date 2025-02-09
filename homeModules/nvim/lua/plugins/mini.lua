return { -- Collection of various small independent plugins/modules
	"echasnovski/mini.nvim",
	config = function()
		-- Better Around/Inside textobjects
		--
		-- Examples:
		--  - va)  - [V]isually select [A]round [)]paren
		--  - yinq - [Y]ank [I]nside [N]ext [']quote
		--  - ci'  - [C]hange [I]nside [']quote
		require("mini.ai").setup({ n_lines = 500 })

		-- Add/delete/replace surroundings (brackets, quotes, etc.)
		--
		-- - saiw) - [S]urround [A]dd [I]nner [W]ord [)]Paren
		-- - sd'   - [S]urround [D]elete [']quotes
		-- - sr)'  - [S]urround [R]eplace [)] [']
		require("mini.surround").setup()

		-- Key mappings for jumping to next/previous *whatever*
		-- using [ and ] along with the given type
		-- example:
		-- - ]q > next quickfix entry
		-- - ]i > next indent change
		-- - ]c > next comment block
		-- - ]d > next diagnostic
		require("mini.bracketed").setup()

		-- Other nice stuff
		require("mini.splitjoin").setup() -- toggle split/join on function arguments or structs <leader>gS
		require("mini.move").setup() -- move any selected block (setup keymapping)
		require("mini.git").setup() -- execute git commands from neovim with :Git
		require("mini.comment").setup()
		require("mini.pairs").setup()
		require("mini.operators").setup({
			replace = {
				prefix = "<leader>gr",
			},
		})
		require("mini.files").setup() -- small window where you can create and rename files
		vim.keymap.set("n", "<leader>of", "<CMD>lua MiniFiles.open()<CR>")

		-- require("mini.jump").setup() -- extend f, F, t, T to work on multiple lines
	end,
}
