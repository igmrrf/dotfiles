vim.pack.add({
	"https://github.com/nvim-lua/plenary.nvim",
	{ src = "https://github.com/epwalsh/obsidian.nvim", name = "obsidian" },
})
vim.cmd.packadd("obsidian")

require("obsidian").setup({
	workspaces = {
		{
			name = "personal",
			path = "~/tldo",
		},
	},
	daily_notes = {
		folder = "dailies",
		date_format = "%Y-%m-%d",
	},
	templates = {
		folder = "templates",
	},
})
vim.keymap.set({ "n" }, "<leader>ot", ":ObsidianToday<CR>", { desc = "Obisidan dailies" })
vim.keymap.set({ "n" }, "<leader>oT", ":ObsidianTemplate Today<CR>", { desc = "Obisidan today template" })
