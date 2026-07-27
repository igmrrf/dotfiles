return {
	"neovim/nvim-lspconfig",
	name = "nvim-lspconfig",
	event = { "BufReadPre", "BufNewFile" },
	dependencies = {
		"WhoIsSethDaniel/mason-tool-installer.nvim",
		"mason-org/mason-lspconfig.nvim",
		"mason-org/mason.nvim",
		"folke/neoconf.nvim",
	},
	config = function()
		require("neoconf").setup()
		require("mason").setup({
			ui = {
				icons = {
					package_installed = "✓",
					package_pending = "➜",
					package_uninstalled = "✗",
				},
			},
		})
		require("mason-lspconfig").setup()
		-- stylua: ignore
		require("mason-tool-installer").setup({
			run_on_start = false,
			ensure_installed = {
				{ "fish-lsp", auto_update = true },
				{
					"gopls",
					condition = function()
						return vim.fn.executable("go") == 1
					end,
				},
				"astro", "basedpyright", "ruff", "debugpy", "codelldb", "clang-format", "clangd","bacon", "marksman",
				"delve", "docker-compose-language-service", "dockerfile-language-server", "fish-lsp", "html",
				"gofumpt", "goimports", "golines", "gomodifytags", "gopls", "gotests", "hadolint", "impl", "biome",
				"js-debug-adapter", "json-to-struct", "lua-language-server", "misspell", "revive", "ruby-lsp",
				"shellcheck", "shfmt", "stylua",  "css-lsp", "tailwindcss-language-server", "vtsls",
			},
		})
	end,
}
