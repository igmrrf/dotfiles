vim.loader.enable()

vim.g.mapleader = " "
vim.g.mapgloballeader = " "

vim.pack.add({ { src = "https://github.com/igmrrf/pack.nvim", version = "main" } })
vim.cmd.packadd("pack.nvim")

require("pack").setup({
	plugins = {
		{ "igmrrf/pack.nvim", branch = "main" },
		{ import = "plugins" },
	},
})

require("configs")
