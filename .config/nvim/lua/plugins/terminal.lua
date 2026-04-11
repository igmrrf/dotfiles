vim.pack.add({ "https://github.com/akinsho/toggleterm.nvim" })

require("toggleterm").setup({
	size = 20,
	open_mapping = [[<c-/>]], -- The standard shortcut: Control + Backslash
	direction = "float", -- 'vertical' | 'horizontal' | 'tab' | 'float'
	float_opts = {
		border = "curved", -- 'single' | 'double' | 'shadow' | 'curved'
	},
})

-- Optional: Better window navigation inside the terminal
function _G.set_terminal_keymaps()
	local opts = { buffer = 0 }
	vim.keymap.set("t", "<C-]>", [[<C-\><C-n>]], opts)
	vim.keymap.set("t", "<C-h>", [[<Cmd>wincmd h<CR>]], opts)
	vim.keymap.set("t", "<C-j>", [[<Cmd>wincmd j<CR>]], opts)
	vim.keymap.set("t", "<C-k>", [[<Cmd>wincmd k<CR>]], opts)
	vim.keymap.set("t", "<C-l>", [[<Cmd>wincmd l<CR>]], opts)
end

vim.cmd("autocmd! TermOpen term://* lua set_terminal_keymaps()")

local utils = require("utils")
local Terminal = require("toggleterm.terminal").Terminal
local lazygit = Terminal:new({ cmd = "lazygit", hidden = true })
local lazydocker = Terminal:new({ cmd = "lazydocker", hidden = true })
local btop = Terminal:new({ cmd = "btop", hidden = true })
local gemini = Terminal:new({ cmd = "gemini", hidden = true })
local geminiR = Terminal:new({ cmd = "gemini --resume", hidden = true })

-- stylua: ignore
local keys = {
	{ "<leader>gg", function() lazygit:toggle() end, desc = "Toggle Lazygit", mode = { "n" }, },
	{ "<leader>td", function() lazydocker:toggle() end, desc = "Toggle Lazydocker", mode = { "n" }, },
	{ "<leader>tg", function() gemini:toggle() end, desc = "Toggle gemini", mode = { "n" }, },
	{ "<leader>tG", function() geminiR:toggle() end, desc = "Toggle gemini --resume", mode = { "n" }, },
	{ "<leader>tb", function() btop:toggle() end, desc = "Toggle btop", mode = { "n" }, },
}
utils.map_plugin_keys(keys)
