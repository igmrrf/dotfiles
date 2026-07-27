return {
	"igmrrf/transparent.nvim",
	name = "transparent",
	event = "VimEnter",
	cmd = { "TransparentToggle", "TransparentEnable", "TransparentDisable" },
	opts = {
		enabled = true,
		listen = true,
	},
}
