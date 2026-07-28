return {
	"epwalsh/obsidian.nvim",
	ft = "markdown",
	dependencies = { "nvim-lua/plenary.nvim" },
	opts = {
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
	},
	keys = {
		{ "<leader>ot", ":ObsidianToday<CR>", desc = "Obsidian dailies" },
		{ "<leader>oT", ":ObsidianTemplate Today<CR>", desc = "Obsidian today template" },
	},
}
