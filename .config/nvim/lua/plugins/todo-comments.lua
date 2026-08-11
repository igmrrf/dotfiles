return {
	"folke/todo-comments.nvim",
	event = { "BufReadPost", "BufNewFile" },
	cmd = { "TodoQuickFix", "TodoLocList", "TodoTelescope", "TodoTrouble" },
	dependencies = { "nvim-lua/plenary.nvim" },
	opts = {},
	keys = {
		{ "]t", function() require("todo-comments").jump_next() end, desc = "Next Todo Comment" },
		{ "[t", function() require("todo-comments").jump_prev() end, desc = "Previous Todo Comment" },
	},
}
