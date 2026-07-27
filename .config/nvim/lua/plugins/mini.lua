return {
	"nvim-mini/mini.nvim",
	name = "mini.nvim",
	dependencies = {
		"rafamadriz/friendly-snippets",
	},
	config = function()
		local ai = require("mini.ai")
		ai.setup({
			custom_textobjects = {
				-- If you want to keep the default 'f' for calls, use 'F' for definitions:
				f = ai.gen_spec.treesitter({
					a = { "@function.outer", "@call.outer" },
					i = { "@function.inner", "@call.inner" },
				}),
				-- 't' for Types (Structs, Traits, Interfaces)
				t = ai.gen_spec.treesitter({ a = "@class.outer", i = "@class.inner" }),
				-- 'r' for Return statements
				r = ai.gen_spec.treesitter({ a = "@return.outer", i = "@return.inner" }),
			},
		})

		require("mini.align").setup()
		require("mini.pairs").setup()

		require("mini.surround").setup({
			custom_surroundings = nil,
			highlight_duration = 500,
			mappings = {
				add = "gsa", -- Add surrounding in Normal and Visual modes
				delete = "gsd", -- Delete surrounding
				find = "gsf", -- Find surrounding (to the right)
				find_left = "gsF", -- Find surrounding (to the left)
				highlight = "gsh", -- Highlight surrounding
				replace = "gsr", -- Replace surrounding
				update_n_lines = "gsn", -- Update `n_lines`
				suffix_last = "l", -- Suffix to search with "prev" method
				suffix_next = "n", -- Suffix to search with "next" method
			},
			n_lines = 20,
			respect_selection_type = false,
			search_method = "cover",
			silent = false,
		})

		vim.schedule(function()
			local snips = require("mini.snippets")
			snips.setup({
				snippets = {
					snips.gen_loader.from_lang(),
				},
			})
		end)
	end,
}
