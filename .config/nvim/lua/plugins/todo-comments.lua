return {
	"folke/todo-comments.nvim",
	event = { "BufReadPost", "BufNewFile" },
	cmd = { "TodoQuickFix", "TodoLocList", "TodoTelescope", "TodoTrouble" },
	dependencies = { "nvim-lua/plenary.nvim" },
	opts = {},
}
