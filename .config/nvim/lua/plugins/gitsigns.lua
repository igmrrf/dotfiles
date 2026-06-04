vim.pack.add({
	{ src = "https://github.com/lewis6991/gitsigns.nvim", name = "gitsigns" },
})
vim.cmd.packadd("gitsigns")

local utils = require("utils")

utils.lazy_load_event("flash.nvim", { "BufReadPost" }, function()
	require("gitsigns").setup({})
end)
