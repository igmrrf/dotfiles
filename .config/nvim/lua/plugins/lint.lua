vim.pack.add({
	{ src = "https://github.com/mfussenegger/nvim-lint" },
})

local utils = require("utils")

utils.lazy_load_event("nvim-lint", { "BufReadPost", "BufNewFile" }, function()
	vim.cmd("packadd nvim-lint")
	local lint = require("lint")

	lint.linters_by_ft = {
		lua = { "selene" },
		javascript = { "biome" },
		typescript = { "biome" },
		javascriptreact = { "biome" },
		typescriptreact = { "biome" },
		python = { "ruff" },
		go = { "golangcilint" },
		sh = { "shellcheck" },
	}

	vim.api.nvim_create_autocmd({ "BufWritePost", "BufEnter" }, {
		group = vim.api.nvim_create_augroup("nvim_lint", { clear = true }),
		callback = function()
			lint.try_lint()
		end,
	})
end)
