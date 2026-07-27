return {
	"ThePrimeagen/refactoring.nvim",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"nvim-treesitter/nvim-treesitter",
	},
	cmd = "Refactor",
	keys = {
		{
			"<leader>re",
			function()
				require("refactoring").select_refactor()
			end,
			mode = { "n", "v" },
			desc = "Select Refactor",
		},
		{
			"<leader>rf",
			function()
				require("refactoring").refactor("Extract Function")
			end,
			mode = "v",
			desc = "Extract Function",
		},
		{
			"<leader>rv",
			function()
				require("refactoring").refactor("Extract Variable")
			end,
			mode = "v",
			desc = "Extract Variable",
		},
		{
			"<leader>ri",
			function()
				require("refactoring").refactor("Inline Variable")
			end,
			mode = { "n", "v" },
			desc = "Inline Variable",
		},
		{
			"<leader>rb",
			function()
				require("refactoring").refactor("Extract Block")
			end,
			mode = "n",
			desc = "Extract Block",
		},
		{
			"<leader>rP",
			function()
				require("refactoring").debug.printf({ above = false })
			end,
			mode = "n",
			desc = "Debug Printf",
		},
		{
			"<leader>rp",
			function()
				require("refactoring").debug.print_var()
			end,
			mode = { "n", "v" },
			desc = "Debug Print Variable",
		},
		{
			"<leader>rc",
			function()
				require("refactoring").debug.cleanup({})
			end,
			mode = "n",
			desc = "Debug Cleanup",
		},
	},
	opts = {},
}
