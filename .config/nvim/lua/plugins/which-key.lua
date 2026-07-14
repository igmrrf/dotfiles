vim.pack.add({
	"https://github.com/folke/which-key.nvim",
})

vim.cmd.packadd("which-key.nvim")

require("which-key").setup()
