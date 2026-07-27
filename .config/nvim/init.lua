vim.loader.enable()

vim.g.mapleader = " "
vim.g.mapgloballeader = " "

vim.pack.add({ { src = "https://github.com/igmrrf/pack.nvim", branch = "main" } },{confirm = false})
vim.cmd.packadd("pack.nvim")

require("pack").setup({
	performance = {
		vim_loader = true,
	},
	ui = {
		border = "rounded",
	},
	plugins = {
		{ "igmrrf/pack.nvim", dir = "~/Desktop/packages/pack.nvim" },
		{ import = "plugins" },
	},
})

require("configs")
