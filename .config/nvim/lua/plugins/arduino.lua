vim.pack.add({
	{ src = "https://github.com/igmrrf/Arduino-Nvim" },
	{ src = "https://github.com/igmrrf/arduino_nvim", name = "arduino_nvim" },
})

vim.cmd.packadd("arduino_nvim")
require("arduino-nvim").setup({
	mode = "float", -- or "buffer"
	float_opts = {
		width = 0.8,
		height = 0.8,
		border = "rounded",
		title = " Arduino TUI ",
	},
})
-- vim.cmd.packadd("telescope.nvim")
local utils = require("utils")

utils.lazy_load_ft("Arduino-Nvim", { "arduino" }, function()
	vim.keymap.set("n", "<leader>Ac", ":!arduino-cli compile<CR>", { buffer = true, desc = "Compile arduino sketch" })

	vim.keymap.set("n", "<leader>Au", ":!arduino-cli upload<CR>", { buffer = true, desc = "Upload arduino sketch" })

	require("Arduino-Nvim").setup({ picker = "snacks" })
end)
