vim.pack.add({
	{ src = "https://github.com/nvim-treesitter/nvim-treesitter", version = "main" },
	{ src = "https://github.com/nvim-treesitter/nvim-treesitter-textobjects", version = "main" },
})

local utils = require("utils")

utils.lazy_load_event("nvim-treesitter", { "VimEnter" }, function()
	vim.cmd.packadd("nvim-treesitter-textobjects")
	require("nvim-treesitter").setup()

    -- stylua: ignore
	local parsers = {
		"bash", "c", "cmake", "cpp", "css", "diff", "dockerfile",
		"git_config", "git_rebase", "gitattributes", "gitcommit", "gitignore",
		"go", "gomod", "gosum", "gowork", "html", "javascript", "json", "json5",
		"lua", "markdown", "markdown_inline", "ninja", "python", "query",
		"regex", "rust", "scss", "sql", "svelte", "tsx", "typescript",
		"typst", "vim", "vimdoc", "vue", "yaml", "zig",
	}
	local filetypes = { "typescriptreact", "help", "gitrebase", "gitconfig", "sh", "javascriptreact" }
	vim.list_extend(filetypes, parsers)
	require("nvim-treesitter").install(parsers)
	vim.api.nvim_create_autocmd("FileType", {
		pattern = filetypes,
		callback = function(args)
			-- Start the AST parser for syntax highlighting
			pcall(vim.treesitter.start, args.buf)

			-- Enable native AST indentation
			vim.bo[args.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"

			-- Enable native AST folding
			vim.wo[0][0].foldexpr = "v:lua.vim.treesitter.foldexpr()"
			vim.wo[0][0].foldmethod = "expr"

			vim.o.foldlevelstart = 99
			vim.o.foldlevel = 20
		end,
	})
end)
