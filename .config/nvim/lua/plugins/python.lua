vim.pack.add({

	"https://github.com/neovim/nvim-lspconfig",
	"https://github.com/mfussenegger/nvim-dap-python",
	{ src = "https://github.com/linux-cultist/venv-selector.nvim", version = "main" },
})
local utils = require("utils")
utils.lazy_load_ft("venv-selector", "python", function()
	require("venv-selector").setup({
		settings = {
			options = {
				notify_user_on_venv_activation = true,
			},
		},
	})

	vim.keymap.set("n", "<leader>vs", "<cmd>VenvSelect<cr>", { desc = "Select VirtualEnv" })
end)
-- TODO:
-- ft = "python",
