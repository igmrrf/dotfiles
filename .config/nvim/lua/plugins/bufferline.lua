return {
	"akinsho/bufferline.nvim",
	event = "BufReadPre",
	dependencies = {
		"nvim-tree/nvim-web-devicons",
	},
	keys = {
		{ "<leader>bp", "<cmd>BufferLineTogglePin<cr>", desc = "Toggle Pin Buffer" },
		{ "<leader>bP", "<cmd>BufferLineGroupClose ungrouped<cr>", desc = "Close Non-Pinned Buffers" },
		{ "<leader>br", "<cmd>BufferLineCloseRight<cr>", desc = "Close Buffers to Right" },
		{ "<leader>bl", "<cmd>BufferLineCloseLeft<cr>", desc = "Close Buffers to Left" },
		{ "<leader>bs", "<cmd>BufferLinePick<cr>", desc = "Pick Buffer" },
		{ "<leader>bc", "<cmd>BufferLinePickClose<cr>", desc = "Pick & Close Buffer" },
		{ "<S-h>", "<cmd>BufferLineCyclePrev<cr>", desc = "Prev Buffer" },
		{ "<S-l>", "<cmd>BufferLineCycleNext<cr>", desc = "Next Buffer" },
		{ "[b", "<cmd>BufferLineCyclePrev<cr>", desc = "Prev Buffer" },
		{ "]b", "<cmd>BufferLineCycleNext<cr>", desc = "Next Buffer" },
		{ "[B", "<cmd>BufferLineMovePrev<cr>", desc = "Move Buffer Left" },
		{ "]B", "<cmd>BufferLineMoveNext<cr>", desc = "Move Buffer Right" },
	},
	opts = {
		options = {
			mode = "buffers",
			separator_style = "thin",
			always_show_bufferline = true,
			show_buffer_close_icons = false,
			show_close_icon = false,
			close_command = function(bufnr)
				local ok, snacks = pcall(require, "snacks")
				if ok and snacks.bufdelete then
					snacks.bufdelete(bufnr)
				else
					vim.cmd("bdelete! " .. bufnr)
				end
			end,
			right_mouse_command = function(bufnr)
				local ok, snacks = pcall(require, "snacks")
				if ok and snacks.bufdelete then
					snacks.bufdelete(bufnr)
				else
					vim.cmd("bdelete! " .. bufnr)
				end
			end,
			hover = {
				enabled = true,
				delay = 150,
				reveal = { "close" },
			},
			indicator = {
				icon = "▎",
				style = "icon",
			},
			diagnostics = "nvim_lsp",
			diagnostics_indicator = function(count, level, diagnostics_dict, context)
				local syms = { error = "✗ ", warning = "⚠ ", hint = "💡 ", info = "ℹ " }
				local res = {}
				for k, v in pairs(diagnostics_dict) do
					local sym = syms[k] or ""
					table.insert(res, sym .. v)
				end
				return #res > 0 and (" " .. table.concat(res, " ")) or ""
			end,
			custom_filter = function(buf_number)
				local ft = vim.bo[buf_number].filetype
				if ft == "pack" or ft == "snacks_dashboard" or ft == "alpha" or ft == "dashboard" then
					return false
				end
				return true
			end,
			offsets = {
				{
					filetype = "neo-tree",
					text = "Neo-tree",
					highlight = "Directory",
					text_align = "left",
				},
				{
					filetype = "snacks_layout_box",
					text = "Explorer",
					highlight = "Directory",
					text_align = "left",
				},
				{
					filetype = "pack",
					text = "📦 Pack Manager",
					highlight = "Directory",
					text_align = "left",
				},
			},
		},
		highlights = function()
			if vim.g.colors_name and vim.g.colors_name:find("catppuccin") then
				local ok, catppuccin_hl = pcall(require, "catppuccin.groups.integrations.bufferline")
				if ok then
					return catppuccin_hl.get()
				end
			end
			return {}
		end,
	},
}
