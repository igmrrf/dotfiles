return {
	"milanglacier/minuet-ai.nvim",
	name = "minuet",
	event = { "BufReadPost", "BufNewFile" },
	dependencies = { "nvim-lua/plenary.nvim" },
	opts = {
		blink = {
			enable_auto_complete = true,
		},
		virtualtext = {
			auto_trigger_ft = { "*" },
			keymap = {

				accept = "<Tab>",
				accept_line = "<C-a>",
				prev = "<C-p>",
				next = "<C-n>",
				dismiss = "<Escape>",
			},
		},

		provider = "openai_fim_compatible",
		request_timeout = 15,
		throttle = 1500,
		debounce = 600,
		notify = "warn",
		n_completions = 1,
		context_window = 512,
		provider_options = {
			openai_fim_compatible = {
				api_key = vim.env.MINUET_API_KEY or "TERM",
				name = "Qwen",
				end_point = vim.env.MINUET_END_POINT or "http://localhost:11434/v1/completions",
				model = vim.env.MINUET_MODEL or "qwen2.5-coder:3b",
				optional = {
					max_tokens = 256,
					top_p = 0.9,
				},
			},
		},
	},
}
