vim.pack.add({
	{ src = "https://github.com/stevearc/oil.nvim" },
})

local utils = require("utils")

local keys = {
	{ "<leader>e", "<CMD>Oil --float --preview<CR>", desc = "Open parent directory with Oil" },
}

utils.map_plugin_keys(keys)

require("oil").setup({

	keymaps = {
		["z"] = { "actions.parent", mode = "n" },
		["<leader>e"] = { "actions.close", mode = "n" },
	},
	skip_confirm_for_simple_edits = true,

	float = {
		padding = 2,
		max_width = 0.8,
		max_height = 0.8,
	},
})
