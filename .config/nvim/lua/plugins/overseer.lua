local function run_template_with_direction(direction)
	require("overseer").run_task({
		on_build = function(task_defn)
			task_defn.components = vim.tbl_filter(function(c)
				local name = type(c) == "string" and c or c[1]
				return name ~= "open_output"
			end, task_defn.components or {})
			table.insert(task_defn.components, { "open_output", direction = direction, focus = true })
		end,
	})
end

return {
	"stevearc/overseer.nvim",
	cmd = {
		"OverseerToggle",
		"OverseerOpen",
		"OverseerClose",
		"OverseerRun",
		"OverseerShell",
		"OverseerTaskAction",
	},
    --stylua: ignore
	keys = {
		{ "<leader>oo", "<cmd>OverseerToggle<cr>", desc = "Toggle Task List" },
		{ "<leader>ox", "<cmd>OverseerClose<cr>", desc = "Close Task List" },
		{ "<leader>or", "<cmd>OverseerRun<cr>", desc = "Run Task Template" },
		{ "<leader>of", function() run_template_with_direction("float") end, desc = "Run Task (Float)" },
		{ "<leader>ov", function() run_template_with_direction("vertical") end, desc = "Run Task (V-Split)" },
		{ "<leader>oh", function() run_template_with_direction("horizontal") end, desc = "Run Task (H-Split)" },
		{ "<leader>oc", "<cmd>OverseerShell<cr>", mode = { "n", "v" }, desc = "Run Command as Task" },
		{ "<leader>oq", "<cmd>OverseerTaskAction<cr>", desc = "Task Action Menu" },
		{ "<leader>ok", "<cmd>checkhealth overseer<cr>", desc = "Overseer Health" },
	},
	opts = {
		task_win = {
			padding = 2,
			border = "rounded",
		},
		task_list = {
			direction = "bottom",
			min_height = 8,
			max_height = 20,
			default_detail = 1,
			keymaps = {
				["q"] = "<cmd>close<cr>",
				["<C-c>"] = "<cmd>close<cr>",
			},
		},
		component_aliases = {
			default = {
				"on_exit_set_status",
				"on_complete_notify",
				{ "on_complete_dispose", require_view = { "SUCCESS", "FAILURE" } },
				{ "open_output", direction = "horizontal" },
			},
		},
	},
	config = function(_, opts)
		local overseer = require("overseer")
		overseer.setup(opts)

		-- Helper to enforce clean terminal windows without line numbers, winbars, or scrolloff offsets obscuring output
		local function disable_numbers(win)
			win = win or 0
			if vim.api.nvim_win_is_valid(win) then
				vim.wo[win].number = false
				vim.wo[win].relativenumber = false
				vim.wo[win].signcolumn = "no"
				vim.wo[win].foldcolumn = "0"
				vim.wo[win].statuscolumn = ""
				vim.wo[win].winbar = ""
				vim.wo[win].scrolloff = 0
				vim.wo[win].sidescrolloff = 0
				vim.wo[win].wrap = true
			end
		end

		-- Prevent duplicate splits on task restarts / file save watch triggers by reusing existing windows
		local Task = require("overseer.task")
		local orig_open_output = Task.open_output
		Task.open_output = function(self, direction)
			local bufnr = self:get_bufnr()
			if not bufnr or not vim.api.nvim_buf_is_valid(bufnr) then
				return
			end

			-- 1. If this task's buffer is already visible in an open window, reuse it
			local existing_win = vim.fn.bufwinid(bufnr)
			if existing_win ~= -1 and vim.api.nvim_win_is_valid(existing_win) then
				disable_numbers(existing_win)
				require("overseer.util").scroll_to_end(existing_win)
				return existing_win
			end

			-- 2. If an Overseer output window is already open in the current tabpage, swap its buffer
			for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
				local winbuf = vim.api.nvim_win_get_buf(win)
				local buftype = vim.bo[winbuf].buftype
				local filetype = vim.bo[winbuf].filetype
				local bufname = vim.api.nvim_buf_get_name(winbuf)
				if (buftype == "terminal" and bufname:find("overseer")) or filetype == "OverseerOutput" then
					vim.api.nvim_win_set_buf(win, bufnr)
					disable_numbers(win)
					require("overseer.util").set_term_window_opts(win)
					require("overseer.util").scroll_to_end(win)
					disable_numbers(win)
					return win
				end
			end

			-- 3. Otherwise, create a new window split/float as requested
			local res_win = orig_open_output(self, direction)
			if res_win then
				disable_numbers(res_win)
			end
			return res_win
		end

		-- FileType autocmd for Overseer Task List & Output buffers
		vim.api.nvim_create_autocmd("FileType", {
			pattern = { "OverseerList", "OverseerOutput" },
			callback = function(args)
				disable_numbers(0)
				vim.keymap.set("n", "q", "<cmd>close<cr>", { buffer = args.buf, silent = true })
				vim.keymap.set("n", "<C-c>", "<cmd>close<cr>", { buffer = args.buf, silent = true })
			end,
		})

		-- Ensure number / relativenumber / scrolloff stay disabled when entering Overseer terminal windows
		vim.api.nvim_create_autocmd({ "BufEnter", "WinEnter", "TermOpen" }, {
			pattern = "*",
			callback = function(args)
				local buf = args.buf
				if vim.api.nvim_buf_is_valid(buf) then
					local buftype = vim.bo[buf].buftype
					local filetype = vim.bo[buf].filetype
					local bufname = vim.api.nvim_buf_get_name(buf)
					if
						buftype == "terminal"
						or filetype == "OverseerOutput"
						or filetype == "OverseerList"
						or bufname:find("overseer")
					then
						disable_numbers(0)
					end
				end
			end,
		})

		-- Automatically exit terminal mode when terminal job process exits
		vim.api.nvim_create_autocmd("TermClose", {
			callback = function(args)
				vim.schedule(function()
					if vim.api.nvim_buf_is_valid(args.buf) then
						vim.cmd("stopinsert")
					end
				end)
			end,
		})

		-- Helper function to attach smooth navigation keymaps to terminal buffers
		local function setup_term_buffer_keymaps(buf)
			if not buf or not vim.api.nvim_buf_is_valid(buf) then
				return
			end
			local bopts = { buffer = buf, silent = true }

			-- Single or double Esc immediately exits terminal mode to normal mode
			vim.keymap.set("t", "<Esc>", [[<C-\><C-n>]], bopts)
			vim.keymap.set("t", "<Esc><Esc>", [[<C-\><C-n>]], bopts)

			-- Direct window navigation straight out of terminal mode
			vim.keymap.set("t", "<C-h>", [[<C-\><C-n><C-w>h]], bopts)
			vim.keymap.set("t", "<C-j>", [[<C-\><C-n><C-w>j]], bopts)
			vim.keymap.set("t", "<C-k>", [[<C-\><C-n><C-w>k]], bopts)
			vim.keymap.set("t", "<C-l>", [[<C-\><C-n><C-w>l]], bopts)
			vim.keymap.set("t", "<C-q>", [[<C-\><C-n><cmd>close<cr>]], bopts)

			-- Quick close in normal mode ('q' and <C-c>)
			vim.keymap.set("n", "<C-c>", "<cmd>close<cr>", bopts)
			vim.keymap.set("n", "q", "<cmd>close<cr>", bopts)
		end

		-- TermOpen autocmd for all terminal buffers created by Overseer
		vim.api.nvim_create_autocmd("TermOpen", {
			callback = function(args)
				disable_numbers(0)
				setup_term_buffer_keymaps(args.buf)
			end,
		})

		-- Attach navigation & close keymaps to task output terminal buffers when started
		local orig_start = Task.start
		Task.start = function(self, ...)
			orig_start(self, ...)
			local buf = self:get_bufnr()
			setup_term_buffer_keymaps(buf)

			-- When a task starts or restarts, schedule window update & reset cursor to display fresh output without scrolloff padding
			if buf and vim.api.nvim_buf_is_valid(buf) then
				vim.schedule(function()
					for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
						local winbuf = vim.api.nvim_win_get_buf(win)
						local buftype = vim.bo[winbuf].buftype
						local filetype = vim.bo[winbuf].filetype
						local bufname = vim.api.nvim_buf_get_name(winbuf)
						if
							filetype == "OverseerOutput"
							or (buftype == "terminal" and bufname:find("overseer"))
							or winbuf == buf
						then
							if vim.api.nvim_win_is_valid(win) then
								vim.api.nvim_win_set_buf(win, buf)
								disable_numbers(win)
								require("overseer.util").set_term_window_opts(win)
								pcall(vim.api.nvim_win_set_cursor, win, { 1, 0 })
								require("overseer.util").scroll_to_end(win)
								disable_numbers(win)
							end
						end
					end
				end)
			end
		end
	end,
}
