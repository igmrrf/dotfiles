return {
	"folke/todo-comments.nvim",
	event = { "BufReadPost", "BufNewFile" },
	cmd = { "TodoQuickFix", "TodoLocList", "TodoTelescope", "TodoTrouble" },
	dependencies = { "nvim-lua/plenary.nvim" },
	opts = {},
	keys = {
		{ "]x", function() require("todo-comments").jump_next() end, desc = "Next Todo Comment", },
		{ "[x", function() require("todo-comments").jump_prev() end, desc = "Previous Todo Comment", },
	},
}
