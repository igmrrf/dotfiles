return {

	{
		"DrKJeff16/project.nvim",

        -- stylua: ignore
		keys = {
            { "<leader>P", ":Project<CR>", noremap = true, silent = false, desc = "Project", mode = { "n" }, },
            { "<leader>pa", ":ProjectAdd<CR>", noremap = true, silent = false, desc = "Project Add", mode = { "n" }, },
			{ "<leader>pp", function() require("project.extensions.snacks").pick() end, noremap = true, silent = false, desc = "Project picker", mode = { "n" }, },
			{ "<leader>pc", ":ProjectConfig<CR>", noremap = true, silent = false, desc = "Project Config", mode = { "n" }, },
			{ "<leader>pd", ":ProjectDelete<CR>", noremap = true, silent = false, desc = "Project Delete", mode = { "n" }, },
			{ "<leader>pe", ":ProjectExport<CR>", noremap = true, silent = false, desc = "Project Export", mode = { "n" }, },
			{ "<leader>ph", ":ProjectHealth<CR>", noremap = true, silent = false, desc = "Project Health", mode = { "n" }, },
			{ "<leader>pH", ":ProjectHistory<CR>", noremap = true, silent = false, desc = "Project History", mode = { "n" }, },
			{ "<leader>pi", ":ProjectImport<CR>", noremap = true, silent = false, desc = "Project Import", mode = { "n" }, },
			{ "<leader>pR", ":ProjectRoot<CR>", noremap = true, silent = false, desc = "Project Root", mode = { "n" }, },
			{ "<leader>pr", ":ProjectRecents<CR>", noremap = true, silent = false, desc = "Project Recents", mode = { "n" }, },
			{ "<leader>ps", ":ProjectSession<CR>", noremap = true, silent = false, desc = "Project Session", mode = { "n" }, },
		},
		dependencies = { -- OPTIONAL. Choose any of the following

			"folke/snacks.nvim",
		},
		opts = {},
	},
	{
		"numToStr/Comment.nvim",
		opts = {
			-- add any options here
		},
	},
	{

		"CRAG666/code_runner.nvim",
        -- stylua: ignore
		keys = {
			{"<leader>rr", ":RunCode<CR>", noremap = true, silent = false, desc="RunCode", mode = { "n" }, },
			{"<leader>rf", ":RunFile<CR>", noremap = true, silent = false, desc="RunFile", mode = { "n" }, },
			{"<leader>rft", ":RunFile tab<CR>", noremap = true, silent = false, desc="Run File tab", mode = { "n" }, },
			{"<leader>rp", ":RunProject<CR>", noremap = true, silent = false, desc="Run Project", mode = { "n" }, },
			{"<leader>rc", ":RunClose<CR>", noremap = true, silent = false, desc="RunClose",mode = { "n" }, },
			{"<leader>Rrf", ":CRFiletype<CR>", noremap = true, silent = false, desc="CRFiletype", mode = { "n" }, },
			{"<leader>Rrp", ":CRProjects<CR>", noremap = true, silent = false, desc="CRProjects", mode = { "n" }, },
		},
		config = true,
	},
	{
		"gbprod/substitute.nvim",
		event = { "BufReadPre", "BufNewFile" },
		config = function()
			local substitute = require("substitute")

			substitute.setup()

			-- set keymaps
			local keymap = vim.keymap -- for conciseness

			keymap.set("n", "s", substitute.operator, { desc = "Substitute with motion" })
			keymap.set("n", "ss", substitute.line, { desc = "Substitute line" })
			keymap.set("n", "S", substitute.eol, { desc = "Substitute to end of line" })
			keymap.set("x", "s", substitute.visual, { desc = "Substitute in visual mode" })
		end,
	},
	{
		"MeanderingProgrammer/render-markdown.nvim",
		-- enabled = false,
		dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-mini/mini.nvim" }, -- if you use the mini.nvim suite
		---@module 'render-markdown'
		---@type render.md.UserConfig
		opts = {
			-- ignore = function(buf)
			-- 	local name = vim.api.nvim_buf_get_name(buf)
			-- 	print(name)
			-- 	return string.find(name, "/tldo/") ~= nil
			-- end,
		},
	},
	{
		"smjonas/inc-rename.nvim",
		keys = {
			{
				"<leader>cr",
				function()
					return ":IncRename " .. vim.fn.expand("<cword>")
				end,
				mode = { "n", "v" },
				expr = true,
				desc = "Inc Rename",
			},
		},
		opts = {
			input_buffer_type = "snacks",
		},
	},

	{
		"windwp/nvim-ts-autotag",
		event = "VeryLazy",
		opts = {},
	},
	{
		"MagicDuck/grug-far.nvim",
		opts = { headerMaxWidth = 80 },
		cmd = "GrugFar",
		keys = {
			{
				"<leader>sr",
				function()
					local grug = require("grug-far")
					local ext = vim.bo.buftype == "" and vim.fn.expand("%:e")
					grug.open({
						transient = true,
						prefills = {
							filesFilter = ext and ext ~= "" and "*." .. ext or nil,
						},
					})
				end,
				mode = { "n", "v" },
				desc = "Search and Replace",
			},
		},
	},
	{
		"folke/todo-comments.nvim",
		event = "VeryLazy",
		dependencies = { "nvim-lua/plenary.nvim" },
		opts = {},
        -- stylua: ignore
        keys = {
            { "]t",         function() require("todo-comments").jump_next() end, desc = "Next Todo Comment",     },
            { "[t",         function() require("todo-comments").jump_prev() end, desc = "Previous Todo Comment", },
            { "<leader>xt", "<cmd>Trouble todo toggle<cr>",                      desc = "Todo (Trouble)" },      { "<leader>xT", "<cmd>Trouble todo toggle filter = {tag = {TODO, FIX, FIXME}}<cr>", desc = "Todo/Fix/Fixme (Trouble)", },
        },
	},
	{
		"folke/trouble.nvim",
		opts = {}, -- for default options, refer to the configuration section for custom setup.
		cmd = "Trouble",
    -- stylua: ignore
        keys = {
            { "<leader>xx", "<cmd>Trouble diagnostics toggle<cr>",                        desc = "Diagnostics (Trouble)",                        },
            { "<leader>xX", "<cmd>Trouble diagnostics toggle filter.buf=0<cr>",           desc = "Buffer Diagnostics (Trouble)",                 },
            { "<leader>cs", "<cmd>Trouble symbols toggle focus=false<cr>",                desc = "Symbols (Trouble)",                            },
            { "<leader>cl", "<cmd>Trouble lsp toggle focus=false win.position=right<cr>", desc = "LSP Definitions / references / ... (Trouble)", },
            { "<leader>xL", "<cmd>Trouble loclist toggle<cr>",                            desc = "Location List (Trouble)",                      },
            { "<leader>xQ", "<cmd>Trouble qflist toggle<cr>",                             desc = "Quickfix List (Trouble)",                      },
        },
	},
	{
		"folke/which-key.nvim",
		event = "VeryLazy",
		opts = {
			preset = "helix",
			sort = { "alphanum", "local", "order", "group", "mod" },
		},
		keys = {
			{
				"<leader>?",
				function()
					require("which-key").show({ global = false })
				end,
				desc = "Buffer Local Keymaps (which-key)",
			},
		},
	},

	{
		"folke/lazydev.nvim",
		ft = "lua",
		opts = {
			library = {
				-- Load luvit types when the `vim.uv` word is found
				{ path = "${3rd}/luv/library", words = { "vim%.uv" } },
			},
			-- Ensure lspconfig integration is enabled
			integrations = {
				lspconfig = true,
				-- Optional: if you use nvim-cmp or blink.cmp
				cmp = true,
			},
		},
	},
	{
		"saghen/blink.cmp",
		build = "cargo build --release",
		dependencies = {
			"rafamadriz/friendly-snippets",
		},
		-- CHANGE 1: Use '*' to track the latest fixes (essential for snippet engine bugs)
		version = "*",

		opts = {
			-- CHANGE 2: Ensure C-y is mapped to 'select_and_accept' explicitly
			keymap = {
				preset = "default",
				["<C-y>"] = { "select_and_accept" },
				-- Manually invoke minuet completion.
				["<A-y>"] = require("minuet").make_blink_map(),
			},

			appearance = {
				nerd_font_variant = "mono",
			},

			completion = {
				trigger = { prefetch_on_insert = false },
				accept = {
					auto_brackets = {
						enabled = false,
					},
				},
				menu = {
					border = "rounded",
					draw = {
						gap = 2,
					},
				},
				documentation = {
					auto_show = true,
					auto_show_delay_ms = 200,
					window = {
						border = "rounded",
					},
				},
			},

			-- Your existing sources config is fine
			sources = {
				default = { "lsp", "path", "snippets", "buffer", "lazydev", "codecompanion", "minuet" },
				providers = {
					codecompanion = {
						name = "CodeCompanion",
						module = "codecompanion.providers.completion.blink",
						enabled = true,
					},
					minuet = {
						name = "minuet",
						module = "minuet.blink",
						async = true,
						timeout_ms = 3000,
						score_offset = 50, --
					},
					lazydev = {
						name = "LazyDev",
						module = "lazydev.integrations.blink",
						score_offset = 100,
					},
				},
			},
			fuzzy = { implementation = "prefer_rust_with_warning" },
			signature = { enabled = true },
			-- Recommended to avoid unnecessary request
		},
		opts_extend = { "sources.default" },
	},
	{
		"norcalli/nvim-colorizer.lua",
		opts = {},
		config = function()
			vim.opt.termguicolors = true
			require("colorizer").setup({
				"css",
				"javascript",
			})
		end,
	},
}
