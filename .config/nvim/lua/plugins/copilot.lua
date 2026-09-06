return {
	-- Functionality: Integrates GitHub Copilot to provide AI-assisted code completions.
	-- Testing: Open any file, begin typing code or comments, and wait for ghost text to appear. Press `<C-y>` to accept the suggestion. Run `:Copilot status` to ensure it is active.
	"github/copilot.vim",
	event = { "InsertEnter", "BufReadPost", "BufNewFile" },
	cmd = "Copilot",
	keys = {
		{ "<leader>ac", "<cmd>Copilot panel<CR>", desc = "Copilot Panel" },
		{ "<leader>as", "<cmd>Copilot status<CR>", desc = "Copilot Status" },
	},
	config = function()
		vim.g.copilot_no_tab_map = true
		vim.api.nvim_set_keymap("i", "<C-Y>", 'copilot#Accept("<CR>")', { silent = true, expr = true })
	end,
}
