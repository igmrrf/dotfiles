return {
	"milanglacier/minuet-ai.nvim",
	name = "minuet",
	event = { "BufReadPost", "BufNewFile" },
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
		context_window = 512,
		provider_options = {
			openai_fim_compatible = {
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
}
