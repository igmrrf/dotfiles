return {
	"nvim-treesitter/nvim-treesitter",
	version = "main",
	event = { "BufReadPre", "BufNewFile" },
	build = ":TSUpdateSync",
	cmd = { "TSUpdate", "TSUpdateSync", "TSInstall", "TSUninstall", "TSLog" },
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

		treesitter.install(parsers)

		local filetypes = { "typescriptreact", "help", "gitrebase", "gitconfig", "sh", "javascriptreact" }
		vim.list_extend(filetypes, parsers)

		vim.api.nvim_create_autocmd("FileType", {
			pattern = filetypes,
			callback = function(args)
				pcall(vim.treesitter.start, args.buf)
				vim.bo[args.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
				vim.opt_local.foldexpr = "v:lua.vim.treesitter.foldexpr()"
				vim.opt_local.foldmethod = "expr"
			end,
		})
	end,
}
