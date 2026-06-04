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
	{ "<leader>pa", ":ProjectAdd<CR>", noremap = true, silent = false, desc = "Project Add", mode = { "n" } },
	{ "<leader>pp", function() require("project.extensions.snacks").pick() end, noremap = true, silent = false, desc = "Project picker", mode = { "n" }, },
	{ "<leader>pc", ":ProjectConfig<CR>", noremap = true, silent = false, desc = "Project Config", mode = { "n" } },
	{ "<leader>pd", ":ProjectDelete<CR>", noremap = true, silent = false, desc = "Project Delete", mode = { "n" } },
	{ "<leader>pe", ":ProjectExport<CR>", noremap = true, silent = false, desc = "Project Export", mode = { "n" } },
	{ "<leader>ph", ":ProjectHealth<CR>", noremap = true, silent = false, desc = "Project Health", mode = { "n" } },
	{ "<leader>pH", ":ProjectHistory<CR>", noremap = true, silent = false, desc = "Project History", mode = { "n" } },
	{ "<leader>pi", ":ProjectImport<CR>", noremap = true, silent = false, desc = "Project Import", mode = { "n" } },
	{ "<leader>pR", ":ProjectRoot<CR>", noremap = true, silent = false, desc = "Project Root", mode = { "n" } },
	{ "<leader>pr", ":ProjectRecents<CR>", noremap = true, silent = false, desc = "Project Recents", mode = { "n" } },
	{ "<leader>ps", ":ProjectSession<CR>", noremap = true, silent = false, desc = "Project Session", mode = { "n" } },
}
