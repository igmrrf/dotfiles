return {
	"nvim-lualine/lualine.nvim",
	event = "BufReadPre",
	dependencies = {
		"nvim-tree/nvim-web-devicons",
	},
	opts = {
		options = {
			theme = "auto",
			component_separators = { left = "│", right = "│" },
			section_separators = { left = "", right = "" },
			globalstatus = true,
			disabled_filetypes = {
				statusline = { "dashboard", "alpha", "snacks_dashboard", "pack", "snacks_picker_input" },
				winbar = { "dashboard", "alpha", "snacks_dashboard", "pack" },
			},
		},
		extensions = { "lazy", "mason", "oil", "quickfix", "pack" },
		sections = {
			lualine_a = {
				{ "mode" },
			},
			lualine_b = {
				{ "branch", icon = "󰘬" },
				{ "diff", symbols = { added = " ", modified = " ", removed = " " } },
				{
					function()
						local reg = vim.fn.reg_recording()
						if reg == "" then return "" end
						return " @" .. reg
					end,
					color = { fg = "#ff9e64" },
				},
				{ "searchcount" },
			},
			lualine_c = {
				{ "filename", file_status = true, path = 1 },
				{
					"diagnostics",
					sources = { "nvim_diagnostic" },
					symbols = { error = "✗ ", warn = "⚠ ", info = "ℹ ", hint = "💡 " },
				},
			},
			lualine_x = {
				{ "overseer" },
				{
					function()
						local clients = vim.lsp.get_clients({ bufnr = 0 })
						if #clients == 0 then
							return ""
						end
						local names = {}
						local seen = {}
						for _, client in ipairs(clients) do
							if not seen[client.name] then
								seen[client.name] = true
								table.insert(names, client.name)
							end
						end
						return "󰒋 " .. table.concat(names, ", ")
					end,
					color = { gui = "bold" },
				},
				"filetype",
			},
			lualine_y = { "progress" },
			lualine_z = {
				{ "location" },
			},
		},
	},
}
