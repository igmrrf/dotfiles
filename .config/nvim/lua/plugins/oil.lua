vim.pack.add({
	{ src = "https://github.com/stevearc/oil.nvim" },
})

local utils = require("utils")

local keys = {
	{ "<leader>e", "<CMD>Oil --float --preview<CR>", desc = "Open parent directory with Oil" },
}

utils.map_plugin_keys(keys)

utils.lazy_load_event("oil.nvim", { "CmdlineEnter" }, function()
	require("oil").setup()
end)
