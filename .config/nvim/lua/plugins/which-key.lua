return {
	"folke/which-key.nvim",
	event = "VimEnter",
	opts = {
		preset = "helix",
	},
	config = function(_, opts)
		local wk = require("which-key")
		wk.setup(opts)
		wk.add({
			{ "<leader>A", group = "Arduino" },
			{ "<leader>b", group = "Buffer" },
			{ "<leader>c", group = "Code" },
			{ "<leader>d", group = "Debug" },
			{ "<leader>h", group = "Health" },
			{ "<leader>o", group = "Obsidian" },
			{ "<leader>p", group = "Pack+Project" },
			{ "<leader>q", group = "Quit" },
			{ "<leader>r", group = "Refactor" },
			{ "<leader>s", group = "Search" },
			{ "<leader>u", group = "UI/Toggles" },
			{ "<leader>v", group = "Venv" },
			{ "<leader>w", group = "Window/Save" },
			{ "<leader>x", group = "System" },
			{ "<leader><tab>", group = "Tabs" },
		})
	end,
}
