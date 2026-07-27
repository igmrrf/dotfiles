return {
	"DrKJeff16/project.nvim",
	name = "project.nvim",
	event = { "VimEnter" },
	dependencies = { "folke/snacks.nvim" },
	opts = {
		snacks = {
			enabled = true,
			opts = {
				sort = "newest",
				hidden = false,
				title = "Select Project",
				layout = "select",
			},
		},
	},
	keys = {
		{ "<leader>P", ":Project<CR>", desc = "Project" },
		{ "<leader>pa", ":Project add<CR>", desc = "Project Add" },
		{ "<leader>pp", function() require("project.extensions.snacks").pick() end, desc = "Project picker" },
		{ "<leader>pc", ":Project config<CR>", desc = "Project Config" },
		{ "<leader>pd", ":Project delete<CR>", desc = "Project Delete" },
		{ "<leader>pe", ":Project export<CR>", desc = "Project Export" },
		{ "<leader>ph", ":Project health<CR>", desc = "Project Health" },
		{ "<leader>pH", ":Project history<CR>", desc = "Project History" },
		{ "<leader>pi", ":Project import<CR>", desc = "Project Import" },
		{ "<leader>pR", ":Project root<CR>", desc = "Project Root" },
		{ "<leader>pr", ":Project recents<CR>", desc = "Project Recents" },
		{ "<leader>ps", ":Project session<CR>", desc = "Project Session" },
	},
}
