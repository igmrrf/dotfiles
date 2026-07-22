vim.pack.add({
	"https://github.com/folke/which-key.nvim",
})
require("which-key").setup({
	preset = "helix",
})

require("which-key").add({
	{ "<leader>A", group = "Arduino" },
	{ "<leader>b", group = "Buffer" },
	{ "<leader>c", group = "Code" },
	{ "<leader>d", group = "Debug" },
	{ "<leader>h", group = "Health" },
	{ "<leader>o", group = "Obsidian" },
	{ "<leader>p", group = "Pack+Project" },
	{ "<leader>q", group = "Quit" },
	{ "<leader>s", group = "Search" },
	{ "<leader>u", group = "UI/Toggles" },
	{ "<leader>v", group = "Venv" },
	{ "<leader>w", group = "Window/Save" },
	{ "<leader>x", group = "System" },
	{ "<leader><tab>", group = "Tabs" },
})
