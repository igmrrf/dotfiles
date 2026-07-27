return {
	"nvim-treesitter/nvim-treesitter",
	version = "main",
	event = { "BufReadPost", "BufNewFile" },
	dependencies = {
		{ "nvim-treesitter/nvim-treesitter-textobjects", version = "main" },
	},
	config = function()
		local treesitter = require("nvim-treesitter")
		treesitter.setup()

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
		treesitter.install(parsers)
		vim.api.nvim_create_autocmd("FileType", {
			pattern = filetypes,
			callback = function(args)
				pcall(vim.treesitter.start, args.buf)
				vim.bo[args.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
				vim.wo[0][0].foldexpr = "v:lua.vim.treesitter.foldexpr()"
				vim.wo[0][0].foldmethod = "expr"
				vim.o.foldlevelstart = 99
				vim.o.foldlevel = 20
			end,
		})
	end,
}
