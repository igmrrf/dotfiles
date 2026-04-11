vim.pack.add({
	{ src = "https://github.com/gbprod/substitute.nvim" },
})

local substitute = require("substitute")
local utils = require("utils")

utils.lazy_load_event("substitute", { "BufReadPre", "BufNewFile" }, function()
	substitute.setup()

	local keymap = vim.keymap -- for conciseness

	keymap.set("n", "s", substitute.operator, { desc = "Substitute with motion" })
	keymap.set("n", "ss", substitute.line, { desc = "Substitute line" })
	keymap.set("n", "S", substitute.eol, { desc = "Substitute to end of line" })
	keymap.set("x", "s", substitute.visual, { desc = "Substitute in visual mode" })
end)
