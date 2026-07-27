return {
	"neovim/nvim-lspconfig",
	name = "nvim-lspconfig",
	event = { "BufReadPre", "BufNewFile" },
	dependencies = {
		"folke/neoconf.nvim",
		"mason-org/mason.nvim",
		"mason-org/mason-lspconfig.nvim",
	},
	config = function()
		require("neoconf").setup()
		require("mason-lspconfig").setup({
			handlers = {
				function(server_name)
					require("lspconfig")[server_name].setup({})
				end,
				-- rustaceanvim owns rust-analyzer. No-op here so mason-lspconfig
				-- never double-starts a second client.
				rust_analyzer = function() end,
			},
		})
	end,
}
