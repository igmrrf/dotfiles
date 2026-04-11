return {
	"kopecmaciej/vi-mongo.nvim",
	config = function()
		require("vi-mongo").setup({ persist = true })
	end,
	cmd = { "ViMongo" },
	keys = {
		{ "<leader>tm", "<cmd>ViMongo<cr>", desc = "ViMongo" },
	},
}
