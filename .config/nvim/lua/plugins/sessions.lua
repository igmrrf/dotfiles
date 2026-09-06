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
		{
			"<leader>qd",
			function()
				vim.g.persistence_stopped = true
				require("persistence").stop()
			end,
			desc = "Don't save current session on exit",
		},
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

		vim.api.nvim_create_autocmd("SessionLoadPost", {
			group = vim.api.nvim_create_augroup("PersistenceLspReattach", { clear = true }),
			callback = function()
				for _, buf in ipairs(vim.api.nvim_list_bufs()) do
					if vim.api.nvim_buf_is_loaded(buf) and vim.bo[buf].buftype == "" then
						if vim.bo[buf].filetype == "" then
							local ft = vim.filetype.match({ buf = buf, filename = vim.api.nvim_buf_get_name(buf) })
							if ft and ft ~= "" then
								vim.bo[buf].filetype = ft -- setting this fires FileType itself
							end
						else
							vim.api.nvim_exec_autocmds("FileType", { buffer = buf })
						end
					end
				end
			end,
		})
	end,
}
