return {

	{
		"neovim/nvim-lspconfig",
		dependencies = {
			"williamboman/mason.nvim",
			"williamboman/mason-lspconfig.nvim",
			"saghen/blink.cmp",
		},
		event = { "BufReadPost", "BufNewFile" },
	},
	{
		"mason-org/mason-lspconfig.nvim",

		opts = {
			-- auto enable installed mason lsps
			-- vim.lsp.enable({ "rust_analyzer", "lua_ls", "gopls", "vtsls", "biome", "cssls", "tailwindcss" })
		},
		dependencies = {
			"mason-org/mason.nvim",
			"neovim/nvim-lspconfig",
		},
	},
	{
		"stevearc/conform.nvim",
		opts = {
			format_on_save = function(bufnr)
				if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
					return
				end
				return {
					timeout_ms = 500,
					lsp_format = "fallback",
				}
			end,

			formatters_by_ft = {
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
			},
		},
	},
	{
		"WhoIsSethDaniel/mason-tool-installer.nvim",
		opts = {
			ensure_installed = {
				{ "fish-lsp", auto_update = true },
				{
					"gopls",
					condition = function()
						return vim.fn.executable("go") == 1
					end,
				},

				"basedpyright",
				"ruff",
				"debugpy",

				"codelldb",
				"clang-format",
				"clangd",
				"bacon",

				"delve",

				"docker-compose-language-service",
				"dockerfile-language-server",

				"fish-lsp",

				"gofumpt",
				"golines",
				"gomodifytags",
				"gopls",
				"gotests",

				"hadolint",
				"impl",
				"biome",
				"js-debug-adapter",
				"json-to-struct",
				"lua-language-server",
				"misspell",
				"revive",
				"ruby-lsp",
				"shellcheck",
				"shfmt",
				"stylua",

				"css-lsp",
				"tailwindcss-language-server",

				"vtsls",
			},
		},
	},
	{
		"mason-org/mason.nvim",
		opts = {
			registries = {
				-- default I guess
				"github:mason-org/mason-registry",
				-- custom repository for roslyn
				"github:Crashdummyy/mason-registry",
			},
			ui = {
				icons = {
					package_installed = "✓",
					package_pending = "➜",
					package_uninstalled = "✗",
				},
			},
		},
	},
}
