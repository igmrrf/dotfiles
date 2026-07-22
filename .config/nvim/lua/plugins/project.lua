vim.pack.add({
	{ src = "https://github.com/folke/snacks.nvim" },
	{ src = "https://github.com/DrKJeff16/project.nvim" },
})
vim.cmd.packadd("project.nvim")
require("project").setup({
	snacks = {
		enabled = true,
		opts = {
			sort = "newest",
			hidden = false,
			title = "Select Project",
			layout = "select",
		},
	},
})
-- stylua: ignore
local keys = {
	{ "<leader>P", ":Project<CR>", noremap = true, silent = false, desc = "Project", mode = { "n" } },
	{ "<leader>pa", ":Project add<CR>", noremap = true, silent = false, desc = "Project Add", mode = { "n" } },
	{ "<leader>pp", function() require("project.extensions.snacks").pick() end, noremap = true, silent = false, desc = "Project picker", mode = { "n" }, },
	{ "<leader>pc", ":Project config<CR>", noremap = true, silent = false, desc = "Project Config", mode = { "n" } },
	{ "<leader>pd", ":Project delete<CR>", noremap = true, silent = false, desc = "Project Delete", mode = { "n" } },
	{ "<leader>pe", ":Project export<CR>", noremap = true, silent = false, desc = "Project Export", mode = { "n" } },
	{ "<leader>ph", ":Project health<CR>", noremap = true, silent = false, desc = "Project Health", mode = { "n" } },
	{ "<leader>pH", ":Project history<CR>", noremap = true, silent = false, desc = "Project History", mode = { "n" } },
	{ "<leader>pi", ":Project import<CR>", noremap = true, silent = false, desc = "Project Import", mode = { "n" } },
	{ "<leader>pR", ":Project root<CR>", noremap = true, silent = false, desc = "Project Root", mode = { "n" } },
	{ "<leader>pr", ":Project recents<CR>", noremap = true, silent = false, desc = "Project Recents", mode = { "n" } },
	{ "<leader>ps", ":Project session<CR>", noremap = true, silent = false, desc = "Project Session", mode = { "n" } },
}
local util = require("utils")
util.map_plugin_keys(keys)
