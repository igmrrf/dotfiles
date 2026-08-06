-- Colorscheme session persistence.
--
-- Independent of any single theme plugin: the active scheme is saved on every
-- switch and restored on startup. The snacks colorscheme picker (<leader>uC)
-- fires the `ColorScheme` event on confirm, so one autocmd captures every
-- change regardless of how it was triggered.
local M = {}

local state_file = vim.fn.stdpath("state") .. "/colorscheme"
local default_scheme = "catppuccin-mocha"

local function read_saved()
	local f = io.open(state_file, "r")
	if not f then
		return nil
	end
	local name = f:read("*l")
	f:close()
	if name and #name > 0 then
		return name
	end
	return nil
end

local function save(name)
	local f = io.open(state_file, "w")
	if f then
		f:write(name)
		f:close()
	end
end

function M.setup()
	vim.api.nvim_create_autocmd("ColorScheme", {
		group = vim.api.nvim_create_augroup("PersistColorscheme", { clear = true }),
		callback = function(ev)
			save(ev.match)
			-- Refresh UI components if already loaded when colorscheme changes/restores
			if package.loaded["lualine"] then
				pcall(require("lualine").setup, { options = { theme = "auto" } })
			end
		end,
	})

	-- Defer the apply until every colorscheme plugin has loaded so a saved
	-- non-default scheme resolves cleanly.
	vim.schedule(function()
		local saved = read_saved() or default_scheme
		if not pcall(vim.cmd.colorscheme, saved) then
			pcall(vim.cmd.colorscheme, default_scheme)
		end
	end)
end

return M
