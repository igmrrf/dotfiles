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
		-- Buffer-local LSP keymaps, gated on server capability (mirrors the
		-- Snacks.keymap `lsp = { method = ... }` gating used pre-migration).
		vim.api.nvim_create_autocmd("LspAttach", {
			group = vim.api.nvim_create_augroup("user_lsp_keymaps", { clear = true }),
			callback = function(ev)
				local client = vim.lsp.get_client_by_id(ev.data.client_id)
				if not client then
					return
				end
				if client:supports_method("textDocument/codeAction") then
					vim.keymap.set({ "n", "x" }, "<leader>ca", vim.lsp.buf.code_action, {
						buffer = ev.buf,
						silent = true,
						desc = "Code action",
					})
					vim.keymap.set("n", "<leader>co", function()
						vim.lsp.buf.code_action({
							apply = true,
							context = {
								only = { "source.organizeImports" },
								diagnostics = {},
							},
						})
					end, {
						buffer = ev.buf,
						silent = true,
						desc = "Organize imports",
					})
				end
			end,
		})

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
