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

map("n", "]d", gotod(true), { desc = "Next Diagnostic" })
map("n", "[d", gotod(false), { desc = "Prev Diagnostic" })
map("n", "]e", gotod(true, vim.diagnostic.severity[1]), { desc = "Next Error" })
map("n", "[e", gotod(false, vim.diagnostic.severity[1]), { desc = "Prev Error" })
map("n", "]w", gotod(true, vim.diagnostic.severity[2]), { desc = "Next Warning" })
map("n", "[w", gotod(false, vim.diagnostic.severity[2]), { desc = "Prev Warning" })

map("n", "<leader>cd", function() vim.diagnostic.open_float() end, { desc = "Line diagnostic" })

map("n", "<leader>xq", function()
	local lock_open = vim.fn.getqflist({ winid = 0 }).winid ~= 0
	if lock_open then
		vim.cmd("cclose")
	else
		vim.diagnostic.setqflist()
	end
end, { desc = "Quickfix list - project" })

map("n", "<leader>xl", function()
	local lock_open = vim.fn.getloclist(0, { winid = 0 }).winid ~= 0
	if lock_open then
		vim.cmd("lclose")
	else
		vim.diagnostic.setloclist()
	end
end, { desc = "Location list - file" })
