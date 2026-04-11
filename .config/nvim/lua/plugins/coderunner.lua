vim.pack.add({
	{ src = "CRAG666/code_runner.nvim" },
})

local keys = {
	{ "<leader>rr", ":RunCode<CR>", noremap = true, silent = false, desc = "RunCode", mode = { "n" } },
	{ "<leader>rf", ":RunFile<CR>", noremap = true, silent = false, desc = "RunFile", mode = { "n" } },
	{ "<leader>rft", ":RunFile tab<CR>", noremap = true, silent = false, desc = "Run File tab", mode = { "n" } },
	{ "<leader>rp", ":RunProject<CR>", noremap = true, silent = false, desc = "Run Project", mode = { "n" } },
	{ "<leader>rc", ":RunClose<CR>", noremap = true, silent = false, desc = "RunClose", mode = { "n" } },
	{ "<leader>Rrf", ":CRFiletype<CR>", noremap = true, silent = false, desc = "CRFiletype", mode = { "n" } },
	{ "<leader>Rrp", ":CRProjects<CR>", noremap = true, silent = false, desc = "CRProjects", mode = { "n" } },
}

require("code_runner").setup({})

local utils = require("utils")

utils.map_plugin_keys(keys)
