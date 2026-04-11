return {

	{
		"igmrrf/transparent.nvim",
		name = "transparent",
		opts = {
			enabled = true,
			listen = true,
		},
	},
	-- 1. Catppuccin (most popular)
	{
		"catppuccin/nvim",
		name = "catppuccin",
		-- enabled = false,
		priority = 1000,
		opts = {
			flavour = "mocha",
			-- transparent_background = true,
			integrations = {
				mini = {
					enabled = true,
				},
				snacks = true,
			},
			native_lsp = {
				enabled = true,
				virtual_text = {
					errors = { "italic" },
					hints = { "italic" },
					information = { "italic" },
					warnings = { "italic" },
				},
				underlines = {
					errors = { "undercurls" },
					hints = { "undercurls" },
					information = { "undercurls" },
					warnings = { "undercurls" },
				},
			},
		},
		config = function(_, opts)
			require("catppuccin").setup(opts)
			vim.cmd("colorscheme catppuccin-mocha")
		end,
	},

	-- 2. Tokyonight
	{
		"folke/tokyonight.nvim",
		enabled = false,
		lazy = false,
		priority = 1000,
		opts = { style = "storm", transparent = true, terminal_colors = true },
		config = function(_, opts)
			require("tokyonight").setup(opts)
			vim.cmd("colorscheme tokyonight-moon")
		end,
	},

	-- 3 Kanagawa
	{
		"rebelot/kanagawa.nvim",
		enabled = false,
		lazy = false,
		priority = 1000,
		opts = {
			compile = false, -- enable compiling the colorscheme
			undercurl = true, -- enable undercurls
			commentStyle = { italic = true },
			functionStyle = {},
			keywordStyle = { italic = true },
			statementStyle = { bold = true },
			typeStyle = {},
			transparent = true, -- do not set background color
			dimInactive = false, -- dim inactive window `:h hl-NormalNC`
			terminalColors = true, -- define vim.g.terminal_color_{0,17}
			colors = { -- add/modify theme and palette colors
				palette = {},
				theme = { wave = {}, lotus = {}, dragon = {}, all = {} },
			},
			overrides = function(colors) -- add/modify highlights
				return {
					LineNr = { bg = "NONE", ctermbg = "NONE" },
					NormalFloat = { bg = "NONE" },
					FloatBorder = { fg = colors.theme.ui.special, bg = "NONE" },
				}
			end,
			theme = "wave", -- Load "wave" theme
			background = { -- map the value of 'background' option to a theme
				dark = "wave", -- try "dragon" !
				light = "lotus",
			},
		},

		config = function(_, opts)
			require("kanagawa").setup(opts)
			vim.cmd("colorscheme kanagawa-wave")
		end,
	},

	-- 4. Nightfox
	{
		"EdenEast/nightfox.nvim",
		enabled = false,
		lazy = false,
		priority = 1000,
		opts = { options = { transparent = true, styles = { comments = "italic" } } },
		config = function(_, opts)
			require("nightfox").setup(opts)
			vim.cmd("colorscheme nightfox")
		end,
	},

	-- 5. Gruvbox Material
	{
		"sainnhe/gruvbox-material",
		opts = { overrides = { Normal = { bg = "NONE" }, NormalFloat = { bg = "NONE" } } },

		enabled = false,
		lazy = true,
		priority = 1000,
		config = function(_, opts)
			-- Gruvbox uses vim.g variables for themes
			vim.g.gruvbox_material_background = "medium"
			for group, hl in pairs(opts.overrides) do
				vim.api.nvim_set_hl(0, group, hl)
			end

			require("gruvbox").setup(opts)
			vim.cmd("colorscheme gruvbox-material")
		end,
	},
	-- 6. Koda
	{
		"oskarnurm/koda.nvim",

		enabled = false,
		lazy = false,
		priority = 1000,
		opts = {
			transparent = true,
		},
		config = function(_, opts)
			require("koda").setup(opts)
			vim.cmd("colorscheme koda")
		end,
	},
}
