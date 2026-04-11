local M = {}

-- =====================================================================
-- Excluded files/folders for searches
-- =====================================================================
M.exclude_finds = {
    -- Node.js & JavaScript/TypeScript
    "node_modules/*",
    -- Python
    "__pycache__/*", "%.pyc", ".venv/*", "venv/*",
    -- Rust
    "target/*",
    -- Go
    "bin/*", "pkg/*",
    -- C, C++, Rust, Zig, Go build artifacts
    "build/*", "dist/*", "*.o", "*.obj", "*.exe", "*.dll", "*.so", "*.dylib", "*.out",
    -- Lua
    ".luarc.json", ".luarc/*",
    -- C#
    "bin/*", "obj/*",
    -- Zig
    "zig-cache/*", "zig-out/*",
    -- Version control
    -- ".git/*",
    ".svn/*",
    -- Common IDE/Editor folders
    ".idea/*", ".vscode/*",
    -- System files
    ".DS_Store", "Thumbs.db",
}

-- =====================================================================
-- Lazy Load Helper for vim.pack
-- =====================================================================
M.lazy_load_ft = function(plugin_name, filetypes, setup_fn)
    vim.api.nvim_create_autocmd("FileType", {
        pattern = filetypes,
        callback = function()
            vim.cmd("packadd " .. plugin_name)
            if setup_fn then
                setup_fn()
            end
        end,
        once = true,
    })
end

-- =====================================================================
-- Lazy Load Helper for vim.pack
-- =====================================================================
M.lazy_load_event = function(plugin_name, events, setup_fn)
    vim.api.nvim_create_autocmd(events, {
        callback = function()
            vim.cmd("packadd " .. plugin_name)
            if setup_fn then
                setup_fn()
            end
        end,
        once = true,
    })
end

-- =====================================================================
-- Map plugin keys helper for vim.pack
-- =====================================================================
M.map_plugin_keys = function(keys)
    for _, k in ipairs(keys) do
        local mode = k.mode or "n"

        local opts = {}
        for key, value in pairs(k) do
            if type(key) == "string" and key ~= "mode" then
                opts[key] = value
            end
        end

        vim.keymap.set(mode, k[1], k[2], opts)
    end
end

-- =====================================================================
-- Build Hook Helper for vim.pack
-- =====================================================================
M.plugin_build = function(name, build_cmd, vim_cmd, msg)
	vim.api.nvim_create_autocmd("PackChanged", {
		callback = function(ev)
			if ev.data.spec.name == name then
				if msg then
					vim.notify(msg, vim.log.levels.INFO)
				end

				if build_cmd then
					vim.system(build_cmd, { cwd = ev.data.path }, function(out)
						if out.code ~= 0 then
							vim.schedule(function()
								vim.notify("Build failed for " .. name .. ":\n" .. out.stderr, vim.log.levels.ERROR)
							end)
						end
					end)
				end

				if vim_cmd then
					vim.schedule(function()
						vim.cmd(vim_cmd)
					end)
				end
			end
		end,
	})
end

return M
