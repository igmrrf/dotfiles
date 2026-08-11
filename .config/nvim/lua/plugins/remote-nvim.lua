return {
	"igmrrf/remote-nvim.nvim",
	enabled = false,
	version = "*", -- Pin to GitHub releases
	dependencies = {
		"nvim-lua/plenary.nvim",
		"MunifTanjim/nui.nvim",
	},
	config = function()
		require("remote-nvim").setup()
	end,
}
