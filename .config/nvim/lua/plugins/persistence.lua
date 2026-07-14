vim.pack.add({
	"https://github.com/folke/persistence.nvim",
})

vim.cmd.packadd("persistence.nvim")

require("persistence").setup({})
