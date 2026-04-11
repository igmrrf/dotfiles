return {
	{
		"nvim-flutter/flutter-tools.nvim",
		enabled = false,
		dependencies = { "nvim-lua/plenary.nvim", "stevearc/dressing.nvim" },
		config = function()
			vim.keymap.set("n", "<leader>flr", "<cmd>FlutterRestart<CR>", { desc = "Flutter Restart" })
			vim.keymap.set("n", "<leader>fls", "<cmd>FlutterRun<CR>", { desc = "Flutter Run" })
			require("flutter-tools").setup({
				-- (uncomment below line for windows only)
				-- flutter_path = "home/flutter/bin/flutter.bat",

				debugger = {
					-- make these two params true to enable debug mode
					enabled = true,
					run_via_dap = true,
					register_configurations = function(_)
						require("dap").adapters.dart = {
							type = "executable",
							command = vim.fn.stdpath("data") .. "/mason/bin/dart-debug-adapter",
							args = { "flutter" },
						}

						require("dap").configurations.dart = {
							{
								type = "dart",
								request = "launch",
								name = "Launch flutter",
								dartSdkPath = "home/flutter/bin/cache/dart-sdk/",
								flutterSdkPath = "home/flutter",
								program = "${workspaceFolder}/lib/main.dart",
								cwd = "${workspaceFolder}",
							},
						}
						-- uncomment below line if you've launch.json file already in your vscode setup
						-- require("dap.ext.vscode").load_launchjs()
					end,
				},
				dev_log = {
					-- toggle it when you run without DAP
					enabled = false,
					open_cmd = "tabedit",
				},
				lsp = {
					on_attach = require("vim.lsp").common_on_attach,
					capabilities = require("vim.lsp").default_capabilities,
				},
			})
		end,
	},
	-- for dart syntax hightling
	{
		enabled = false,
		"dart-lang/dart-vim-plugin",
	},
	{
		"seblyng/roslyn.nvim",
		enabled = false,
		ft = { "cs" },
		requires = { "nvim-lua/plenary.nvim" },
		--@module 'roslyn.config'
		--@type RoslynNvimConfig
		opts = {
			dotnet_cmd = "dotnet",
			settings = {
				["csharp|inlay_hints"] = {
					csharp_enable_inlay_hints_for_implicit_object_creation = true,
					csharp_enable_inlay_hints_for_implicit_variable_types = true,
					csharp_enable_inlay_hints_for_lambda_parameter_types = true,
					csharp_enable_inlay_hints_for_types = true,
					dotnet_enable_inlay_hints_for_indexer_parameters = true,
					dotnet_enable_inlay_hints_for_literal_parameters = true,
					dotnet_enable_inlay_hints_for_object_creation_parameters = true,
					dotnet_enable_inlay_hints_for_other_parameters = true,
					dotnet_enable_inlay_hints_for_parameters = true,
					dotnet_suppress_inlay_hints_for_parameters_that_differ_only_by_suffix = true,
					dotnet_suppress_inlay_hints_for_parameters_that_match_argument_name = true,
					dotnet_suppress_inlay_hints_for_parameters_that_match_method_intent = true,
				},
				["csharp|code_lens"] = {
					dotnet_enable_references_code_lens = true,
					dotnet_enable_tests_code_lens = true,
				},
				["csharp|completion"] = {
					dotnet_show_completion_items_from_unimported_namespaces = true,
					dotnet_show_name_completion_suggestions = true,
				},
				["csharp|background_analysis"] = {
					background_analysis_dotnet_compiler_diagnostics_scope = "fullSolution",
					background_analysis_dotnet_analyzers_diagnostics_scope = "fullSolution",
				},
				["csharp|symbol_search"] = {
					dotnet_search_reference_assemblies = true,
				},
			},
		},
	},
	{
		"Pheon-Dev/pigeon",
		enabled = false,
		opts = {
			enabled = true,
			os = "osx", -- windows, osx
			plugin_manager = "lazy", -- packer, paq, vim-plug
			callbacks = {
				killing_pigeon = nil,
				respawning_pigeon = nil,
			},
		},
	},
	{
		"mistricky/codesnap.nvim",
		enabled = false,
		build = "make build_generator",
		keys = {
			{ "<leader>xX", "<cmd>CodeSnap<cr>", mode = "x", desc = "Save selected code snapshot into clipboard" },
			{
				"<leader>xx",
				"<cmd>CodeSnapSave<cr>",
				mode = "x",
				desc = "Save selected code snapshot in ~/Desktop/codesnapx/",
			},
		},
		opts = {
			save_path = "~/Desktop/codesnapx/",
			has_breadcrumbs = true,
			bg_theme = "bamboo",
		},
	},
	{
		"olimorris/codecompanion.nvim",
		event = "VeryLazy",
		enabled = false,
		opts = {
			-- Example options, adjust as needed for your workflow
			model = "gemini-3-pro-preview",
			auto_suggestions = false,
			sidecar = {
				enabled = true,
				position = "right",
				width = 30,
			},
			system_prompt = [[
				You are an expert Full Stack Engineer with 15 years of experience.
				Prioritize concise, correct code over explanations.
			]],
			strategies = {
				chat = {
					adapter = "anthropic",
					model = "claude-sonnet-4-20250514",
				},
			},
			-- NOTE: The log_level is in `opts.opts`
			opts = {
				log_level = "DEBUG",
			},
		},
		dependencies = {
			"nvim-lua/plenary.nvim",
		},
	},
	{

		"yetone/avante.nvim",
		event = "VeryLazy",
		lazy = false,
		enabled = false,
		version = false, -- Set this to "*" to always pull the latest release version, or false to update to the latest code changes.
		opts = {
			-- 1. PROVIER SETUP
			-- "claude" is recommended for the best logic, but "openai" works too.
			-- 1. Set Provider
			provider = "gemini",

			-- 2. Configure Gemini 3 Specifics
			gemini = {
				model = "gemini-3-pro-preview",
				max_tokens = 65536,
				temperature = 0,
			},

			-- 2. BEHAVIOR & CONTEXT
			behaviour = {
				auto_suggestions = false, -- Experimental - set to true if you want ghost text while typing
				auto_set_highlight_group = true,
				auto_set_keymaps = true,
				auto_apply_diff_after_generation = false,
				support_paste_from_clipboard = true,
			},

			-- 3. WINDOW SETUP (The "Sidecar" view)
			windows = {
				position = "right", -- "right" | "left" | "top" | "bottom"
				width = 30, -- absolute width or percentage (0-100)
				sidebar_header = {
					align = "center",
					rounded = true,
				},
			},

			-- 4. DIFF HANDLING (How it applies code changes)
			diff = {
				autojump = true,
				list_opener = "copen",
			},
			system_prompt = [[
                You are an expert Full Stack Engineer. 
                Read the .cursorrules file in the root for strict architectural constraints.
                Prioritize concise, correct code over explanations.
            ]],
		},

		-- 5. BUILD STEP (CRITICAL FOR RAG)
		-- This builds the core binary that handles context tokenization
		build = "make",

		-- 6. DEPENDENCIES
		dependencies = {
			"stevearc/dressing.nvim",
			"nvim-lua/plenary.nvim",
			"MunifTanjim/nui.nvim",
			--- The below is optional, make sure to setup it properly if you have lazy=true
			{
				"MeanderingProgrammer/render-markdown.nvim",
				opts = {
					file_types = { "markdown", "Avante" },
				},
				ft = { "markdown", "Avante" },
			},
		},
	},
}
