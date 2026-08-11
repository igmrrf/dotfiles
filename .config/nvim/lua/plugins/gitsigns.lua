return {
	"lewis6991/gitsigns.nvim",
	event = { "BufReadPost", "BufNewFile" },
	cmd = "Gitsigns",
	opts = {},
	keys = {
		{ "]h", "<cmd>Gitsigns next_hunk<CR>", desc = "Next Hunk" },
		{ "[h", "<cmd>Gitsigns prev_hunk<CR>", desc = "Prev Hunk" },
		{ "<leader>ghS", "<cmd>Gitsigns stage_hunk<CR>", desc = "Stage Hunk" },
		{ "<leader>ghR", "<cmd>Gitsigns reset_hunk<CR>", desc = "Reset Hunk" },
		{ "<leader>ghp", "<cmd>Gitsigns preview_hunk<CR>", desc = "Preview Hunk" },
		{ "<leader>ghi", "<cmd>Gitsigns preview_hunk_inline<CR>", desc = "Preview Hunk Inline" },
		{ "<leader>ghb", "<cmd>lua require('gitsigns').blame_line{full=true}<CR>", desc = "Blame Line" },
		{ "<leader>ghd", "<cmd>Gitsigns diffthis<CR>", desc = "Diff This" },
		{ "<leader>ghD", "<cmd>lua require('gitsigns').diffthis('~')<CR>", desc = "Diff This ~" },
	},
}
