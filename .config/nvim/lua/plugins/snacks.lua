local function toggleSnacksTerminal()
	local Snacks = require("snacks")
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

return {
	"folke/snacks.nvim",
	priority = 1000,
	lazy = false,
	dependencies = {
		"nvim-tree/nvim-web-devicons",
	},
    -- stylua: ignore
	keys = {
		{ "<leader>pp", function() require("snacks").profiler.scratch() end, desc = "Profiler Scratch Buffer" },
		{ "<leader>ps", function() require("snacks").profiler.start() end, desc = "Profiler start" },
		{ "<leader>pS", function() require("snacks").profiler.stop() end, desc = "Profiler stop" },
		{ "<leader>st", function() require("snacks").picker.todo_comments() end, desc = "Todo comments", mode = { "n", "x" } },

		{ "<leader>yc", function() require("snacks").terminal("claude") end, mode = "n", desc = "Claude CLI" },
		{ "<leader>yg", function() require("snacks").terminal("agy") end, mode = "n", desc = "Gemini Cli" },
		{ "<leader>yG", function() require("snacks").terminal("agy --resume") end, mode = "n", desc = "Gemini Cli Resume" },
		{ "<leader>yp", function() require("snacks").terminal("spotify_player") end, mode = "n", desc = "Spotify" },
		{ "<leader>yt", function() require("snacks").terminal("taskui") end, mode = "n", desc = "Task Warrior UI" },
		{ "<leader>yy", function() require("snacks").terminal("y") end, mode = "n", desc = "Yazi File Explorer" },
		{ "<leader>yd", function() require("snacks").terminal("lazydocker") end, mode = "n", desc = "Lazy Docker" },

		{ "<leader>fi", function() require("snacks").picker.files({ hidden = true, ignored = true, exclude = require("utils").exclude_finds }) end, mode = "n", desc = "Find git ignored & hidden files" },

		-- Buffer Management
		{ "<leader>bd", function() require("snacks").bufdelete.delete() end, desc = "Delete current buffer" },
		{ "<leader>bq", function() require("snacks").bufdelete.all() end, desc = "Delete all buffers" },
		{ "<leader>bo", function() require("snacks").bufdelete.other() end, desc = "Delete other buffers" },

		-- Top Pickers & Explorer
		{ "<leader><space>", function() require("snacks").picker.files() end, desc = "Find Files" },
		{ "<leader>,", function() require("snacks").picker.buffers() end, desc = "Buffers" },
		{ "<leader>/", function() require("snacks").picker.grep() end, desc = "Grep" },
		{ "<leader>:", function() require("snacks").picker.command_history() end, desc = "Command History" },
		{ "<leader>nh", function() require("snacks").picker.notifications() end, desc = "Notification History" },

		-- find
		{ "<leader>fb", function() require("snacks").picker.buffers() end, desc = "Buffers" },
		{ "<leader>fc", function() require("snacks").picker.files({ cwd = vim.fn.stdpath("config") }) end, desc = "Find Config File" },
		{ "<leader>ff", function() require("snacks").picker.files() end, desc = "Find Files" },
		{ "<leader>fg", function() require("snacks").picker.git_files() end, desc = "Find Git Files" },
		{ "<leader>fp", function() require("snacks").picker.projects() end, desc = "Projects" },
		{ "<leader>fr", function() require("snacks").picker.recent() end, desc = "Recent" },

		-- git
		{ "<leader>gb", function() require("snacks").picker.git_branches() end, desc = "Git Branches" },
		{ "<leader>g.", function() require("snacks").git.blame_line() end, desc = "Git blame line" },
		{ "<leader>gl", function() require("snacks").picker.git_log() end, desc = "Git Log" },
		{ "<leader>gL", function() require("snacks").picker.git_log_line() end, desc = "Git Log Line" },
		{ "<leader>gs", function() require("snacks").picker.git_status() end, desc = "Git Status" },
		{ "<leader>gS", function() require("snacks").picker.git_stash() end, desc = "Git Stash" },
		{ "<leader>gd", function() require("snacks").picker.git_diff() end, desc = "Git Diff (Hunks)" },
		{ "<leader>gf", function() require("snacks").picker.git_log_file() end, desc = "Git Log File" },

		-- gh
		{ "<leader>gi", function() require("snacks").picker.gh_issue() end, desc = "GitHub Issues (open)" },
		{ "<leader>gI", function() require("snacks").picker.gh_issue({ state = "all" }) end, desc = "GitHub Issues (all)" },
		{ "<leader>gp", function() require("snacks").picker.gh_pr() end, desc = "GitHub Pull Requests (open)" },
		{ "<leader>gP", function() require("snacks").picker.gh_pr({ state = "all" }) end, desc = "GitHub Pull Requests (all)" },

		-- Grep
		{ "<leader>sb", function() require("snacks").picker.lines() end, desc = "Buffer Lines" },
		{ "<leader>sB", function() require("snacks").picker.grep_buffers() end, desc = "Grep Open Buffers" },
		{ "<leader>sg", function() require("snacks").picker.grep() end, desc = "Grep" },
		{ "<leader>sG", function() require("snacks").picker.grep({ hidden = true, ignored = true, exclude = require("utils").exclude_finds }) end, desc = "Grep" },
		{ "<leader>sw", function() require("snacks").picker.grep_word() end, desc = "Visual selection or word", mode = { "n", "x" } },

		-- search
		{ '<leader>s"', function() require("snacks").picker.registers() end, desc = "Registers" },
		{ '<leader>s/', function() require("snacks").picker.search_history() end, desc = "Search History" },
		{ "<leader>sa", function() require("snacks").picker.autocmds() end, desc = "Autocmds" },
		{ "<leader>sc", function() require("snacks").picker.command_history() end, desc = "Command History" },
		{ "<leader>sC", function() require("snacks").picker.commands() end, desc = "Commands" },
		{ "<leader>sd", function() require("snacks").picker.diagnostics() end, desc = "Diagnostics" },
		{ "<leader>sD", function() require("snacks").picker.diagnostics_buffer() end, desc = "Buffer Diagnostics" },
		{ "<leader>sh", function() require("snacks").picker.help() end, desc = "Help Pages" },
		{ "<leader>sH", function() require("snacks").picker.highlights() end, desc = "Highlights" },
		{ "<leader>si", function() require("snacks").picker.icons() end, desc = "Icons" },
		{ "<leader>sj", function() require("snacks").picker.jumps() end, desc = "Jumps" },
		{ "<leader>sk", function() require("snacks").picker.keymaps() end, desc = "Keymaps" },
		{ "<leader>sl", function() require("snacks").picker.loclist() end, desc = "Location List" },
		{ "<leader>sm", function() require("snacks").picker.marks() end, desc = "Marks" },
		{ "<leader>sM", function() require("snacks").picker.man() end, desc = "Man Pages" },
		{ "<leader>sp", function() require("snacks").picker.projects() end, desc = "Search for Plugin Spec" },
		{ "<leader>sq", function() require("snacks").picker.qflist() end, desc = "Quickfix List" },
		{ "<leader>sR", function() require("snacks").picker.resume() end, desc = "Resume" },
		{ "<leader>su", function() require("snacks").picker.undo() end, desc = "Undo History" },
		{ "<leader>uC", function() require("snacks").picker.colorschemes() end, desc = "Colorschemes" },

		-- LSP
		{ "gd", function() require("snacks").picker.lsp_definitions() end, desc = "Goto Definition" },
		{ "gD", function() require("snacks").picker.lsp_declarations() end, desc = "Goto Declaration" },
		{ "gr", function() require("snacks").picker.lsp_references() end, nowait = true, desc = "References" },
		{ "gI", function() require("snacks").picker.lsp_implementations() end, desc = "Goto Implementation" },
		{ "gy", function() require("snacks").picker.lsp_type_definitions() end, desc = "Goto T[y]pe Definition" },
		{ "gai", function() require("snacks").picker.lsp_incoming_calls() end, desc = "C[a]lls Incoming" },
		{ "gao", function() require("snacks").picker.lsp_outgoing_calls() end, desc = "C[a]lls Outgoing" },
		{ "<leader>ss", function() require("snacks").picker.lsp_symbols() end, desc = "LSP Symbols" },
		{ "<leader>sS", function() require("snacks").picker.lsp_workspace_symbols() end, desc = "LSP Workspace Symbols" },

		-- Other
		{ "<leader>uz", function() require("snacks").zen() end, desc = "Toggle Zen Mode" },
		{ "<leader>um", function() require("snacks").zen.zoom() end, desc = "Toggle Zoom" },
		{ "<leader>.", function() require("snacks").scratch() end, desc = "Toggle Scratch Buffer" },
		{ "<leader>s.", function() require("snacks").scratch.select() end, desc = "Select Scratch Buffer" },
		{ "<leader>cR", function() require("snacks").rename.rename_file() end, desc = "Rename File" },
		{ "<leader>gB", function() require("snacks").gitbrowse() end, desc = "Git Browse", mode = { "n", "v" } },
		{ "<leader>gg", function() require("snacks").lazygit() end, desc = "Lazygit" },
		{ "<leader>un", function() require("snacks").notifier.hide() end, desc = "Dismiss All Notifications" },
		{ "<c-/>", function() toggleSnacksTerminal() end, desc = "Toggle Terminal", mode = { "n", "t", "i", "x" } },
		{ "<A-/>", function() require("snacks").terminal(nil, { env = { SNACKS_TYPE = "disposable_shell" }, win = { position = "float", border = "rounded", title = " Disposable Terminal ", title_pos = "center", width = 0.6, height = 0.6, backdrop = 60, zindex = 50 }, start_insert = true, cwd = vim.fn.getcwd() }) end, desc = "Disposal Terminal", mode = { "n", "t" } },
		{ "<c-_>", function() toggleSnacksTerminal() end, desc = "which_key_ignore", mode = { "n", "t" } },
		{ "]]", function() require("snacks").words.jump(vim.v.count1) end, desc = "Next Reference", mode = { "n", "t" } },
		{ "[[", function() require("snacks").words.jump(-vim.v.count1) end, desc = "Prev Reference", mode = { "n", "t" } },
		{ "<C-]>", "<C-\\><C-n>", desc = "Enter copy mode (terminal normal)", mode = {"t"} },
	},
	opts = {
		animate = { enabled = true },
		bigfile = { enabled = true },
		bufdelete = { enabled = true },
		dashboard = {
			enabled = true,
			preset = {
				keys = {
					{ icon = " ", key = "f", desc = "Find File", action = ":lua Snacks.picker.files()" },
					{ icon = " ", key = "n", desc = "New File", action = ":ene | startinsert" },
					{ icon = " ", key = "g", desc = "Find Text", action = ":lua Snacks.picker.grep()" },
					{ icon = " ", key = "r", desc = "Recent Files", action = ":lua Snacks.picker.recent()" },
					{ icon = "󰦛 ", key = "s", desc = "Restore Session", action = ":lua require('persistence').load()" },
					{ icon = "󰚰 ", key = "u", desc = "Update Plugins", action = ":Pack sync" },
					{ icon = " ", key = "q", desc = "Quit", action = ":qa" },
				},
			},
			sections = {
				{ section = "keys", gap = 1, padding = 1 },
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
	},
	config = function(_, opts)
		local Snacks = require("snacks")
		Snacks.setup(opts)

		-- Globals for debugging
		_G.dd = function(...)
			Snacks.debug.inspect(...)
		end
		_G.bt = function()
			Snacks.debug.backtrace()
		end

		if vim.fn.has("nvim-0.11") == 1 then
			vim._print = function(_, ...)
				dd(...)
			end
		else
			vim.print = _G.dd
		end

		-- Toggle option keymaps
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

		vim.api.nvim_create_autocmd("FileType", {
			pattern = { "snacks_picker_input" },
			callback = function(args)
				if args.buf ~= nil then
					vim.bo[args.buf].autocomplete = false
				else
					vim.opt.autocomplete = false
				end
			end,
		})

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
							vim.cmd(":Ex " .. vim.b.netrw_curdir)
						end
					end)
				end, { remap = true, buffer = true })
			end,
		})
	end,
}
