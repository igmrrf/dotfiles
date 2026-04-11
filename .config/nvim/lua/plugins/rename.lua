vim.pack.add({
	{ src = "https://github.com/smjonas/inc-rename.nvim" },
})

vim.keymap.set({ "n", "v" }, "<leader>rn", function()
	return ":IncRename " .. vim.fn.expand("<cword>")
end, {
	desc = "Inc Rename",
})

require("inc_rename").setup()
