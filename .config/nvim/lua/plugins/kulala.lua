return {
	"mistweaverco/kulala.nvim",
	ft = "http",
	keys = {
		{ "<leader>rc", "<cmd>lua require('kulala').run()<cr>", desc = "Send HTTP Request" },
		{ "<leader>ra", "<cmd>lua require('kulala').run_all()<cr>", desc = "Send All HTTP Requests" },
		{ "<leader>ri", "<cmd>lua require('kulala').inspect()<cr>", desc = "Inspect HTTP Request" },
		{ "<leader>rt", "<cmd>lua require('kulala').toggle_view()<cr>", desc = "Toggle Headers/Body" },
		{ "<leader>rp", "<cmd>lua require('kulala').copy()<cr>", desc = "Copy as cURL" },
		{ "<leader>rn", "<cmd>e rest.http<cr>", desc = "Create rest.http in root" },
	},
	opts = {
		-- Default options
	},
}
