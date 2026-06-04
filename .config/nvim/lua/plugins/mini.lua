vim.pack.add({
	"https://github.com/rafamadriz/friendly-snippets",
	{ src = "https://github.com/nvim-mini/mini.nvim" },
})
vim.cmd.packadd("mini.nvim")

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

local utils = require("utils")
-- TODO: when a keymap is found
-- require("mini.operators").setup() -- gx, gm, gr, gs
require("mini.statusline").setup()
require("mini.sessions").setup()
require("mini.tabline").setup()
require("mini.align").setup()
require("mini.pairs").setup()
require("mini.pick").setup()

local keys = {
	{ "<leader>e", require("mini.files").open, desc = "Open mini files" },
}

utils.map_plugin_keys(keys)
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
local snips = require("mini.snippets")

-- 2. Configure mini.snippets
snips.setup({
	-- Load from the friendly-snippets library
	snippets = {
		snips.gen_loader.from_lang(),
	},
})
-- snips.start_lsp_server()
