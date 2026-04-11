return {
	"nvim-treesitter/nvim-treesitter",
	-- Load faster on file read
	event = { "BufReadPost", "BufNewFile" },
	dependencies = {
		"nvim-treesitter/nvim-treesitter-textobjects",
	},
	branch = "master",
	lazy = false,
	-- Ensure all installed parsers are up to date
	build = ":TSUpdate",
	-- You need config because nvim-treesitter requires require('nvim-treesitter.configs').setup()
	config = function()
		require("nvim-treesitter.configs").setup({
			-- List of languages to install; use "all" if needed
			ensure_installed = {
				"regex",
				"css",
				"html",
				"scss",
				"svelte",
				"tsx",
				"typst",
				"vue",
				"lua",
				"json",
				"yaml",
				"bash",
				"gitignore",
				"dockerfile",
				"javascript",
				"typescript",
				"go",
				"gomod",
				"gowork",
				"gosum",
				"cpp",
				"cmake",
				"git_config",
				"gitcommit",
				"git_rebase",
				"gitignore",
				"gitattributes",
				"json5",
				"c_sharp",
				"rust",
				"ron",
				"ninja",
				"sql",
				"zig",
			},
			ignore_install = {
				"rst",
				"ron",
				"latex",
				"norg",
			},
			sync_install = false,
			auto_install = true,

			-- Syntax highlighting
			highlight = {
				enable = true,
				additional_vim_regex_highlighting = false,
			},

			-- Indentation based on syntax trees
			indent = { enable = true },

			-- Tree-sitter based folding
			fold = { enable = true },

			-- Incremental selection via <CR>, <TAB>, <S-TAB>
			incremental_selection = {
				enable = true,
				keymaps = {
					init_selection = "gnn",
					node_incremental = "grn",
					scope_incremental = "grc",
					node_decremental = "grm",
				},
			},

			-- Optional: text-objects for functions, classes, parameters
			textobjects = {
				select = {
					enable = true,
					lookahead = true,
					keymaps = {
						["af"] = "@function.outer",
						["if"] = "@function.inner",
						["ac"] = "@class.outer",
						["ic"] = "@class.inner",
					},
					selection_modes = {
						["@parameter.outer"] = "v",
						["@function.outer"] = "V",
						["@class.outer"] = "<c-v>",
					},
					include_surrounding_whitespace = true,
				},
				move = {
					enable = true,
					set_jumps = true,
					goto_next_start = {
						["]f"] = "@function.outer",
						["]c"] = "@class.outer",
					},
					goto_previous_start = {
						["[f"] = "@function.outer",
						["[c"] = "@class.outer",
					},
				},
			},
		})
	end,
}
