return {

	{
		"milanglacier/minuet-ai.nvim",
		dependencies = { "nvim-lua/plenary.nvim" },
		opts = {

			virtual_text = {
				auto_trigger_ft = { "*" },
				keymap = {
					-- Press 'Tab' to accept the ghost text
					accept = "<Tab>",
					accept_line = "<C-a>",
					-- Cycle through suggestions if multiple are generated
					prev = "<C-p>",
					next = "<C-n>",
					dismiss = "<Escape>",
				},
			},

			provider = "openai_fim_compatible",
			request_timeout = 10,
			throttle = 1500,
			debounce = 600,
			n_completions = 1, -- recommend for local model for resource saving
			-- I recommend beginning with a small context window size and incrementally
			-- expanding it, depending on your local computing power. A context window
			-- of 512, serves as an good starting point to estimate your computing
			-- power. Once you have a reliable estimate of your local computing power,
			-- you should adjust the context window to a larger value.
			context_window = 512,
			provider_options = {
				openai_fim_compatible = {
					-- For Windows users, TERM may not be present in environment variables.
					-- Consider using APPDATA instead.
					api_key = "TERM",
					name = "Ollama",
					end_point = "http://localhost:11434/v1/completions",
					model = "qwen2.5-coder:3b",
					optional = {
						max_tokens = 56,
						top_p = 0.9,
					},
				},
			},
		},
	},
	{
		"olimorris/codecompanion.nvim",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-treesitter/nvim-treesitter",
		},
        -- stylua: ignore
		keys = {
			-- Toggle the Chat Buffer
			{ "<leader>ac", "<cmd>CodeCompanionChat Toggle<cr>", mode = { "n", "v" }, desc = "CodeCompanion: Toggle Chat" },
			-- Add selection to Chat
			{ "<leader>aa", "<cmd>CodeCompanionChat Add<cr>", mode = "v", desc = "CodeCompanion: Add Selection to Chat" },
			-- Open the Actions Palette
			{ "<leader>ap", "<cmd>CodeCompanionActions<cr>", mode = { "n", "v" }, desc = "CodeCompanion: Actions Palette" },
			-- Trigger Inline Code Companion
			{ "<leader>ai", "<cmd>CodeCompanion<cr>", mode = { "n", "v" }, desc = "CodeCompanion: Inline Prompt" },
			-- Specific Action Shortcuts (Mapping common /commands)
			{ "<leader>ae", "<cmd>CodeCompanion /explain<cr>", mode = "v", desc = "CodeCompanion: Explain Code" },
			{ "<leader>af", "<cmd>CodeCompanion /fix<cr>", mode = "v", desc = "CodeCompanion: Fix Code" },
			{ "<leader>at", "<cmd>CodeCompanion /tests<cr>", mode = "v", desc = "CodeCompanion: Generate Tests" },
			{ "<leader>al", "<cmd>CodeCompanion /lsp<cr>", mode = { "n", "v" }, desc = "CodeCompanion: Explain LSP Diagnostic", },
			{ "<leader>am", "<cmd>CodeCompanion /commit<cr>", mode = { "n", "v" }, desc = "CodeCompanion: Generate Commit Message", },
		},
		opts = {

			display = {
				action_palette = {
					width = 95,
					height = 10,
					prompt = "CodeCompanion Actions", -- Custom prompt title
					provider = "default", -- default|telescope|mini_pick|fzf_lua
					opts = {
						show_default_actions = true, -- Show standard actions
						show_default_prompt_library = true, -- Show prompts from the library
					},
				},
			},

			opts = {
				log_level = "DEBUG",
			},
			adapters = {
				http = {
					gemini = function()
						return require("codecompanion.adapters").extend("gemini", {
							schema = {
								model = {
									default = "gemini-3.1-pro-preview",
								},
							},
							env = {
								api_key = "GEMINI_API_KEY",
							},
						})
					end,
				},
			},
			strategies = {
				chat = {
					adapter = "gemini",
				},
				inline = {
					adapter = "gemini",
				},
				agent = {
					adapter = "gemini",
				},
			},
		},
	},
}
