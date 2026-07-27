return {
	"folke/lazydev.nvim",
	name = "lazydev",
	ft = "lua",
	opts = {
		library = {
			{ path = "${3rd}/luv/library", words = { "vim%.uv" } },
			{ path = "snacks.nvim", words = { "Snacks" } },
			{ path = "lazy.nvim", words = { "LazyVim" } },
			{ path = "nvim-lspconfig", words = { "lspconfig.settings" } },
		},
		integrations = {
			lspconfig = true,
			cmp = true,
		},
	},
}
