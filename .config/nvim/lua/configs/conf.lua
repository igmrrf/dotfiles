vim.g.mapleader = " "
vim.g.mapgloballeader = " "

vim.filetype.add({
	extension = {
		kbd = "lisp",
	},
})
vim.cmd("colorscheme catppuccin")
-- require("vim._core.ui2").enable()
