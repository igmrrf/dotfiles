-- neovim-tips ships its own nui.nvim three-pane picker (no telescope/snacks).
-- render-markdown.nvim (already installed standalone) is auto-detected at runtime
-- as the tip renderer, so it is not listed as a dependency here.
-- Prefix is <leader>i ("Tips"), NOT the README's <leader>nt: <leader>n is already a
-- direct map (snacks notifications) and an nt* prefix would stall it on timeoutlen.
return {
	"saxon1964/neovim-tips",
	version = "*",
	dependencies = {
		"MunifTanjim/nui.nvim",
	},
	opts = {
		daily_tip = 1,
		bookmark_symbol = "🌟 ",
	},
	cmd = {
		"NeovimTips",
		"NeovimTipsBookmarks",
		"NeovimTipsRandom",
		"NeovimTipsEdit",
		"NeovimTipsAdd",
		"NeovimTipsPdf",
	},
	-- NOTE: `desc` is commented out until pack.nvim stops stashing `keys` in the
	-- native vim.pack `data` blob (see docs/pack-nvim-keys-data-bug.md). A `desc`
	-- key makes each entry a mixed array+map table, which native vim.pack cannot
	-- convert on FIRST install, aborting the clone. Restore `desc` after the fork
	-- is patched so which-key shows labels again.
	keys = {
		{ "<leader>io", "<cmd>NeovimTips<cr>" }, -- desc = "Neovim tips"
		{ "<leader>ib", "<cmd>NeovimTipsBookmarks<cr>" }, -- desc = "Bookmarked tips"
		{ "<leader>ir", "<cmd>NeovimTipsRandom<cr>" }, -- desc = "Random tip"
		{ "<leader>ie", "<cmd>NeovimTipsEdit<cr>" }, -- desc = "Edit your tips"
		{ "<leader>ia", "<cmd>NeovimTipsAdd<cr>" }, -- desc = "Add your tip"
		{ "<leader>ip", "<cmd>NeovimTipsPdf<cr>" }, -- desc = "Open tips PDF"
	},
}
