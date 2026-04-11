vim.pack.add({
	{ src = "https://github.com/kopecmaciej/vi-mongo.nvim" },
})
-- cmd = { "ViMongo" },
local keys = {
	{ "<leader>tm", "<cmd>ViMongo<cr>", desc = "ViMongo" },
}
local utils = require("utils")

utils.map_plugin_keys(keys)

require("vi-mongo").setup({ persist = true })
