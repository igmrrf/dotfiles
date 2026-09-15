return {
	"github/copilot.vim",
	event = { "BufWinEnter", "InsertEnter", "BufReadPost", "BufNewFile" },
	cmd = "Copilot",
	enabled = false,
	keys = {
		{ "<leader>ac", "<cmd>Copilot panel<CR>", desc = "Copilot Panel" },
		{ "<leader>as", "<cmd>Copilot status<CR>", desc = "Copilot Status" },
	},
	init = function()
		vim.g.copilot_no_maps = true
		vim.g.copilot_no_tab_map = true
	end,
	config = function()
		-- Block the normal Copilot suggestions
		vim.api.nvim_create_augroup("github_copilot", { clear = true })
		vim.api.nvim_create_autocmd({ "FileType", "BufUnload" }, {
			group = "github_copilot",
			callback = function(args)
				vim.fn["copilot#On" .. args.event]()
			end,
		})
		vim.fn["copilot#OnFileType"]()
	end,
}
