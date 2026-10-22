-- Sessions are resession.nvim, not `:mksession`. It writes its own JSON, which
-- is what makes *tab-scoped* sessions possible: `save_tab()` snapshots a single
-- tabpage (layout, buffers, tab cwd) and `load(name, { reset = false })`
-- restores it into one tab without touching the rest of the editor. A mksession
-- file starts with `silent only` + `silent tabonly`, so it can only ever
-- replace the whole editor -- see lua/projects.lua, which builds one-tab-per-
-- project on top of this.
--
-- Saving is driven from lua/projects.lua on VimLeavePre, which writes one
-- session per project tab this instance owns plus one for the whole editor --
-- so a project you are only visiting in a tab keeps the state it has from its
-- own folder.
return {
	"stevearc/resession.nvim",
	lazy = false,
	priority = 1000,
    -- stylua: ignore
	keys = {
		{ "<leader>qs", function() require("projects").load_instance() end, desc = "Restore session (current dir)" },
		{ "<leader>qS", function() require("projects").load_saved() end, desc = "Select / search session" },
		{ "<leader>ql", function() require("projects").load_saved(true) end, desc = "Restore last session" },
		{ "<leader>qw", function() require("projects").save_all({ notify = true }) end, desc = "Save sessions now" },
		{ "<leader>qd", function() require("projects").detach() end, desc = "Don't save current session on exit" },
	},
	opts = {
		-- lua/projects.lua does the saving: resession's autosave can only ever
		-- keep one *kind* of session attached (whole-editor or tab-scoped,
		-- never both), and this config wants a session per project tab as well
		-- as one for the whole editor
		autosave = { enabled = false },
		-- scope.nvim ships a resession extension: it round-trips the
		-- tab -> buffer map so a restored session keeps each tab's hidden
		-- buffers instead of collapsing them to whatever was visible
		extensions = { scope = {} },
		-- resession's default filter only keeps *listed* buffers, but scope.nvim
		-- lists exactly one tab's buffers at a time -- so a whole-editor session
		-- would capture whichever tab happened to be current and silently drop
		-- every other tab's buffers and window layout. Real files only: "acwrite"
		-- buffers (oil://, fugitive://) come back as blank pages, because the
		-- plugin that renders them is lazy-loaded and never sees the restore.
		buf_filter = function(bufnr)
			return vim.bo[bufnr].buftype == "" and vim.api.nvim_buf_get_name(bufnr) ~= ""
		end,
		-- Without this a tab-scoped session sweeps in every listed buffer in
		-- the editor -- including other projects' -- because the default
		-- filter returns true for everything. Buffers shown in the tab's own
		-- windows are always included regardless.
		tab_buf_filter = function(tabpage, bufnr)
			if not vim.api.nvim_tabpage_is_valid(tabpage) then
				return false
			end
			local ok, dir = pcall(vim.fn.getcwd, -1, vim.api.nvim_tabpage_get_number(tabpage))
			local name = vim.api.nvim_buf_get_name(bufnr)
			if not ok or dir == "" or name == "" then
				return false
			end
			return vim.startswith(vim.fs.normalize(name), vim.fs.normalize(dir) .. "/")
		end,
	},
	config = function(_, opts)
		require("resession").setup(opts)

		local function patch_scope_extension()
			local ok, ext = pcall(require, "resession.extensions.scope")
			if not ok or ext._tab_ordered then
				return
			end
			local core = require("scope.core")
			local utils = require("scope.utils")
			ext._tab_ordered = true
			-- resession aliases `on_load` over `on_post_load` when it first
			-- resolves the extension, which would put the broken half back
			ext.on_load = nil

			ext.on_save = function()
				core.revalidate() -- refresh the current tab, which is only cached on TabLeave
				local cache = {}
				for i, tab in ipairs(vim.api.nvim_list_tabpages()) do
					cache[i] = utils.get_buffer_names(core.cache[tab] or {})
				end
				return { state = vim.json.encode({ cache = cache }) }
			end

			ext.on_post_load = function(data)
				local state = vim.json.decode(data.state)
				-- resolve against the buffers resession just restored; `badd`-ing the
				-- missing ones (what scope.nvim does) breaks on paths with spaces
				local by_name = {}
				for _, buf in ipairs(vim.api.nvim_list_bufs()) do
					by_name[vim.api.nvim_buf_get_name(buf)] = buf
					vim.bo[buf].buflisted = false
				end
				core.cache = {}
				for i, tab in ipairs(vim.api.nvim_list_tabpages()) do
					local bufs = {}
					for _, name in ipairs(state.cache[i] or {}) do
						if by_name[name] then
							bufs[#bufs + 1] = by_name[name]
						end
					end
					core.cache[tab] = bufs
				end
				core.last_tab = vim.api.nvim_get_current_tabpage()
				core.on_tab_enter() -- list the buffers belonging to the tab we landed on
			end
		end

		-- scope.nvim's own resession extension keys its tab -> buffer map by
		-- tabpage *handle*, serialises it through `pairs` into a plain array and
		-- reads it back as handles 1..N. Handles go sparse the moment a tab is
		-- closed ({1, 2, 4}), and after resession's `:tabonly` they do not start
		-- at 1 at all -- so a mid-session restore hands each tab another tab's
		-- buffers, and the tab you land on gets none. Key by tab *order* instead.
		-- Patched from a hook: scope.nvim is not on the runtimepath yet here.
		require("resession").add_hook("pre_save", patch_scope_extension)
		require("resession").add_hook("pre_load", patch_scope_extension)
	end,
}
