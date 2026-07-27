-- leetcode.nvim routes through the snacks picker (this config's picker; no telescope).
-- `build = ":TSUpdate html"` installs the html parser used to render question bodies.
-- arg trick: `nvim leetcode.nvim` eager-loads the dashboard; otherwise it stays lazy
-- behind :Leet / the <leader>L keys.
local leet_arg = "leetcode.nvim"

return {
	"kawre/leetcode.nvim",
	lazy = leet_arg ~= vim.fn.argv(0, -1),
	cmd = "Leet",
	build = ":TSUpdate html",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"MunifTanjim/nui.nvim",
	},
	opts = {
		arg = leet_arg,
		picker = { provider = "snacks-picker" },
	},
	-- NOTE: `desc` is commented out until pack.nvim stops stashing `keys` in the
	-- native vim.pack `data` blob (see docs/pack-nvim-keys-data-bug.md). A `desc`
	-- key makes each entry a mixed array+map table, which native vim.pack cannot
	-- convert on FIRST install, aborting the clone. Restore `desc` after the fork
	-- is patched so which-key shows labels again.
	keys = {
		{ "<leader>Ll", "<cmd>Leet<cr>" }, -- desc = "LeetCode menu"
		{ "<leader>LL", "<cmd>Leet list<cr>" }, -- desc = "Problem list"
		{ "<leader>Lr", "<cmd>Leet run<cr>" }, -- desc = "Run solution"
		{ "<leader>Ls", "<cmd>Leet submit<cr>" }, -- desc = "Submit solution"
		{ "<leader>Ld", "<cmd>Leet desc<cr>" }, -- desc = "Toggle description"
		{ "<leader>Li", "<cmd>Leet info<cr>" }, -- desc = "Problem info"
		{ "<leader>Lc", "<cmd>Leet console<cr>" }, -- desc = "Open console"
	},
}
