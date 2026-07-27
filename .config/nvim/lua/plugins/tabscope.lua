return {
	"backdround/tabscope.nvim",
	event = "BufReadPre",
	keys = {
		{
			"<leader>bD",
			function()
				require("tabscope").remove_tab_buffer()
			end,
			desc = "Remove tab local buffer",
		},
	},
	opts = {},
}
