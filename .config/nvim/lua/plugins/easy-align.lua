return {
	"junegunn/vim-easy-align",
	name = "vim-easy-align",
	event = { "BufReadPre", "BufNewFile" },
	keys = {
		{ "ga", "<Plug>(EasyAlign)", mode = { "n", "x" }, desc = "EasyAlign" },
	},
}
