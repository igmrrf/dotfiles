vim.pack.add({ "https://github.com/akinsho/toggleterm.nvim" })

require("toggleterm").setup({
	size = 20,
	open_mapping = [[<c-/>]], -- The standard shortcut: Control + Backslash
	direction = 'float', -- 'vertical' | 'horizontal' | 'tab' | 'float'
	float_opts = {
		border = 'curved', -- 'single' | 'double' | 'shadow' | 'curved'
	},
})


-- Optional: Better window navigation inside the terminal
function _G.set_terminal_keymaps()
	local opts = { buffer = 0 }
	vim.keymap.set('t', '<C-]>', [[<C-\><C-n>]], opts)
	vim.keymap.set('t', '<C-h>', [[<Cmd>wincmd h<CR>]], opts)
	vim.keymap.set('t', '<C-j>', [[<Cmd>wincmd j<CR>]], opts)
	vim.keymap.set('t', '<C-k>', [[<Cmd>wincmd k<CR>]], opts)
	vim.keymap.set('t', '<C-l>', [[<Cmd>wincmd l<CR>]], opts)
end

vim.cmd('autocmd! TermOpen term://* lua set_terminal_keymaps()')

-- https://github.com/numtostr/fterm.nvim
-- local fterm = require("FTerm")
--
-- local lzgui = fterm:new({
-- 	cmd = "lazygit",
-- 	dimensions = {
-- 		height = 0.9,
-- 		width = 0.9
-- 	}
-- })
--
-- local btopui = fterm:new({
-- 	cmd = "btop",
-- 	dimensions = {
-- 		height = 0.9,
-- 		width = 0.9
-- 	}
-- })
--
-- -- Use this to toggle gitui in a floating terminal
-- vim.keymap.set('n', '<leader>gg', function() lzgui:toggle() end)
-- vim.keymap.set('n', '<leader>gb', function() btopui:toggle() end)
--
