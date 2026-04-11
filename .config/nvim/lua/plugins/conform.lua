vim.pack.add({
	{ src = "https://github.com/stevearc/conform.nvim" },
})

local utils = require("utils")

-- Keymaps to toggle formatting (these trigger the commands defined in usercmds.lua)
local keys = {
	{ "<leader>uf", "<cmd>ToggleBuffFormat<cr>", desc = "Toggle format-on-save (buffer)" },
	{ "<leader>uF", "<cmd>ToggleFormat<cr>",     desc = "Toggle format-on-save (global)" },
	-- Manual format trigger
	{ "<leader>fm", function() require("conform").format({ async = true, lsp_fallback = true }) end, desc = "Format Buffer" },
}

utils.map_plugin_keys(keys)

-- Initialize conform immediately so its API is available for keymap usage
require("conform").setup({
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
})
