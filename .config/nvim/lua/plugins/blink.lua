return {
	"Saghen/blink.cmp",
	name = "blink.cmp",
	dependencies = {
		"rafamadriz/friendly-snippets",
		"milanglacier/minuet-ai.nvim",
	},
	version = "*",
	event = { "InsertEnter", "CmdlineEnter" },
	opts = {
		keymap = {
			preset = "default",
			["<C-space>"] = { "show", "show_documentation", "hide_documentation" },
			["<C-e>"] = { "hide", "fallback" },
			["<CR>"] = { "accept", "fallback" },

			["<Tab>"] = { "snippet_forward", "select_next", "fallback" },
			["<S-Tab>"] = { "snippet_backward", "select_prev", "fallback" },

			["<Up>"] = { "select_prev", "fallback" },
			["<Down>"] = { "select_next", "fallback" },
			["<C-p>"] = { "select_prev", "fallback" },
			["<C-n>"] = { "select_next", "fallback" },

			["<C-b>"] = { "scroll_documentation_up", "fallback" },
			["<C-f>"] = { "scroll_documentation_down", "fallback" },
			["<C-k>"] = { "show_signature", "hide_signature", "fallback" },
		},

		appearance = {
			use_nvim_cmp_as_default = true,
			nerd_font_variant = "mono",
		},

		completion = {
			trigger = { prefetch_on_insert = false },
			accept = {
				auto_brackets = {
					enabled = true,
				},
			},

			menu = {
				border = "rounded",
				draw = {
					columns = {
						{ "kind_icon" },
						{ "label", "label_description", gap = 1 },
						{ "kind" },
					},
				},
			},

			documentation = {
				auto_show = true,
				auto_show_delay_ms = 150,
				window = {
					border = "rounded",
				},
			},

			ghost_text = {
				enabled = true,
			},
		},

		signature = {
			enabled = true,
			window = {
				border = "rounded",
			},
		},

		snippets = {
			preset = "default",
		},

		sources = {
			default = { "lazydev", "lsp", "path", "snippets", "buffer", "minuet" },
			providers = {
				lazydev = {
					name = "LazyDev",
					module = "lazydev.integrations.blink",
					score_offset = 100,
				},
				minuet = {
					name = "minuet",
					async = true,
					module = "minuet.blink",
					timeout_ms = 3000,
					score_offset = 50, -- Gives minuet higher priority among suggestions
				},
			},
		},

		fuzzy = { implementation = "prefer_rust_with_warning" },
	},
	opts_extend = { "sources.default" },
}
