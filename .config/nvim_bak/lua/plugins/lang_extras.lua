return {
	-- Rust
	{
		"saecki/crates.nvim",
		event = { "BufRead Cargo.toml" },
		opts = {
			completion = {
				cmp = { enabled = true },
			},
		},

        -- stylua: ignore
		keys = {
			{ "<leader>rc", function() require("crates").open_crates_io() end, desc = "Open Crates.io", },
			{ "<leader>rt", function() require("crates").toggle() end, desc = "Toggle Crate Info", },
			{ "<leader>rr", function() require("crates").reload() end, desc = "Reload Crate Info", },
			{ "<leader>rv", function() require("crates").show_versions_popup() end, desc = "Show Versions", },
			{ "<leader>rf", function() require("crates").show_features_popup() end, desc = "Show Features", },
			{ "<leader>rd", function() require("crates").open_documentation() end, desc = "Open Documentation", },
			{ "<leader>rD", function() require("crates").show_dependencies_popup() end, desc = "Show Dependencies", },
			{ "<leader>ru", function() require("crates").update_crate() end, desc = "Update Crate", },
			{ "<leader>ru", function() require("crates").update_crates() end, mode = "v", desc = "Update Crates", },
			{ "<leader>ra", function() require("crates").update_all_crates() end, desc = "Update All Crates", },
			{ "<leader>rU", function() require("crates").upgrade_crate() end, desc = "Upgrade Crate", },
			{ "<leader>rU", function() require("crates").upgrade_crates() end, mode = "v", desc = "Upgrade Crates", },
			{ "<leader>rA", function() require("crates").upgrade_all_crates() end, desc = "Upgrade All Crates", },
			{ "<leader>rx", function() require("crates").expand_plain_crate_to_inline_table() end, desc = "Expand Crate to Inline Table", },
			{ "<leader>rX", function() require("crates").extract_crate_into_table() end, desc = "Extract Crate into Table", },
			{ "<leader>rh", function() require("crates").open_homepage() end, desc = "Open Homepage", },
			{ "<leader>rR", function() require("crates").open_repository() end, desc = "Open Repository", },
			{ "<leader>rl", function() require("crates").open_lib_rs() end, desc = "Open Lib.rs", },
		},
	},
	{
		"mrcjkb/rustaceanvim",
		version = "^9", -- Recommended
		lazy = false, -- This plugin is already lazy
	},

	-- Python
	{
		"linux-cultist/venv-selector.nvim",
		branch = "main",
		dependencies = {
			"neovim/nvim-lspconfig",
			"mfussenegger/nvim-dap-python",
		},
		opts = {
			settings = {
				options = {
					notify_user_on_venv_activation = true,
				},
			},
		},
		ft = "python",
		keys = {
			{ "<leader>vs", "<cmd>VenvSelect<cr>", desc = "Select VirtualEnv" },
		},
	},

	-- C/C++
	{
		"p00f/clangd_extensions.nvim",
		lazy = true,
		config = function() end,
		opts = {
			inlay_hints = {
				inline = false,
			},
			ast = {
				--These require codicons (https://github.com/microsoft/vscode-codicons)
				role_icons = {
					type = "",
					declaration = "",
					expression = "",
					specifier = "",
					statement = "",
					["template argument"] = "",
				},
				kind_icons = {
					Compound = "",
					Recovery = "",
					TranslationUnit = "",
					PackExpansion = "",
					TemplateTypeParm = "",
					TemplateTemplateParm = "",
					TemplateParamObject = "",
				},
			},
		},
	},

	-- TypeScript/JavaScript
	{
		"vuki656/package-info.nvim",
		enabled = false,
		dependencies = { "MunifTanjim/nui.nvim" },
		event = "BufRead package.json",
		opts = {},
		keys = {
			{ "<leader>ps", "<cmd>PackageInfoShow<cr>", desc = "Show Package Info" },
			{ "<leader>ph", "<cmd>PackageInfoHide<cr>", desc = "Hide Package Info" },
			{ "<leader>pc", "<cmd>PackageInfoChangeVersion<cr>", desc = "Change Package Version" },
			{ "<leader>pt", "<cmd>PackageInfoToggle<cr>", desc = "Change Package Version" },
			{ "<leader>pd", "<cmd>PackageInfoDelete<cr>", desc = "Delete Package" },
			{ "<leader>pu", "<cmd>PackageInfoUpdate<cr>", desc = "Update Package" },
			{ "<leader>pi", "<cmd>PackageInfoInstall<cr>", desc = "Install Package" },
		},
	},
}
