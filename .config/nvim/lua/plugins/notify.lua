vim.pack.add({
	"https://github.com/rcarriga/nvim-notify",
})
local notify = require("notify")

notify.setup({
	merge_duplicates = true,
	background_colour = "#000000",
	-- Animation style: 'fade', 'slide', 'fade_in_slide_out', or 'static'
	stages = "fade_in_slide_out",
	-- How long notifications stay on screen (in milliseconds)
	timeout = 3000,
	-- Set this to your terminal background if you get weird visual artifacts
	-- background_colour = "#000000",
	-- Maximum width of the notification window
	max_width = math.floor(vim.api.nvim_win_get_width(0) / 2),
	-- Icons for different log levels (requires a Nerd Font)
	icons = {
		ERROR = "",
		WARN = "",
		INFO = "",
		DEBUG = "",
		TRACE = "✎",
	},
})

-- Override Neovim's default notify function globally
vim.notify = notify

-- Dismiss all active and pending notifications
vim.keymap.set("n", "<leader>nd", function()
	require("notify").dismiss({ pending = true, silent = true })
end, { desc = "Dismiss All Notifications" })
