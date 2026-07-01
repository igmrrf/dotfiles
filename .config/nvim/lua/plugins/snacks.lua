vim.pack.add({
	"https://github.com/nvim-tree/nvim-web-devicons",
	{ src = "https://github.com/folke/snacks.nvim" },
})
local Snacks = require("snacks")

local utils = require("utils")
local function toggleSnacksTerminal()
	local terminal_closed = false
	-- Iterate through all registered Snacks terminals
	for _, term in pairs(Snacks.terminal.list()) do
		-- Safely check if the terminal has a window and if that window is actively rendered
		if term.win and vim.api.nvim_win_is_valid(term.win) then
			term:hide()
			terminal_closed = true
		end
	end

	-- If we didn't close anything, it means no terminals are visible. Open the default.
	if not terminal_closed then
		Snacks.terminal.toggle()
	end
end

require("snacks").setup({
	animate = { enabled = true },
	bigfile = { enabled = true },
	bufdelete = { enabled = true },
	dashboard = {
		enabled = true,
		preset = {
			-- We override the keys to remove Lazy and integrate your lean stack
			keys = {
				{ icon = " ", key = "f", desc = "Find File", action = ":lua Snacks.picker.files()" },
				{ icon = " ", key = "n", desc = "New File", action = ":ene | startinsert" },
				{ icon = " ", key = "g", desc = "Find Text", action = ":lua Snacks.picker.grep()" },
				{ icon = " ", key = "r", desc = "Recent Files", action = ":lua Snacks.picker.recent()" },
				{ icon = "󰦛 ", key = "s", desc = "Restore Session", action = ":lua require('mini.sessions').select()" },
				{ icon = "󰚰 ", key = "u", desc = "Update Plugins", action = ":UpdatePlugins" },
				{ icon = " ", key = "q", desc = "Quit", action = ":qa" },
			},
		},
		sections = {

			{ section = "keys", gap = 1, padding = 1 },
			-- { icon = " ", title = "Recent Files", section = "recent_files", indent = 2, padding = 1 },
			-- { pane = 2, icon = " ", title = "Projects", section = "projects", indent = 2, padding = 1 },
			{
				pane = 2,
				icon = " ",
				desc = "Browse Repo",
				padding = 1,
				key = "b",
				action = function()
					Snacks.gitbrowse()
				end,
			},
			function()
				local in_git = Snacks.git.get_root() ~= nil
				local cmds = {
					{
						title = "Open Issues",
						cmd = "gh issue list -L 3",
						key = "i",
						action = function()
							vim.fn.jobstart("gh issue list --web", { detach = true })
						end,
						icon = " ",
						height = 5,
					},
					{
						icon = " ",
						title = "Open PRs",
						cmd = "gh pr list -L 3",
						key = "P",
						action = function()
							vim.fn.jobstart("gh pr list --web", { detach = true })
						end,
						height = 5,
					},
					{

						enabled = function()
							return Snacks.git.get_root() ~= nil
						end,
						icon = " ",
						title = "Git Status",
						cmd = "git --no-pager diff --stat -B -M -C",
						height = 5,
					},
				}
				return vim.tbl_map(function(cmd)
					return vim.tbl_extend("force", {
						pane = 2,
						section = "terminal",
						enabled = in_git,
						padding = 1,
						ttl = 5 * 60,
						indent = 3,
					}, cmd)
				end, cmds)
			end,
			-- { pane = 2, section = "terminal", cmd = "task next limit:5", height = 10, padding = 1 },
			{ pane = 2, section = "terminal", cmd = "curl -s 'wttr.in/?0q'", height = 7, padding = 1 },
		},
	},

	explorer = { enabled = false },
	indent = { enabled = true },
	input = { enabled = true },
	image = { enabled = true },
	notifier = {
		enabled = true,
		timeout = 3000,
	},
	picker = { enabled = true },
	quickfile = { enabled = true },
	scope = { enabled = true },
	scroll = { enabled = true },
	statuscolumn = { enabled = true },
	syles = {
		notification = {
			-- wo = { wrap = true } -- Wrap notifications
		},
	},
	terminal = {
		win = {
			position = "float",
			width = 0.9,
			height = 0.9,
			border = "rounded",
		},
		float = {
			width = 0.9,
			height = 0.9,
			border = "single",
		},
	},
	words = { enabled = true },
})
Snacks.keymap.set("n", "<leader>w", ":w<cr>", { desc = "Save" })
Snacks.keymap.set({ "n", "v" }, "<leader>y", '"+y', { desc = "Copy to clipboard" })
Snacks.keymap.set({ "n", "v" }, "<leader>p", '"+p', { desc = "Paste from system to clipboard" })
Snacks.keymap.set({ "t" }, "<C-]>", "<C-\\><C-n>", { desc = "Enter copy mode" })
-- Set keymap for buffers with any LSP that supports code actions
Snacks.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, {
	lsp = { method = "textDocument/codeAction" },
	desc = "Code Action",
})

-- Set keymap for buffers with a specific LSP client
Snacks.keymap.set("n", "<leader>co", function()
	vim.lsp.buf.code_action({
		apply = true,
		context = {
			only = { "source.organizeImports" },
			diagnostics = {},
		},
	})
end, {
	lsp = { name = "vtsls" },
	desc = "Organize Imports",
})

-- Set keymap for buffers with LSP that supports definitions
Snacks.keymap.set("n", "gd", vim.lsp.buf.definition, {
	lsp = { method = "textDocument/definition" },
	desc = "Go to Definition",
})

-- Setup some globals for debugging (lazy-loaded)
_G.dd = function(...)
	Snacks.debug.inspect(...)
end
_G.bt = function()
	Snacks.debug.backtrace()
end

-- Override print to use snacks for `:=` command
if vim.fn.has("nvim-0.11") == 1 then
	vim._print = function(_, ...)
		dd(...)
	end
else
	vim.print = _G.dd
end

-- Create some toggle mappings
Snacks.toggle.option("spell", { name = "Spelling" }):map("<leader>us")
Snacks.toggle.option("wrap", { name = "Wrap" }):map("<leader>uw")
Snacks.toggle.option("relativenumber", { name = "Relative Number" }):map("<leader>uL")
Snacks.toggle.diagnostics():map("<leader>ud")
Snacks.toggle.scroll():map("<leader>uS")
Snacks.toggle.line_number():map("<leader>ul")
Snacks.toggle
	.option("conceallevel", { off = 0, on = vim.o.conceallevel > 0 and vim.o.conceallevel or 2 })
	:map("<leader>uc")
Snacks.toggle.treesitter():map("<leader>uT")
Snacks.toggle.option("background", { off = "light", on = "dark", name = "Dark Background" }):map("<leader>ub")
Snacks.toggle.inlay_hints():map("<leader>ui")
Snacks.toggle.indent():map("<leader>ug")
Snacks.toggle.animate():map("<leader>ua")
Snacks.toggle.words():map("<leader>uW")
Snacks.toggle.profiler():map("<leader>up")
Snacks.toggle.profiler_highlights():map("<leader>uh")
Snacks.toggle.dim():map("<leader>uD")

 -- stylua: ignore
 local  keys = {
    { "<leader>pp", function() Snacks.profiler.scratch() end, desc = "Profiler Scratch Bufer" },
    { "<leader>ps", function() Snacks.profiler.start() end,   desc = "Profiler start" },
    { "<leader>pS", function() Snacks.profiler.stop() end,    desc = "Profiler stop" },
    { "<leader>st", function() Snacks.picker.todo_comments() end,   desc = "Todo comments",                mode = { "n",                         "x" } },

    { "<leader>yc", function() Snacks.terminal("claude") end, mode = "n",                           desc = "Claude CLI" },
    { "<leader>yg", function() Snacks.terminal("agy") end, mode = "n",                           desc = "Gemini Cli" },
    { "<leader>yG", function() Snacks.terminal("agy --resume") end, mode = "n",                           desc = "Gemini Cli Resume" },
    { "<leader>yp", function() Snacks.terminal("spotify_player") end, mode = "n",                           desc = "Spotify" },
    { "<leader>yt", function() Snacks.terminal("taskui") end, mode = "n",                           desc = "Task Warrior UI" },
    { "<leader>yy", function() Snacks.terminal("y") end, mode = "n",                           desc = "Yazi File Explorer" },
    { "<leader>yd", function() Snacks.terminal("lazydocker") end, mode = "n",                           desc = "Lazy Docker" },

    { "<leader>fi", function() Snacks.picker.files({ hidden = true, ignored = true,                        exclude = vim.g.exclude_finds }) end, mode = "n", desc = "Find git ignored & hidden files" },

    -- Buffer Management
    { "<leader>bd",      function() Snacks.bufdelete.delete() end,                               desc = "Delete current buffer" },
    { "<leader>bq",      function() Snacks.bufdelete.all() end,                               desc = "Delete all buffers" },
    { "<leader>bo",      function() Snacks.bufdelete.other() end,                                desc = "Delete other buffers" },
    -- Top Pickers & Explorer
    { "<leader><space>", function() Snacks.picker.files() end,                                   desc = "Find Files" },
    { "<leader>,",       function() Snacks.picker.buffers() end,                                 desc = "Buffers" },
    { "<leader>/",       function() Snacks.picker.grep() end,                                    desc = "Grep" },
    { "<leader>:",       function() Snacks.picker.command_history() end,                         desc = "Command History" },
    { "<leader>n",       function() Snacks.picker.notifications() end,                           desc = "Notification History" },
    -- find
    { "<leader>fb",      function() Snacks.picker.buffers() end,                                 desc = "Buffers" },
    { "<leader>fc",      function() Snacks.picker.files({ cwd = vim.fn.stdpath("config") }) end, desc = "Find Config File" },
    { "<leader>ff",      function() Snacks.picker.files() end,                                   desc = "Find Files" },
    { "<leader>fg",      function() Snacks.picker.git_files() end,                               desc = "Find Git Files" },
    { "<leader>fp",      function() Snacks.picker.projects() end,                                desc = "Projects" },
    { "<leader>fr",      function() Snacks.picker.recent() end,                                  desc = "Recent" },
    -- git
    { "<leader>gb", function() Snacks.picker.git_branches() end, desc = "Git Branches" },
    { "<leader>g.", function() Snacks.git.blame_line() end, desc = "Git blame line" },
    { "<leader>gl", function() Snacks.picker.git_log() end, desc = "Git Log" },
    { "<leader>gL", function() Snacks.picker.git_log_line() end, desc = "Git Log Line" },
    { "<leader>gs", function() Snacks.picker.git_status() end, desc = "Git Status" },
    { "<leader>gS", function() Snacks.picker.git_stash() end, desc = "Git Stash" },
    { "<leader>gd", function() Snacks.picker.git_diff() end, desc = "Git Diff (Hunks)" },
    { "<leader>gf", function() Snacks.picker.git_log_file() end, desc = "Git Log File" },
    { "<leader>gf", function() Snacks.picker.git_log_file() end, desc = "Git Log File" },
    -- gh
    { "<leader>gi", function() Snacks.picker.gh_issue() end, desc = "GitHub Issues (open)" },
    { "<leader>gI", function() Snacks.picker.gh_issue({ state = "all" }) end, desc = "GitHub Issues (all)" },
    { "<leader>gp", function() Snacks.picker.gh_pr() end, desc = "GitHub Pull Requests (open)" },
    { "<leader>gP", function() Snacks.picker.gh_pr({ state = "all" }) end, desc = "GitHub Pull Requests (all)" },
    -- Grep
    { "<leader>sb", function() Snacks.picker.lines() end, desc = "Buffer Lines" },
    { "<leader>sB", function() Snacks.picker.grep_buffers() end, desc = "Grep Open Buffers" },
    { "<leader>sg", function() Snacks.picker.grep() end, desc = "Grep" },
    { "<leader>sG", function() Snacks.picker.grep({ hidden=true, ignored = true, exclude = vim.g.exclude_finds  }) end, desc = "Grep" },
    { "<leader>sw", function() Snacks.picker.grep_word() end, desc = "Visual selection or word", mode = { "n", "x" } },
    -- search
    { '<leader>s"', function() Snacks.picker.registers() end, desc = "Registers" },
    { '<leader>s/', function() Snacks.picker.search_history() end, desc = "Search History" },
    { "<leader>sa", function() Snacks.picker.autocmds() end, desc = "Autocmds" },
    { "<leader>sb", function() Snacks.picker.lines() end, desc = "Buffer Lines" },
    { "<leader>sc", function() Snacks.picker.command_history() end, desc = "Command History" },
    { "<leader>sC", function() Snacks.picker.commands() end, desc = "Commands" },
    { "<leader>sd", function() Snacks.picker.diagnostics() end, desc = "Diagnostics" },
    { "<leader>sD", function() Snacks.picker.diagnostics_buffer() end, desc = "Buffer Diagnostics" },
    { "<leader>sh", function() Snacks.picker.help() end, desc = "Help Pages" },
    { "<leader>sH", function() Snacks.picker.highlights() end, desc = "Highlights" },
    { "<leader>si", function() Snacks.picker.icons() end, desc = "Icons" },
    { "<leader>sj", function() Snacks.picker.jumps() end, desc = "Jumps" },
    { "<leader>sk", function() Snacks.picker.keymaps() end, desc = "Keymaps" },
    { "<leader>sl", function() Snacks.picker.loclist() end, desc = "Location List" },
    { "<leader>sm", function() Snacks.picker.marks() end, desc = "Marks" },
    { "<leader>sM", function() Snacks.picker.man() end, desc = "Man Pages" },
    { "<leader>sp", function() Snacks.picker.projects() end, desc = "Search for Plugin Spec" },
    { "<leader>sq", function() Snacks.picker.qflist() end, desc = "Quickfix List" },
    { "<leader>sR", function() Snacks.picker.resume() end, desc = "Resume" },
    { "<leader>su", function() Snacks.picker.undo() end, desc = "Undo History" },
    { "<leader>uC", function() Snacks.picker.colorschemes() end, desc = "Colorschemes" },
    -- LSP
    { "gd", function() Snacks.picker.lsp_definitions() end, desc = "Goto Definition" },
    { "gD", function() Snacks.picker.lsp_declarations() end, desc = "Goto Declaration" },
    { "gr", function() Snacks.picker.lsp_references() end, nowait = true, desc = "References" },
    { "gI", function() Snacks.picker.lsp_implementations() end, desc = "Goto Implementation" },
    { "gy", function() Snacks.picker.lsp_type_definitions() end, desc = "Goto T[y]pe Definition" },
    { "gai", function() Snacks.picker.lsp_incoming_calls() end, desc = "C[a]lls Incoming" },
    { "gao", function() Snacks.picker.lsp_outgoing_calls() end, desc = "C[a]lls Outgoing" },
    { "<leader>ss", function() Snacks.picker.lsp_symbols() end, desc = "LSP Symbols" },
    { "<leader>sS", function() Snacks.picker.lsp_workspace_symbols() end, desc = "LSP Workspace Symbols" },
    -- Other
    { "<leader>uz",  function() Snacks.zen() end, desc = "Toggle Zen Mode" },
    { "<leader>um",  function() Snacks.zen.zoom() end, desc = "Toggle Zoom" },
    { "<leader>.",  function() Snacks.scratch() end, desc = "Toggle Scratch Buffer" },
    { "<leader>s.",  function() Snacks.scratch.select() end, desc = "Select Scratch Buffer" },
    { "<leader>n",  function() Snacks.notifier.show_history() end, desc = "Notification History" },
    { "<leader>bd", function() Snacks.bufdelete() end, desc = "Delete Buffer" },
    { "<leader>cR", function() Snacks.rename.rename_file() end, desc = "Rename File" },
    { "<leader>gB", function() Snacks.gitbrowse() end, desc = "Git Browse", mode = { "n", "v" } },
    { "<leader>gg", function() Snacks.lazygit() end, desc = "Lazygit" },
    { "<leader>un", function() Snacks.notifier.hide() end, desc = "Dismiss All Notifications" },
    { "<c-/>", toggleSnacksTerminal, desc = "Toggle Terminal", mode = { "n", "t", "i", "x" } },
    { "<A-/>",      function() Snacks.terminal(nil, {  env = { SNACKS_TYPE = "disposable_shell" }, win = { position = "float", border = "rounded", title = " Disposable Terminal ", title_pos = "center", width = 0.6, height = 0.6, backdrop = 60, zindex = 50,  }, start_insert = true, cwd = vim.fn.getcwd(), }) end, desc = "Disposal Terminal", mode = { "n", "t" } },
    { "<c-_>", toggleSnacksTerminal, desc = "which_key_ignore", mode = { "n", "t" } },
    { "]]",         function() Snacks.words.jump(vim.v.count1) end, desc = "Next Reference", mode = { "n", "t" } },
    { "[[",         function() Snacks.words.jump(-vim.v.count1) end, desc = "Prev Reference", mode = { "n", "t" } },
    {
      "<leader>N",
      desc = "Neovim News",
      function()
        Snacks.win({
          file = vim.api.nvim_get_runtime_file("doc/news.txt", false)[1],
          width = 0.6,
          height = 0.6,
          wo = {
            spell = false,
            wrap = false,
            signcolumn = "yes",
            statuscolumn = " ",
            conceallevel = 3,
          },
        })
      end,
    }
  }
utils.map_plugin_keys(keys)

vim.api.nvim_create_autocmd("FileType", {
	-- TODO: move to somewhere neutral
	pattern = { "snacks_picker_input" },
	callback = function(args)
		if args.buf ~= nil then
			vim.bo[args.buf].autocomplete = false
		else
			vim.opt.autocomplete = false
		end
	end,
})

-- =====================================================================
-- Autocmds for file rename
-- =====================================================================
vim.api.nvim_create_autocmd({ "FileType" }, {
	pattern = { "netrw" },
	group = vim.api.nvim_create_augroup("NetrwOnRename", { clear = true }),
	callback = function()
		vim.keymap.set("n", "R", function()
			local original_file_path = vim.b.netrw_curdir .. "/" .. vim.fn["netrw#Call"]("NetrwGetWord")

			vim.ui.input({ prompt = "Move/rename to:", default = original_file_path }, function(target_file_path)
				if target_file_path and target_file_path ~= "" then
					local file_exists = vim.uv.fs_access(target_file_path, "W")

					if not file_exists then
						vim.uv.fs_rename(original_file_path, target_file_path)

						Snacks.rename.on_rename_file(original_file_path, target_file_path)
					else
						vim.notify("File '" .. target_file_path .. "' already exists! Skipping...", vim.log.levels.ERROR)
					end

					-- Refresh netrw
					vim.cmd(":Ex " .. vim.b.netrw_curdir)
				end
			end)
		end, { remap = true, buffer = true })
	end,
})

vim.api.nvim_create_autocmd("User", {
	pattern = "MiniFilesActionRename",
	callback = function(event)
		Snacks.rename.on_rename_file(event.data.from, event.data.to)
	end,
})

vim.api.nvim_create_autocmd("User", {
	pattern = "OilActionsPost",
	callback = function(event)
		if event.data.actions[1].type == "move" then
			Snacks.rename.on_rename_file(event.data.actions[1].src_url, event.data.actions[1].dest_url)
		end
	end,
})

-- =====================================================================
-- Terminal Layout Toggles (Float <-> Split <-> Tab)
-- =====================================================================

vim.api.nvim_create_autocmd("TermOpen", {
	desc = "Toggle terminal layouts dynamically",
	pattern = "*",
	callback = function(event)
		local opts = { buffer = event.buf, silent = true }

		-- Initialize state: Snacks terminals start as floats by default
		vim.b[event.buf].term_layout = vim.b[event.buf].term_layout or "float"

		-- [ Toggle Tab ]
		-- Press <C-t> to move to a full tab, press again to restore float
		vim.keymap.set("t", "<C-t>", function()
			local buf = vim.api.nvim_get_current_buf()
			local win = vim.api.nvim_get_current_win()

			if vim.b[buf].term_layout ~= "tab" then
				-- Move TO Tab
				vim.cmd("tab sbuffer " .. buf)
				pcall(vim.api.nvim_win_close, win, true)
				vim.b[buf].term_layout = "tab"
			else
				-- Move BACK TO Float
				if #vim.api.nvim_list_tabpages() > 1 then
					vim.cmd("tabclose") -- Close the tab safely
				else
					pcall(vim.api.nvim_win_close, win, true)
				end
				Snacks.terminal() -- Tell Snacks to revive the hidden terminal as a float
				vim.b[buf].term_layout = "float"
			end
			vim.cmd("startinsert")
		end, opts)

		-- [ Toggle Split ]
		-- Press <C-w>S to move to a bottom split, press again to restore float
		vim.keymap.set("t", "<C-s>", function()
			local buf = vim.api.nvim_get_current_buf()
			local win = vim.api.nvim_get_current_win()

			if vim.b[buf].term_layout ~= "split" then
				-- Move TO Split
				vim.cmd("vertical sbuffer " .. buf)
				-- vim.cmd("resize 15")
				pcall(vim.api.nvim_win_close, win, true)
				vim.b[buf].term_layout = "split"
			else
				-- Move BACK TO Float
				pcall(vim.api.nvim_win_close, win, true)
				Snacks.terminal() -- Tell Snacks to revive the hidden terminal as a float
				vim.b[buf].term_layout = "float"
			end
			vim.cmd("startinsert")
		end, opts)
	end,
})
