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
})
