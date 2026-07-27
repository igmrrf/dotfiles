return {
	"xdagiz/jjui.nvim",
	keys = {
		{
			"<leader>jj",
			function()
				require("jjui").open()
			end,
			mode = { "n" },
			desc = "Open jjui",
		},
		{
			"<leader>jt",
			function()
				require("jjui").toggle()
			end,
			mode = { "n" },
			desc = "Toggle jjui",
		},
	},
	opts = {},
}
