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

-- Define the path to your 'opt' directory
local pack_path = vim.fn.stdpath("data") .. "/site/pack/core/opt/"

-- Helper to get installed plugin names for autocompletion
local function get_plugin_names()
	local plugins = vim.fn.expand(pack_path .. "*", false, true)
	local names = {}
	for _, path in ipairs(plugins) do
		table.insert(names, vim.fn.fnamemodify(path, ":t"))
	end
	return names
end

--- 1. UPDATE ALL PLUGINS
vim.api.nvim_create_user_command("UpdatePlugins", function()
	local plugins = vim.fn.expand(pack_path .. "*", false, true)
	if #plugins == 0 then
		vim.notify("No plugins found in " .. pack_path, vim.log.levels.WARN)
		return
	end

	for _, plugin_path in ipairs(plugins) do
		local name = vim.fn.fnamemodify(plugin_path, ":t")

		vim.system({ "git", "-C", plugin_path, "pull" }, {}, function(obj)
			vim.schedule(function()
				if obj.code == 0 then
					print("✓ Updated " .. name)
				else
					vim.notify("Failed to update " .. name .. ": " .. obj.stderr, vim.log.levels.ERROR)
				end
			end)
		end)
	end
	vim.cmd("TSUpdate")
end, { desc = "Git pull all plugins in the 'opt' directory" })

--- 2. INSTALL A NEW PLUGIN
-- Usage: :InstallPlugin https://github.com/user/repo
vim.api.nvim_create_user_command("InstallPlugin", function(opts)
	local url = opts.args
	local name = url:match(".*/([^.]+)%.?.*$") -- Extracts repo name from URL
	local dest = pack_path .. name

	if vim.fn.isdirectory(dest) == 1 then
		vim.notify("Plugin " .. name .. " is already installed.", vim.log.levels.WARN)
		return
	end

	print("Installing " .. name .. "...")
	vim.pack.add({ url })
	vim.cmd("packadd " .. name)
	print("✓ Installed " .. name .. ". Restart Neovim")
end, { nargs = 1, desc = "Clone a new plugin into the 'opt' directory" })

--- 3. UNINSTALL A PLUGIN
-- Usage: :UninstallPlugin <TAB>
vim.api.nvim_create_user_command("UninstallPlugin", function(opts)
	local plugin_name = opts.args
	local target = pack_path .. plugin_name

	if vim.fn.isdirectory(target) == 1 then
		local confirm = vim.fn.input("Permanently delete " .. plugin_name .. "? (y/n): ")
		if confirm:lower() == "y" then
			vim.fn.delete(target, "rf")
			vim.pack.del({ plugin_name })
			print("\n✓ Deleted " .. plugin_name)
		else
			print("\nAborted.")
		end
	else
		vim.notify("Plugin not found in 'opt': " .. plugin_name, vim.log.levels.ERROR)
	end
end, {
	nargs = 1,
	desc = "Remove a plugin from the 'opt' directory",
	complete = function()
		return get_plugin_names()
	end,
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
