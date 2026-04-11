vim.pack.add({
	"nvim-lua/plenary.nvim",
	{ src = "ThePrimeagen/harpoon", branch = "harpoon2" },
})

local harpoon = require("harpoon")
harpoon:setup({
	settings = {
		save_on_toggle = true,
		sync_on_ui_close = true,
	},
})

-- stylua: ignore
local map = vim.keymap.set
map("n", "<leader>h", function()
	harpoon:list():add()
end, { desc = "Harpoon Add File" })
map("n", "<leader>H", function()
	harpoon.ui:toggle_quick_menu(harpoon:list())
end, { desc = "Harpoon Menu" })
-- direct navigation (slots 1-4)
map("n", "<leader>1", function()
	harpoon:list():select(1)
end, { desc = "Harpoon File 1" })
map("n", "<leader>2", function()
	harpoon:list():select(2)
end, { desc = "Harpoon File 2" })
map("n", "<leader>3", function()
	harpoon:list():select(3)
end, { desc = "Harpoon File 3" })
map("n", "<leader>4", function()
	harpoon:list():select(4)
end, { desc = "Harpoon File 4" })
