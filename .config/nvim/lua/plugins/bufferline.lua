return {
	"akinsho/bufferline.nvim",
	event = "VimEnter",
	dependencies = {
		"nvim-tree/nvim-web-devicons",
	},
	keys = {
		{ "<leader>bp", "<cmd>BufferLineTogglePin<cr>", desc = "Toggle Pin Buffer" },
		{ "<leader>bP", "<cmd>BufferLineGroupClose ungrouped<cr>", desc = "Close Non-Pinned Buffers" },
		-- { "<leader>bo", "<cmd>BufferLineCloseOthers<cr>", desc = "Close Other Buffers" }, For snacks
		{ "<leader>br", "<cmd>BufferLineCloseRight<cr>", desc = "Close Buffers to Right" },
		{ "<leader>bl", "<cmd>BufferLineCloseLeft<cr>", desc = "Close Buffers to Left" },
		{ "<S-h>", "<cmd>BufferLineCyclePrev<cr>", desc = "Prev Buffer" },
		{ "<S-l>", "<cmd>BufferLineCycleNext<cr>", desc = "Next Buffer" },
		{ "[b", "<cmd>BufferLineCyclePrev<cr>", desc = "Prev Buffer" },
		{ "]b", "<cmd>BufferLineCycleNext<cr>", desc = "Next Buffer" },
	},
	opts = {
		options = {
			mode = "buffers",
			separator_style = "slant",
			always_show_bufferline = true,
			show_buffer_close_icons = true,
			show_close_icon = false,

			indicator = {
				icon = "▎", -- this should be omitted if indicator style is not 'icon'
				style = "icon",
			},
			diagnostics = "nvim_lsp",
			diagnostics_indicator = function(count, level)
				local icon = level:match("error") and "✗ " or "⚠ "
				return " " .. icon .. count
			end,
		},
	},
}
