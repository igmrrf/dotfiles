vim.pack.add({
	{ src = "https://github.com/coffebar/neovim-project", name = "project" },
})

require("project").setup()
local utils = require("utils")

local keys = {
	{ "<leader>op", ":Project<CR>", noremap = true, silent = false, desc = "Project", mode = { "n" } },
	{ "<leader>oa", ":ProjectAdd<CR>", noremap = true, silent = false, desc = "Project Add", mode = { "n" } },
	{
		"<leader>op",
		function()
			require("project.extensions.snacks").pick()
		end,
		noremap = true,
		silent = false,
		desc = "Open project",
		mode = { "n" },
	},
	{ "<leader>Oc", ":ProjectConfig<CR>", noremap = true, silent = false, desc = "Project Config", mode = { "n" } },
	{ "<leader>Od", ":ProjectDelete<CR>", noremap = true, silent = false, desc = "Project Delete", mode = { "n" } },
	{ "<leader>Oe", ":ProjectExport<CR>", noremap = true, silent = false, desc = "Project Export", mode = { "n" } },
	{ "<leader>Oh", ":ProjectHealth<CR>", noremap = true, silent = false, desc = "Project Health", mode = { "n" } },
	{ "<leader>OH", ":ProjectHistory<CR>", noremap = true, silent = false, desc = "Project History", mode = { "n" } },
	{ "<leader>Oi", ":ProjectImport<CR>", noremap = true, silent = false, desc = "Project Import", mode = { "n" } },
	{ "<leader>OR", ":ProjectRoot<CR>", noremap = true, silent = false, desc = "Project Root", mode = { "n" } },
	{ "<leader>Or", ":ProjectRecents<CR>", noremap = true, silent = false, desc = "Project Recents", mode = { "n" } },
	{ "<leader>Os", ":ProjectSession<CR>", noremap = true, silent = false, desc = "Project Session", mode = { "n" } },
}

utils.map_plugin_keys(keys)
