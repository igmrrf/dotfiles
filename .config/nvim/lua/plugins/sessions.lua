return {
	"folke/persistence.nvim",
	lazy = false,
	opts = {
		dir = vim.fn.stdpath("state") .. "/sessions/",
		options = { "buffers", "curdir", "tabpages", "winsize", "help", "globals", "skiprtp" },
		need = 1,
		branch = false,
	},
    -- stylua: ignore
	keys = {
		{ "<leader>qs", function() require("persistence").load() end, desc = "Restore session (current dir)" },
		{ "<leader>qS", function() require("persistence").select() end, desc = "Select / search session" },
		{ "<leader>ql", function() require("persistence").load({ last = true }) end, desc = "Restore last session" },
		{ "<leader>qd", function() require("persistence").stop() end, desc = "Don't save current session on exit" },
	},

	config = function(_, opts)
		require("persistence").setup(opts)
		-- Auto-restore session when opening nvim with no file arguments
		vim.api.nvim_create_autocmd("VimEnter", {
			group = vim.api.nvim_create_augroup("PersistenceAutoRestore", { clear = true }),
			nested = true, -- CRITICAL: Allows BufReadPost / FileType / LSP events to trigger
			callback = function()
				if vim.fn.argc() == 0 and not vim.g.started_with_stdin then
					require("persistence").load()
				end
			end,
		})

		-- Ensure LSP and buffer events attach cleanly to restored buffers
		vim.api.nvim_create_autocmd("SessionLoadPost", {
			group = vim.api.nvim_create_augroup("PersistenceLspReattach", { clear = true }),
			callback = function()
				for _, buf in ipairs(vim.api.nvim_list_bufs()) do
					if vim.api.nvim_buf_is_loaded(buf) and vim.bo[buf].buftype == "" then
						vim.api.nvim_exec_autocmds("FileType", { buffer = buf })
					end
				end
			end,
		})
	end,
}
