return { -- Useful plugin to show you pending keybinds.
	"folke/which-key.nvim",
	event = "VimEnter", -- Sets the loading event to 'VimEnter'
	config = function() -- This is the function that runs, AFTER loading
		require("which-key").setup()

		-- Document existing key chains
		require("which-key").register({
			["<leader>c"] = { name = "[C]ode", _ = "which_key_ignore" },
			["<leader>d"] = { name = "[D]ocument", _ = "which_key_ignore" },
			["<leader>r"] = { name = "[R]ename", _ = "which_key_ignore" },
			["<leader>s"] = { name = "[S]earch", _ = "which_key_ignore" },
			["<leader>w"] = { name = "[W]orkspace", _ = "which_key_ignore" },
		})
	end,
}

-- {
--   ["<leader>c"] = {
--     _ = "which_key_ignore",
--     name = "[C]ode"
--   },
--   ["<leader>d"] = {
--     _ = "which_key_ignore",
--     name = "[D]ocument"
--   },
--   ["<leader>r"] = {
--     _ = "which_key_ignore",
--     name = "[R]ename"
--   },
--   ["<leader>s"] = {
--     _ = "which_key_ignore",
--     name = "[S]earch"
--   },
--   ["<leader>w"] = {
--     _ = "which_key_ignore",
--     name = "[W]orkspace"
--   }
-- }
--
-- -- Suggested Spec:
-- {
--   { "<leader>c", group = "[C]ode" },
--   { "<leader>c_", hidden = true },
--   { "<leader>d", group = "[D]ocument" },
--   { "<leader>d_", hidden = true },
--   { "<leader>r", group = "[R]ename" },
--   { "<leader>r_", hidden = true },
--   { "<leader>s", group = "[S]earch" },
--   { "<leader>s_", hidden = true },
--   { "<leader>w", group = "[W]orkspace" },
--   { "<leader>w_", hidden = true },
-- }
