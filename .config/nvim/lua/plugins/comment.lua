vim.pack.add({
	"https://github.com/nvim-lua/plenary.nvim",
	"https://github.com/numToStr/Comment.nvim",
	"https://github.com/folke/todo-comments.nvim",
})

require("Comment").setup()

local keys = {
	{
		"]t",
		function()
			require("todo-comments").jump_next()
		end,
		desc = "Next Todo Comment",
	},
	{
		"[t",
		function()
			require("todo-comments").jump_prev()
		end,
		desc = "Previous Todo Comment",
	},
	{ "<leader>xt", "<cmd>Trouble todo toggle<cr>", desc = "Todo (Trouble)" },
	{
		"<leader>xT",
		"<cmd>Trouble todo toggle filter = {tag = {TODO, FIX, FIXME}}<cr>",
		desc = "Todo/Fix/Fixme (Trouble)",
	},
}

require("utils").map_plugin_keys(keys)
