vim.pack.add({

	"https://.github.com/nvim-lua/plenary.nvim",
	"https://.github.com/nvim-treesitter/nvim-treesitter",
	{ src = "https://github.com/olimorris/codecompanion.nvim", name = "codecompanion" },
})

local keys = {
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
	{ "<leader>al", "<cmd>CodeCompanion /lsp<cr>", mode = { "n", "v" }, desc = "CodeCompanion: Explain LSP Diagnostic" },
	{
		"<leader>am",
		"<cmd>CodeCompanion /commit<cr>",
		mode = { "n", "v" },
		desc = "CodeCompanion: Generate Commit Message",
	},
}
local utils = require("utils")
utils.map_plugin_keys(keys)

require("codecompanion").setup({
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
})
