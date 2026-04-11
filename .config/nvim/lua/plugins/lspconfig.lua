vim.pack.add({
	{ src = "https://github.com/WhoIsSethDaniel/mason-tool-installer.nvim" },
	{ src = "https://github.com/neovim/nvim-lspconfig" },
	{ src = "https://github.com/mason-org/mason.nvim" },
})

local utils = require("utils")
utils.lazy_load_event("lspconfig", { "BufReadPost", "BufNewFile" }, function()
	vim.cmd("packadd lspconfig")
	vim.cmd("packadd mason.nvim")
	vim.cmd("packadd mason-tool-installer.nvim")

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
		ensure_installed = {
			{ "fish-lsp", auto_update = true },
			{
				"gopls",
				condition = function()
					return vim.fn.executable("go") == 1
				end,
			},
			"basedpyright", "ruff", "debugpy", "codelldb", "clang-format", "clangd","bacon", 
			"delve", "docker-compose-language-service", "dockerfile-language-server", "fish-lsp", 
			"gofumpt", "golines", "gomodifytags", "gopls", "gotests", "hadolint", "impl", "biome", 
			"js-debug-adapter", "json-to-struct", "lua-language-server", "misspell", "revive", "ruby-lsp", 
			"shellcheck", "shfmt", "stylua", "css-lsp", "tailwindcss-language-server", "vtsls",
		},
	})

	vim.lsp.enable({ "pyright", "lua_ls", "vtsls", "ruff", "gopls", "rust_analyzer" })
end)
