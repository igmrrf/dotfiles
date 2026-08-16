return {
	"nvim-treesitter/nvim-treesitter",
	lazy = false,
	priority = 1000,
	version = "main",
	event = { "BufReadPre", "BufNewFile" },
	build = ":TSUpdate",
	cmd = { "TSUpdate", "TSUpdateSync", "TSInstall", "TSUninstall", "TSLog" },
	dependencies = {
		{ "nvim-treesitter/nvim-treesitter-textobjects", version = "main" },
	},
	config = function()
		local treesitter = require("nvim-treesitter")
		treesitter.setup()

		local textobjects = require("nvim-treesitter-textobjects")
		textobjects.setup({
			select = {
				lookahead = true,
			},
			move = {
				set_jumps = true,
			},
		})

		local select_textobject = require("nvim-treesitter-textobjects.select").select_textobject
		local textobject_keymaps = {
			["af"] = "@function.outer",
			["if"] = "@function.inner",

			["ac"] = "@class.outer",
			["ic"] = "@class.inner",

			-- ["at"] = "@type.outer",
			-- ["it"] = "@type.inner",
			--
			-- ["aa"] = "@parameter.outer",
			-- ["ia"] = "@parameter.inner",
			--
			-- ["ab"] = "@block.outer",
			-- ["ib"] = "@block.inner",
			--
			-- ["ai"] = "@conditional.outer",
			-- ["ii"] = "@conditional.inner",
			--
			["al"] = "@loop.outer",
			["il"] = "@loop.inner",
		}

		for key, query in pairs(textobject_keymaps) do
			vim.keymap.set({ "x", "o" }, key, function()
				select_textobject(query, "textobjects")
			end, { desc = "Select " .. query })
		end

		local move = require("nvim-treesitter-textobjects.move")
		local move_keymaps = {
			["]f"] = { fn = move.goto_next_start, query = "@function.outer", desc = "Next function start" },
			["]F"] = { fn = move.goto_next_end, query = "@function.outer", desc = "Next function end" },

			["[f"] = { fn = move.goto_previous_start, query = "@function.outer", desc = "Prev function start" },
			["[F"] = { fn = move.goto_previous_end, query = "@function.outer", desc = "Prev function end" },

			["]c"] = { fn = move.goto_next_start, query = "@class.outer", desc = "Next class/struct start" },
			["]C"] = { fn = move.goto_next_end, query = "@class.outer", desc = "Next class/struct end" },

			["[c"] = { fn = move.goto_previous_start, query = "@class.outer", desc = "Prev class/struct start" },
			["[C"] = { fn = move.goto_previous_end, query = "@class.outer", desc = "Prev class/struct end" },

			-- ["]a"] = { fn = move.goto_next_start, query = "@parameter.inner", desc = "Next parameter" },
			-- ["[a"] = { fn = move.goto_previous_start, query = "@parameter.inner", desc = "Prev parameter" },
			--
			-- ["]l"] = { fn = move.goto_next_start, query = "@loop.outer", desc = "Next loop" },
			-- ["[l"] = { fn = move.goto_previous_start, query = "@loop.outer", desc = "Prev loop" },
			--
			-- ["]i"] = { fn = move.goto_next_start, query = "@conditional.outer", desc = "Next conditional" },
			-- ["[i"] = { fn = move.goto_previous_start, query = "@conditional.outer", desc = "Prev conditional" },
		}

		for key, item in pairs(move_keymaps) do
			vim.keymap.set({ "n", "x", "o" }, key, function()
				item.fn(item.query, "textobjects")
			end, { desc = item.desc })
		end

		local ts_repeat_move = require("nvim-treesitter-textobjects.repeatable_move")
		vim.keymap.set({ "n", "x", "o" }, ";", ts_repeat_move.repeat_last_move_next, { desc = "Repeat last move forward" })
		vim.keymap.set(
			{ "n", "x", "o" },
			",",
			ts_repeat_move.repeat_last_move_previous,
			{ desc = "Repeat last move backward" }
		)


		-- stylua: ignore
		local parsers = {
			"bash", "c", "cmake", "cpp", "css", "diff", "dockerfile",
			"git_config", "git_rebase", "gitattributes", "gitcommit", "gitignore",
			"go", "gomod", "gosum", "gowork", "html", "javascript", "json", "json5",
			"kotlin", "lua", "markdown", "markdown_inline", "ninja", "python", "query",
			"regex", "rust", "scss", "sql", "svelte", "toml", "tsx", "typescript",
			"typst", "vim", "vimdoc", "vue", "yaml", "zig", "terraform", "hcl",
			"helm",
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
