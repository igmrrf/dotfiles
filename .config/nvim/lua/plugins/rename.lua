return {
	"smjonas/inc-rename.nvim",
	cmd = "IncRename",
	keys = {
		{
			"<leader>cr",
			function()
				return ":IncRename " .. vim.fn.expand("<cword>")
			end,
			expr = true,
			mode = { "n", "v" },
			desc = "Inc Rename",
		},
	},
	opts = {},
}
