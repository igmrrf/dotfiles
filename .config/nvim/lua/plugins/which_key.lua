vim.pack.add({
	{src="https://github.com/folke/which-key.nvim"},
})

local which_key = require("which-key")

which_key.setup({
	preset = "helix",
	sort = {"alphanum", "local", "order", "group", "mod"}
})
vim.keymap.set("n", "<leader>?", function() which_key.show({global = true}) end, {desc="Buffer Local keymaps (which-key})"})
