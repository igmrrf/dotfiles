vim.loader.enable()

vim.g.mapleader = " "
vim.g.mapgloballeader = " "

vim.pack.add({ { src = "https://github.com/igmrrf/pack.nvim", branch = "main" } }, { confirm = false })
vim.cmd.packadd("pack.nvim")

require("pack").setup({
	lazy = false,
	use_git = true,
	performance = {
		vim_loader = true,
	},
	ui = {
		border = "rounded",
		filter = "input",
	},
	plugins = {
		{
			"igmrrf/pack.nvim",
			keys = {
				{ "<leader>p", ":Pack<CR>", desc = "Pack Dashboard", silent = true },
			},
		},

		{ import = "plugins" },
	},
})

require("configs")
