vim.pack.add({
	{ src = "https://github.com/igmrrf/transparent.nvim", name = "transparent" }
})

require("transparent").setup({
	enabled = true,
	listen = true,
})
