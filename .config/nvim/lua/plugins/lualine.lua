return {
	"nvim-lualine/lualine.nvim",
	event = "VimEnter",
	dependencies = {
		"nvim-tree/nvim-web-devicons",
	},
	opts = {
		options = {
			theme = "gruvbox_dark",
			component_separators = { left = "│", right = "│" },
			section_separators = { left = "", right = "" },
			globalstatus = true,
			disabled_filetypes = {
				statusline = { "dashboard", "alpha", "snacks_dashboard" },
			},
		},
		sections = {
			lualine_a = {
				{ "mode", separator = { left = "", right = "" }, right_padding = 2 },
			},
			lualine_b = {
				{ "filename", file_status = true, path = 1 },
				{ "branch", icon = "󰘬" },
				{ "diff", symbols = { added = " ", modified = " ", removed = " " } },
			},
			lualine_c = {
				{
					"diagnostics",
					sources = { "nvim_diagnostic" },
					symbols = { error = "✗ ", warn = "⚠ ", info = "ℹ ", hint = "💡 " },
				},
			},
			lualine_x = {
				{
					function()
						local msg = "No LSP"
						local clients = vim.lsp.get_clients({ bufnr = 0 })
						if next(clients) == nil then
							return msg
						end
						local names = {}
						for _, client in ipairs(clients) do
							table.insert(names, client.name)
						end
						return "󰒋 " .. table.concat(names, ", ")
					end,
					color = { gui = "bold" },
				},
				"filetype",
			},
			lualine_y = { "progress" },
			lualine_z = {
				{ "location", separator = { left = "", right = "" }, left_padding = 2 },
			},
		},
	},
}
