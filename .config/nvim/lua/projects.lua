-- =====================================================================
-- Project switching -- one tabpage per project
-- =====================================================================
-- Storage is resession.nvim (see lua/plugins/sessions.lua). Opening a project
-- restores a *tab-scoped* session: its window layout, its buffers and its
-- `tcd`, into one tabpage, leaving every other project tab untouched. scope.nvim
-- keeps the buffer lists separate, so nothing from one project leaks into
-- another's `:ls`, bufferline or picker.
--
-- Two session namespaces:
--   project_<root>    one tabpage: the canonical state of a project
--   instance_<cwd>    the whole editor: every project tab that was open
--
-- Who may overwrite project_<root>:
--   * the instance whose *global* cwd is that project -- i.e. the nvim you
--     started inside the project folder ("primary"), or
--   * any instance, while the project has no session yet (first visit seeds it),
--   * otherwise nobody, except an explicit `:ProjectSave`.
-- So opening B in a tab from A never clobbers the state B has from its own
-- folder. Sessions are written only on exit (`M.save_all`) and by
-- `:ProjectSave` -- resession's own autosave is off, because there whole-editor
-- and tab sessions are mutually exclusive (`save()` clears every tab
-- attachment, `save_tab()` clears the global one) and we want both.
--
-- Clean mode (`M.switch`) is the one-project-at-a-time flow: reset the editor
-- and restore the project's session in place, moving the global cwd with it.
-- =====================================================================

local M = {}

M.config = {
	-- markers used to decide whether a directory is a project root
	patterns = {
		".git",
		"_darcs",
		".hg",
		".bzr",
		".svn",
		".luarc.json",
		"package.json",
		"Makefile",
		"Cargo.toml",
		"go.mod",
	},
	project_prefix = "project_",
	instance_prefix = "instance_",
}

--- Projects whose session this instance is allowed to write, by root.
local claimed = {}

local function notify(msg, level)
	vim.notify(msg, level or vim.log.levels.INFO, { title = "Projects" })
end

local function resession()
	local ok, mod = pcall(require, "resession")
	return ok and mod or nil
end

---@param dir string?
---@return string? normalized absolute path without trailing slash
local function normalize(dir)
	if type(dir) ~= "string" or dir == "" then
		return nil
	end
	dir = vim.fs.normalize(vim.fn.fnamemodify(dir, ":p"))
	if #dir > 1 then
		dir = dir:gsub("/+$", "")
	end
	return dir
end

-- =====================================================================
-- Names
-- =====================================================================

-- resession flattens "/" and ":" in session names anyway; doing it here keeps
-- the names we build identical to the ones `resession.list()` reports back.
-- "_" is doubled first so /x/my_app and /x/my/app cannot share a session.
local function slug(root)
	return (root:gsub("^/", ""):gsub("_", "__"):gsub("[\\/:]+", "_"))
end

--- The project this nvim instance belongs to: its global cwd.
---@return string?
function M.primary()
	return normalize(vim.fn.getcwd(-1, -1))
end

--- Is this nvim the instance that "owns" the project, i.e. the one started
--- inside its folder?
---@param root string?
---@return boolean
function M.is_primary(root)
	return root ~= nil and root == M.primary()
end

---@param root string
function M.project_name(root)
	return M.config.project_prefix .. slug(root)
end

---@param root string?
function M.instance_name(root)
	root = root or M.primary()
	return root and M.config.instance_prefix .. slug(root) or nil
end

local function session_exists(name)
	local r = resession()
	if not r or not name then
		return false
	end
	for _, saved in ipairs(r.list()) do
		if saved == name then
			return true
		end
	end
	return false
end

-- =====================================================================
-- Tabs
-- =====================================================================

---@param dir string
---@return boolean
function M.is_project(dir)
	dir = normalize(dir) or dir
	for _, pattern in ipairs(M.config.patterns) do
		if vim.uv.fs_stat(vim.fs.joinpath(dir, pattern)) then
			return true
		end
	end
	return false
end

local function tab_cwd(tab)
	if not vim.api.nvim_tabpage_is_valid(tab) then
		return nil
	end
	local ok, cwd = pcall(vim.fn.getcwd, -1, vim.api.nvim_tabpage_get_number(tab))
	return ok and normalize(cwd) or nil
end

--- The project a tabpage belongs to -- only tabs we tagged as project tabs.
--- Matching on cwd instead would be wrong: `:tabnew` inherits the tab-local
--- directory, so a tab opened by something else (lazygit's `--remote-tab`, a
--- plain `:tabnew`) sits in the project's cwd without being a project tab.
---@param tab integer? tabpage handle (0/nil = current)
---@return string?
function M.tab_root(tab)
	tab = (tab == nil or tab == 0) and vim.api.nvim_get_current_tabpage() or tab
	if not vim.api.nvim_tabpage_is_valid(tab) then
		return nil
	end
	local tagged = vim.t[tab].project_root
	return type(tagged) == "string" and tagged ~= "" and normalize(tagged) or nil
end

---@param root string
---@return integer? tabpage handle
function M.find_tab(root)
	root = normalize(root) or root
	for _, tab in ipairs(vim.api.nvim_list_tabpages()) do
		if M.tab_root(tab) == root then
			return tab
		end
	end
end

--- Tag tabs that sit in a project root but carry no tag yet. resession restores
--- each tab's cwd but not our `t:` variable, so this re-tags after a load.
--- Called only at startup and after a session load, never on TabNew -- see the
--- note in `M.tab_root` about inherited directories.
local function tag_tabs()
	local seen = {}
	for _, tab in ipairs(vim.api.nvim_list_tabpages()) do
		local root = M.tab_root(tab)
		if root then
			seen[root] = true
		end
	end
	for _, tab in ipairs(vim.api.nvim_list_tabpages()) do
		if not vim.t[tab].project_root then
			local cwd = tab_cwd(tab)
			-- first tab in a project wins; a second tab sitting in the same
			-- directory (a restored lazygit tab, say) stays inert so it can
			-- never be mistaken for the project's tab
			if cwd and not seen[cwd] and M.is_project(cwd) then
				vim.t[tab].project_root = cwd
				seen[cwd] = true
			end
		end
	end
end

--- Reuse the current tab when it holds nothing worth keeping, else open one.
local function open_clean_tab()
	local wins = vim.api.nvim_tabpage_list_wins(0)
	if #wins == 1 then
		local buf = vim.api.nvim_win_get_buf(wins[1])
		local ft = vim.bo[buf].filetype
		if ft == "snacks_dashboard" or ft == "pack" or ft == "alpha" then
			return
		end
		local empty = vim.api.nvim_buf_get_name(buf) == ""
			and not vim.bo[buf].modified
			and vim.api.nvim_buf_line_count(buf) <= 1
			and (vim.api.nvim_buf_get_lines(buf, 0, 1, false)[1] or "") == ""
		if empty then
			vim.bo[buf].bufhidden = "wipe"
			vim.bo[buf].buflisted = false
			return
		end
	end
	vim.cmd("tabnew")
	-- dispose of the scratch buffer `:tabnew` creates once a file takes over
	vim.bo.bufhidden = "wipe"
	vim.bo.buflisted = false
end

--- resession's own `open_clean_tab` reuses the current tab whenever it holds one
--- empty window -- and a project tab you visited but never opened a file in looks
--- exactly like that. Step onto a scratch tab first so its identity survives.
---@param root string the project about to be restored into a tab
---@param force boolean? open a tab even when we are already standing on root's
local function step_off_project_tab(root, force)
	local here = M.tab_root(0)
	if here and (force or here ~= root) then
		vim.cmd("tabnew")
		vim.bo.bufhidden = "wipe"
		vim.bo.buflisted = false
	end
end

--- Does the current tab show a real file? Used to fall back to the picker when
--- a project's session turns out to be empty (project visited, nothing opened).
local function tab_has_file()
	for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
		local buf = vim.api.nvim_win_get_buf(win)
		if vim.bo[buf].buftype == "" and vim.api.nvim_buf_get_name(buf) ~= "" then
			return true
		end
	end
	return false
end

local function pick_files(root)
	local ok, Snacks = pcall(require, "snacks")
	if ok then
		Snacks.picker.files({ cwd = root })
	end
end

--- Warn and return false when any of `bufs` has unsaved changes.
local function all_saved(bufs)
	local dirty = {}
	for _, buf in ipairs(bufs) do
		if vim.bo[buf].modified and vim.bo[buf].buftype ~= "nofile" then
			dirty[#dirty + 1] = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(buf), ":~:.")
		end
	end
	if #dirty > 0 then
		notify("Unsaved changes in:\n" .. table.concat(dirty, "\n"), vim.log.levels.WARN)
	end
	return #dirty == 0
end

-- =====================================================================
-- Ownership
-- =====================================================================

--- Everything this instance writes is gated on this (`<leader>uq`, `<leader>qd`).
M.saving_enabled = true

--- Record that this instance may write a project's session. Deliberately does
--- not write anything: sessions are written on exit and by `:ProjectSave`, so
--- merely visiting a project never leaves a half-empty session behind.
---
--- resession's own `attach` flag would do this bookkeeping for us, except that
--- whole-editor and tab sessions are mutually exclusive there -- `save()`
--- clears every tab attachment and `save_tab()` clears the global one -- and we
--- want both: one session per project tab *and* one for the whole editor.
---@param root string?
local function claim(root)
	if not M.saving_enabled or not root or claimed[root] ~= nil then
		return
	end
	-- the project's own instance owns its session; only :ProjectSave overrides
	claimed[root] = M.is_primary(root) or not session_exists(M.project_name(root))
end

--- Write the current tab's project session.
--- Its buffers have to be listed while resession snapshots them: a tab session
--- carries no scope.nvim data, so anything unlisted here comes back invisible
--- in its own tab. Only this tab's buffers are touched -- listing everything
--- would corrupt the tab -> buffer map that scope.nvim writes into the
--- whole-editor session.
---@param root string
---@param tab integer tabpage handle (must be the current tab)
local function save_tab_session(root, tab)
	local r = resession()
	if not r or not root then
		return
	end
	local relist = {}
	local ok, scope = pcall(require, "scope.core")
	if ok then
		-- Do *not* revalidate first: nvim stops firing TabEnter/TabLeave once
		-- VimLeavePre is running, so on exit `scope.cache` is the only record of
		-- what each tab held -- and the listed set is just the last tab visited.
		for _, buf in ipairs(scope.cache[tab] or {}) do
			if vim.api.nvim_buf_is_valid(buf) and not vim.bo[buf].buflisted then
				relist[#relist + 1] = buf
				vim.bo[buf].buflisted = true
			end
		end
	end
	pcall(r.save_tab, M.project_name(root), { attach = false, notify = false })
	for _, buf in ipairs(relist) do
		if vim.api.nvim_buf_is_valid(buf) then
			vim.bo[buf].buflisted = false
		end
	end
end

--- Is there anything worth saving? (persistence.nvim's `need = 1`)
local function has_real_buffer()
	for _, buf in ipairs(vim.api.nvim_list_bufs()) do
		if vim.bo[buf].buftype == "" and vim.api.nvim_buf_get_name(buf) ~= "" then
			return true
		end
	end
	return false
end

--- Write every session this instance owns: each claimed project tab, plus the
--- whole-editor session for the directory nvim was started in.
---@param opts? { notify?: boolean }
function M.save_all(opts)
	opts = opts or {}
	local r = resession()
	if not r or not M.saving_enabled or not has_real_buffer() then
		if opts.notify then
			notify(M.saving_enabled and "Nothing to save" or "Session saving is off", vim.log.levels.WARN)
		end
		return
	end

	local current = vim.api.nvim_get_current_tabpage()
	local written = {}
	for _, tab in ipairs(vim.api.nvim_list_tabpages()) do
		local root = M.tab_root(tab)
		-- `:Project!` can put a second tab on one project; the first in tab order
		-- wins, which is the tab `M.find_tab` hands back
		if root and claimed[root] and not written[root] then
			written[root] = true
			-- save_tab always snapshots the *current* tab
			pcall(vim.api.nvim_set_current_tabpage, tab)
			save_tab_session(root, tab)
		end
	end
	pcall(vim.api.nvim_set_current_tabpage, current)

	-- the whole-editor session needs no such care: `buf_filter` ignores
	-- 'buflisted' and scope.nvim's extension records the tab -> buffer map
	local instance = M.instance_name()
	if instance then
		pcall(r.save, instance, { attach = false, notify = false })
	end
	if opts.notify then
		notify("Sessions saved")
	end
end

--- Stop this instance from writing any session on exit.
function M.detach()
	M.saving_enabled = false
	local r = resession()
	if r then
		pcall(r.detach)
	end
	notify("Session saving off -- nothing will be written on exit")
end

--- Resume session saving (the other half of the `<leader>uq` toggle).
function M.attach()
	M.saving_enabled = true
	claim(M.tab_root(0))
	notify("Session saving on")
end

--- Replace the whole editor with session `name` (or with an empty `cwd` when
--- there is none). Every buffer is wiped first: resession's reset only deletes
--- *listed* ones, scope.nvim unlists every other tab's, and `buf_filter`
--- ignores 'buflisted' -- so leftovers would be written into the next session.
--- `:tabonly` keeps the surviving tab's variables, hence the explicit untag.
---@param name string?
---@param force boolean? discard unsaved changes
---@param cwd string? global cwd to move to before loading
---@return boolean restored
local function restore(name, force, cwd)
	local r = resession()
	if not r or not (force or all_saved(vim.api.nvim_list_bufs())) then
		return false
	end
	vim.cmd("silent! tabonly")
	vim.cmd("silent! %bwipeout!")
	vim.t.project_root = nil
	if cwd then
		-- `:cd` (not vim.fn.chdir) so the tab's local dir is dropped too
		vim.cmd("cd " .. vim.fn.fnameescape(cwd))
	end
	if name then
		pcall(r.load, name, { reset = true, attach = false })
	end
	claimed = {} -- every tab we claimed is gone
	tag_tabs()
	claim(M.tab_root(0))
	return true
end

-- =====================================================================
-- Tab mode
-- =====================================================================

--- Open a project in its own tabpage, restoring its session if it has one.
---@param dir string
---@param opts? { force_new?: boolean }
function M.open(dir, opts)
	opts = opts or {}
	local root = normalize(dir)
	if not root or vim.fn.isdirectory(root) == 0 then
		return notify("Not a directory: " .. tostring(dir), vim.log.levels.ERROR)
	end

	if not opts.force_new then
		local tab = M.find_tab(root)
		if tab then
			vim.api.nvim_set_current_tabpage(tab)
			return
		end
	end

	local r = resession()
	local name = M.project_name(root)
	local saved = session_exists(name)

	step_off_project_tab(root, opts.force_new)

	if saved and r then
		-- resession reuses the clean tab, then restores this tab's window
		-- layout, its buffers and its `tcd`
		pcall(r.load, name, { reset = false, attach = false })
	else
		open_clean_tab()
		vim.cmd("tcd " .. vim.fn.fnameescape(root))
	end

	vim.t.project_root = root
	claim(root)
	if not tab_has_file() then
		pick_files(root)
	end
	notify(vim.fn.fnamemodify(root, ":~") .. (saved and "" or "  (new)"))
end

--- Save and close the current project tab, freeing the buffers only it used
--- (scope.nvim merely unlists them, it never frees them).
function M.close()
	local tab = vim.api.nvim_get_current_tabpage()
	local root = M.tab_root(tab)

	-- with scope.nvim the listed buffers are exactly this tab's buffers
	local listed = vim.tbl_filter(function(buf)
		return vim.bo[buf].buflisted
	end, vim.api.nvim_list_bufs())
	if not all_saved(listed) then
		return
	end
	local elsewhere = {}
	local ok, scope = pcall(require, "scope.core")
	if ok then
		for other, bufs in pairs(scope.cache) do
			if other ~= tab then
				for _, buf in ipairs(bufs) do
					elsewhere[buf] = true
				end
			end
		end
	end
	local doomed = vim.tbl_filter(function(buf)
		return not elsewhere[buf]
	end, listed)

	if root and claimed[root] and M.saving_enabled then
		save_tab_session(root, tab)
	end

	if #vim.api.nvim_list_tabpages() > 1 then
		vim.cmd("tabclose")
	else
		vim.t.project_root = nil
		vim.cmd("enew")
	end
	for _, buf in ipairs(doomed) do
		pcall(vim.api.nvim_buf_delete, buf, { force = true })
	end
	if root then
		notify("Closed " .. vim.fn.fnamemodify(root, ":~"))
	end
end

-- =====================================================================
-- Clean mode
-- =====================================================================

--- Reset the editor and restore the project in place, moving the global cwd
--- with it -- this instance becomes that project's primary.
---@param dir string
---@param opts? { force?: boolean }
function M.switch(dir, opts)
	opts = opts or {}
	local root = normalize(dir)
	if not root or vim.fn.isdirectory(root) == 0 then
		return notify("Not a directory: " .. tostring(dir), vim.log.levels.ERROR)
	end

	M.save_all()
	local instance, project = M.instance_name(root), M.project_name(root)
	local name = session_exists(instance) and instance or session_exists(project) and project or nil
	if not restore(name, opts.force, root) then
		return
	end
	-- `tag_tabs` derives each restored tab from its own cwd; the tab we land on
	-- after an instance restore is whichever one was current when it was saved,
	-- so tagging it `root` outright would mislabel another project's tab.
	local home = M.find_tab(root)
	if home then
		vim.api.nvim_set_current_tabpage(home)
	else
		vim.t.project_root = root
	end
	claim(root) -- the global cwd is root now: this instance is its primary
	if not tab_has_file() then
		pick_files(root)
	end
	notify(vim.fn.fnamemodify(root, ":~"))
end

-- =====================================================================
-- Sessions
-- =====================================================================

--- Restore the session for the current directory: the whole-editor one if this
--- instance saved one, else the project's own tab session (in a tab).
function M.load_instance()
	local root = M.primary()
	if root and session_exists(M.instance_name(root)) then
		restore(M.instance_name(root))
	elseif root and session_exists(M.project_name(root)) then
		M.open(root)
	else
		notify("No saved session for " .. vim.fn.fnamemodify(root or "", ":~"), vim.log.levels.WARN)
	end
end

--- Restore a saved session over the whole editor: the most recently written
--- one when `last`, else one picked from the list.
---@param last boolean?
function M.load_saved(last)
	local r = resession()
	local sessions = r and r.list() or {} -- newest first
	if #sessions == 0 then
		return notify("No saved sessions", vim.log.levels.WARN)
	end
	if last then
		return restore(sessions[1])
	end
	vim.ui.select(sessions, { prompt = "Load session" }, function(name)
		if name then
			restore(name)
		end
	end)
end

--- Explicitly write the current tab's project session, taking ownership of it.
function M.save()
	local r = resession()
	local root = M.tab_root(0)
	if not r or not root then
		return notify("Not in a project tab", vim.log.levels.WARN)
	end
	claimed[root] = true -- an explicit save takes ownership from here on
	save_tab_session(root, vim.api.nvim_get_current_tabpage())
	notify("Saved " .. vim.fn.fnamemodify(root, ":~"))
end

-- =====================================================================
-- Picker
-- =====================================================================

--- snacks projects picker wired to this module.
---@param opts? { mode?: "tab"|"clean" }
function M.pick(opts)
	opts = opts or {}
	local ok, Snacks = pcall(require, "snacks")
	if not ok then
		return notify("snacks.nvim is not available", vim.log.levels.ERROR)
	end
	Snacks.picker.projects({
		confirm = function(picker, item)
			picker:close()
			if item then
				if opts.mode == "clean" then
					M.switch(item.file)
				else
					M.open(item.file)
				end
			end
		end,
	})
end

--- Open project tabs, in tab order.
---@return { tab: integer, root: string }[]
function M.list()
	local out = {}
	for _, tab in ipairs(vim.api.nvim_list_tabpages()) do
		local root = M.tab_root(tab)
		if root then
			out[#out + 1] = { tab = tab, root = root }
		end
	end
	return out
end

-- =====================================================================
-- Setup
-- =====================================================================

local function startup()
	if vim.g.started_with_stdin then
		return
	end
	local argc = vim.fn.argc()
	if argc > 1 then
		return
	elseif argc == 1 then
		local arg = vim.fn.argv(0)
		if type(arg) == "string" and vim.fn.isdirectory(arg) == 1 then
			vim.cmd("silent! %bwipeout")
			vim.cmd("cd " .. vim.fn.fnameescape(arg))
		else
			return
		end
	end

	local r = resession()
	local root = M.primary()
	if not r or not root then
		return
	end

	if session_exists(M.instance_name(root)) then
		return restore(M.instance_name(root))
	elseif session_exists(M.project_name(root)) then
		-- launched inside a project whose only session came from a tab visit
		pcall(r.load, M.project_name(root), { reset = "auto", attach = false })
	end
	tag_tabs()
	claim(M.tab_root(0))
end

function M.setup(opts)
	M.config = vim.tbl_deep_extend("force", M.config, opts or {})

	local group = vim.api.nvim_create_augroup("igmrrfProjects", { clear = true })
	local r = resession()
	if r then
		r.add_hook("post_load", function()
			vim.schedule(tag_tabs)
		end)
	end

	-- `nvim < file` / `some | nvim -` must not restore a session over the pipe
	vim.api.nvim_create_autocmd("StdinReadPre", {
		group = group,
		callback = function()
			vim.g.started_with_stdin = true
		end,
	})

	vim.api.nvim_create_autocmd("VimEnter", {
		group = group,
		-- Scheduled, not `nested`: inside the autocmd, the FileType that fires while
		-- buffers load sets did_filetype(), so resession's closing `:edit` reload
		-- skips `:setfiletype` -- and treesitter, torn down by the reload, never
		-- restarts until another file is opened.
		callback = function()
			vim.schedule(startup)
		end,
	})

	-- note the ownership of a project tab the first time we land in it
	vim.api.nvim_create_autocmd("TabEnter", {
		group = group,
		callback = function()
			claim(M.tab_root(0))
		end,
	})

	-- Sessions are written here and nowhere else (resession's own autosave is
	-- off), so a project you are only visiting keeps the state it has from its
	-- own folder unless you claimed it or saved it explicitly.
	vim.api.nvim_create_autocmd("VimLeavePre", {
		group = group,
		callback = function()
			M.save_all()
		end,
	})

	vim.api.nvim_create_user_command("Project", function(args)
		if args.args == "" then
			M.pick()
		else
			M.open(args.args, { force_new = args.bang })
		end
	end, { nargs = "?", bang = true, complete = "dir", desc = "Open project in a tab" })

	vim.api.nvim_create_user_command("ProjectSwitch", function(args)
		if args.args == "" then
			M.pick({ mode = "clean" })
		else
			M.switch(args.args, { force = args.bang })
		end
	end, { nargs = "?", bang = true, complete = "dir", desc = "Switch project (reset + load its session)" })

	vim.api.nvim_create_user_command("ProjectClose", function()
		M.close()
	end, { desc = "Close current project tab and free its buffers" })

	vim.api.nvim_create_user_command("ProjectSave", function()
		M.save()
	end, { desc = "Write this project's session, taking ownership of it" })
end

return M
