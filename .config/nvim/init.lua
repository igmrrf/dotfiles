vim.g.mapleader = " "
vim.g.mapgloballeader = " "

vim.g.netrw_liststyle = 3
vim.g.netrw_banner = 0 -- help banner(0-1)
-- vim.g.netrw_browse_split = 4 -- where to open files (1-horiz,2-vert,3-net_tab,4-prev_win)
-- vim.g.netrw_winsize = 80
vim.g.netrw_altv = 1 -- vertical split (0-left, 1-right)

require("vim._core.ui2").enable()

vim.pack.add({ { src = "https://github.com/igmrrf/pack.nvim", version = "main" } })
vim.cmd.packadd("pack.nvim")

require("pack").setup({
	plugins = {
		{ "igmrrf/pack.nvim", branch = "main" },
		{ import = "plugins" },
	},
})

require("configs")
