return {
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
}
