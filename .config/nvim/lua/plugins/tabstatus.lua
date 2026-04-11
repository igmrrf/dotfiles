vim.pack.add({
	"https://github.com/backdround/tabscope.nvim",
	"https://github.com/nvim-tree/nvim-web-devicons",
	"https://github.com/nvim-lualine/lualine.nvim",
	"https://github.com/akinsho/bufferline.nvim",
})
-- Initialize tabscope
require("tabscope").setup({})
-- To remove tab local buffer
vim.keymap.set("n", "<leader>bd", require("tabscope").remove_tab_buffer)

-- Initialize tabscope
require('lualine').setup ({
	options = {
		component_separators = '|',
		section_separators = { left = '', right = '' },
	},
})

-- Initialize tabscope
require("bufferline").setup({
	options = {
		separator_slant = "slant",
		diagnostic = "nvim_lsp"
	}
})
