vim.diagnostic.config({
	underline = true,
	update_in_insert = false,
	severity_sort = true,
	float = {
		border = "rounded",
		source = true,
	},
	virtual_text = {
		prefix = "●",
		source = "if_many",
	},
	signs = {
		text = {
			[vim.diagnostic.severity.ERROR] = "✗",
			[vim.diagnostic.severity.WARN] = "⚠",
			[vim.diagnostic.severity.INFO] = "ℹ",
			[vim.diagnostic.severity.HINT] = "💡",
		},
		numhl = {
			[vim.diagnostic.severity.ERROR] = "ErrorMsg",
			[vim.diagnostic.severity.WARN] = "WarningMsg",
		},
	},
})


-- Add float to diagnostic
local gotod = function(next, severity)
	local get = next and vim.diagnostic.get_next or vim.diagnostic.get_prev
	severity = severity and vim.diagnostic.severity[severity] or nil
	return function()
		local diag = get({ severity = severity })
		if diag then
			vim.diagnostic.jump({ diagnostic = diag })
			vim.defer_fn(function()
				vim.diagnostic.open_float(nil, { focus = false })
			end, 10)
		end
	end
end

local map = vim.keymap.set

map("n", "]e", gotod(true, vim.diagnostic.severity[1]), { desc = "Next Error" })
map("n", "[e", gotod(false, vim.diagnostic.severity[1]), { desc = "Prev Error" })
map("n", "]w", gotod(true, vim.diagnostic.severity[2]), { desc = "Next Warning" })
map("n", "[w", gotod(false, vim.diagnostic.severity[2]), { desc = "Prev Warning" })

map("n", "<leader>cd", function() vim.diagnostic.open_float() end, { desc = "Line diagnostic" })

-- Removed <leader>xq custom quickfill: collided with trouble.nvim's <leader>xq.
-- Native equivalent: right-click menu "Show All Diagnostics" (setqflist),
-- plus builtin [q / ]q navigation.

map("n", "<leader>xl", function()
	local lock_open = vim.fn.getloclist(0, { winid = 0 }).winid ~= 0
	if lock_open then
		vim.cmd("lclose")
	else
		vim.diagnostic.setloclist()
	end
end, { desc = "Location list - file" })
