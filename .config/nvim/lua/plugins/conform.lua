return {
	"stevearc/conform.nvim",
	event = { "BufWritePre" },
	cmd = { "ConformInfo" },
	keys = {
		{ "<leader>uf", "<cmd>ToggleBuffFormat<cr>", desc = "Toggle format-on-save (buffer)" },
		{ "<leader>uF", "<cmd>ToggleFormat<cr>", desc = "Toggle format-on-save (global)" },
		{
			"<leader>fm",
			function()
				require("conform").format({ async = true, lsp_fallback = true })
			end,
			desc = "Format Buffer",
		},
	},
	opts = {
		format_on_save = function(bufnr)
			-- Disable with a global or buffer-local variable
			if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
				return
			end
			return {
				timeout_ms = 500,
				lsp_format = "fallback",
			}
		end,

		formatters_by_ft = {
			astro = { "stylua" },
			lua = { "stylua" },
			javascript = { "biome", stop_after_first = true },
			sh = { "shfmt" },
			javascriptreact = { "biome" },
			json = { "biome" },
			jsonc = { "biome" },
			typescript = { "biome" },
			typescriptreact = { "biome" },
			go = { "goimports", "gofumpt" },
			["css"] = { "biome" },
			["less"] = { "biome" },
			["html"] = { "biome" },
			["yaml"] = { "biome" },
			["markdown"] = { "biome" },
			["markdown.mdx"] = { "biome" },
			["handlebars"] = { "biome" },
			-- Conform will run the first available formatter
			["python"] = { "ruff_fix", "ruff_organize_imports", "ruff_format" },
			sql = { "sql_formatter" },
		},
	},
}
