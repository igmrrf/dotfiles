-- Tab-scoped buffers: `:ls`, bufferline and the snacks buffer picker only ever
-- show the buffers of the current tabpage, which is what makes one-tab-per-
-- project (see lua/projects.lua) actually feel separate.
--
-- The tab -> buffer map is persisted through scope.nvim's own resession
-- extension (enabled in lua/plugins/sessions.lua), so a restored session keeps
-- each tab's hidden buffers instead of collapsing them to whatever was visible.
return {
	"tiagovla/scope.nvim",
	lazy = false,
	priority = 900,
	keys = {
		{ "<leader>bD", "<cmd>ScopeMoveBuf<cr>", desc = "Move buffer to another tab" },
		{ "<leader>bL", "<cmd>ScopeList<cr>", desc = "List buffers per tab" },
	},
	opts = {},
	config = function(_, opts)
		require("scope").setup(opts)
	end,
}
