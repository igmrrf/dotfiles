return {
	"kylechui/nvim-surround",
	name = "nvim-surround",
	version = "*",
	event = { "BufReadPre", "BufNewFile" },
	init = function()
		vim.g.nvim_surround_no_normal_mappings = true
		vim.g.nvim_surround_no_insert_mappings = true
		vim.g.nvim_surround_no_visual_mappings = true
	end,
	config = function(_, opts)
		require("nvim-surround").setup(opts)
		vim.keymap.set("n", "gza", "<Plug>(nvim-surround-normal)", { desc = "Add surround" })
		vim.keymap.set("n", "gzz", "<Plug>(nvim-surround-normal-cur)", { desc = "Add surround (cur)" })
		vim.keymap.set("n", "gzA", "<Plug>(nvim-surround-normal-line)", { desc = "Add surround line" })
		vim.keymap.set("n", "gzZ", "<Plug>(nvim-surround-normal-cur-line)", { desc = "Add surround line (cur)" })
		vim.keymap.set("x", "gza", "<Plug>(nvim-surround-visual)", { desc = "Add surround visual" })
		vim.keymap.set("x", "gzA", "<Plug>(nvim-surround-visual-line)", { desc = "Add surround visual line" })
		vim.keymap.set("n", "gzd", "<Plug>(nvim-surround-delete)", { desc = "Delete surround" })
		vim.keymap.set("n", "gzr", "<Plug>(nvim-surround-change)", { desc = "Change surround" })
		vim.keymap.set("i", "<C-g>z", "<Plug>(nvim-surround-insert)", { desc = "Add surround insert" })
		vim.keymap.set("i", "<C-g>Z", "<Plug>(nvim-surround-insert-line)", { desc = "Add surround insert line" })
	end,
}
