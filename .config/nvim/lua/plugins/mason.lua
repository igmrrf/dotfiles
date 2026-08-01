return {
	"mason-org/mason.nvim",
	name = "mason",
	event = { "BufReadPre", "BufNewFile" },
	lazy = false,
	dependencies = {
		"WhoIsSethDaniel/mason-tool-installer.nvim",
		"mason-org/mason-lspconfig.nvim",
	},
	config = function()
		require("mason").setup({
			ui = {
				icons = {
					package_installed = "✓",
					package_pending = "➜",
					package_uninstalled = "✗",
				},
			},
		})
		-- stylua: ignore
		require("mason-tool-installer").setup({
			run_on_start = true,
			ensure_installed = {
				{ "fish-lsp", auto_update = true },
				{
					"gopls",
					condition = function()
						return vim.fn.executable("go") == 1
					end,
				},
				"astro", "basedpyright", "ruff", "debugpy", "codelldb", "clang-format", "clangd", "bacon", "marksman",
				"delve", "docker-compose-language-service", "dockerfile-language-server", "fish-lsp", "html",
				"gofumpt", "goimports", "golines", "gomodifytags", "gopls", "gotests", "hadolint", "impl", "biome",
				"js-debug-adapter", "json-to-struct", "lua-language-server", "misspell", "revive", "ruby-lsp",
				"shellcheck", "shfmt", "stylua", "css-lsp", "tailwindcss-language-server", "vtsls",
				"sqls", "sql-formatter",
			},
		})
	end,
}
