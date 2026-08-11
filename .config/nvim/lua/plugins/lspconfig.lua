return {
	"neovim/nvim-lspconfig",
	name = "nvim-lspconfig",
	event = { "BufReadPre", "BufNewFile" },
	dependencies = {
		"Saghen/blink.cmp",
		"folke/neoconf.nvim",
		"mason-org/mason.nvim",
		"mason-org/mason-lspconfig.nvim",
		"b0o/SchemaStore.nvim",
	},
	config = function()
		require("neoconf").setup()
		local capabilities = require("blink.cmp").get_lsp_capabilities()
		require("mason-lspconfig").setup({
			handlers = {
				function(server_name)
					require("lspconfig")[server_name].setup({
						capabilities = capabilities,
					})
				end,
				rust_analyzer = function() end,
				jsonls = function()
					require("lspconfig").jsonls.setup({
						capabilities = capabilities,
						settings = {
							json = {
								schemas = require("schemastore").json.schemas(),
								validate = { enable = true },
							},
						},
					})
				end,
				yamlls = function()
					require("lspconfig").yamlls.setup({
						capabilities = capabilities,
						settings = {
							yaml = {
								schemaStore = {
									enable = false,
									url = "",
								},
								schemas = require("schemastore").yaml.schemas(),
							},
						},
					})
				end,
			},
		})
	end,
}
