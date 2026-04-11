vim.pack.add({
	{ src = "https://github.com/nvim-lua/plenary.nvim" },

	{ src = "https://github.com/milanglacier/minuet-ai.nvim", name = "minuet" },
})

-- vim.cmd("packadd minuet")

require("minuet").setup({
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
})
