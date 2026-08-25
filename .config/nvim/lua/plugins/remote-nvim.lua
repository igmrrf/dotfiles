return {
	-- Functionality: Provides a VS Code-like remote SSH development experience by running a headless Neovim on the remote server.
	-- Testing: Run `:RemoteStart` (or use `<leader>vrc`) to pick an SSH host and connect.
	"igmrrf/remote-nvim.nvim",
	version = "*",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"MunifTanjim/nui.nvim",
		"nvim-telescope/telescope.nvim",
	},
	config = true,
	keys = {
		{ "<leader>vrc", "<cmd>RemoteStart<cr>", desc = "Remote Start (Connect)" },
		{ "<leader>vrx", "<cmd>RemoteStop<cr>", desc = "Remote Stop" },
		{ "<leader>vri", "<cmd>RemoteInfo<cr>", desc = "Remote Info" },
	},
}
