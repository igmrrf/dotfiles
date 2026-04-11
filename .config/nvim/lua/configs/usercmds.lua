-- Get Active LSP
vim.api.nvim_create_user_command("LspInfo", function()
	local clients = vim.lsp.get_clients({ bufnr = 0 })
	if #clients == 0 then
		print("No LSP clients attached to current buffer")
	else
		for _, client in ipairs(clients) do
			print("LSP: " .. client.name .. " (ID: " .. client.id .. ")")
		end
	end
end, { desc = "Show LSP client info" })

-- Enable/Disable Buffer Format
vim.api.nvim_create_user_command("ToggleBuffFormat", function()
	local buf = vim.api.nvim_get_current_buf()
	local enabled = vim.b[buf].disable_autoformat or nil
	if enabled then
		vim.b[buf].disable_autoformat = false
		vim.notify("Formatting Enabled for Buffer!", vim.log.levels.INFO, {
			title = "Toggle Format",
		})
	else
		vim.b[buf].disable_autoformat = true
		vim.notify("Formatting disabled for Buffer!", vim.log.levels.INFO, {
			title = "Toggle Format",
		})
	end
end, {
	desc = "Toggle autoformat-on-save",
})

-- Enable/Disable Global Format
vim.api.nvim_create_user_command("ToggleFormat", function()
	local enabled = vim.g.disable_autoformat or nil
	if enabled then
		vim.g.disable_autoformat = false

		vim.notify("Enabled Formatting Globally!", vim.log.levels.INFO, {
			title = "Toggle Format",
		})
	else
		vim.g.disable_autoformat = true
		vim.notify("Disabled Formatting Globally!", vim.log.levels.INFO, {
			title = "Toggle Format",
		})
	end
end, {
	desc = "Toggle autoformat-on-save",
})

vim.api.nvim_create_user_command("QfRemoveCurrent", function()
	local lnum = vim.fn.line(".")

	local qf = vim.fn.getqflist()
	if lnum > 0 and lnum <= #qf then
		table.remove(qf, lnum)
		vim.fn.setqflist(qf)
		print("Removed quickfix item #" .. lnum)
	else
		print("Invalid quickfix item")
	end
end, {})
