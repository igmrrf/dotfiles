return {
	"kristijanhusak/vim-dadbod-ui",
	dependencies = {
		{ "tpope/vim-dadbod", lazy = true },
		{ "kristijanhusak/vim-dadbod-completion", ft = { "sql", "mysql", "plsql" }, lazy = true },
	},
	cmd = {
		"DBUI",
		"DBUIToggle",
		"DBUIAddConnection",
		"DBUIFindBuffer",
	},
	init = function()
		-- DBUI settings
		vim.g.db_ui_use_nerd_fonts = 1
		vim.g.db_ui_show_database_icon = 1
		vim.g.db_ui_force_echo_notifications = 1
		vim.g.db_ui_winwidth = 35

		-- Set up dadbod-completion on SQL filetypes
		vim.api.nvim_create_autocmd("FileType", {
			pattern = { "sql", "mysql", "plsql" },
			callback = function()
				vim.opt_local.omnifunc = "vim_dadbod_completion#omni"
			end,
		})
	end,
	keys = {
		{ "<leader>Du", "<cmd>DBUIToggle<cr>", desc = "Toggle DB UI" },
		{ "<leader>Df", "<cmd>DBUIFindBuffer<cr>", desc = "Find DB Buffer" },
		{ "<leader>Dr", "<cmd>DBUIRenameBuffer<cr>", desc = "Rename DB Buffer" },
		{ "<leader>Dq", "<cmd>DBUILastQueryInfo<cr>", desc = "Last Query Info" },
		{ "<leader>Da", "<cmd>DBUIAddConnection<cr>", desc = "Add DB Connection" },
	},
}
