vim.pack.add({
	{ src = "https://github.com/ibhagwan/fzf-lua", name = "fzf-lua" },
})

local utils = require("utils")

-- stylua: ignore
-- Define keymaps that will trigger loading of fzf-lua
local fzf_keys = {
	-- Core & Quick Access
	{ "<leader><space>", function() require("fzf-lua").files() end, desc = "Find Files (Root)" },
	{ "<leader>,", function() require("fzf-lua").buffers() end, desc = "Switch Buffers" },
	{ "<leader>/", function() require("fzf-lua").live_grep() end, desc = "Live Grep (Root)" },
	{ "<leader>:", function() require("fzf-lua").command_history() end, desc = "Command History" },
	{ "<leader>ff", function() require("fzf-lua").files() end, desc = "Find Files" },
	{ "<leader>fr", function() require("fzf-lua").oldfiles() end, desc = "Recent Files" },
	{ "<leader>fc", function() require("fzf-lua").files({ cwd = vim.fn.stdpath("config") }) end, desc = "Find Config Files" },
	{ "<leader>fa", function() require("fzf-lua").args() end, desc = "Find Arguments" },
	{ "<leader>fz", function() require("fzf-lua").zoxide() end, desc = "Zoxide" },
	{ "<leader>fB", function() require("fzf-lua").builtin() end, desc = "Fzf Builtin Commands" },

	-- Hidden & Ignored Files
	{ "<leader>fH", function() require("fzf-lua").files({ fd_opts = "--type f --hidden --exclude .git" }) end, desc = "Find Hidden Files" },
	{ "<leader>fI", function() require("fzf-lua").files({ fd_opts = "--type f --no-ignore --hidden --exclude .git" }) end, desc = "Find All Files (Incl. Ignored)" },

	-- Search & Content
	{ "<leader>sg", function() require("fzf-lua").live_grep() end, desc = "Search Grep" },
	{ "<leader>sw", function() require("fzf-lua").grep_cword() end, desc = "Search Word under cursor" },
	{ "<leader>sw", function() require("fzf-lua").grep_visual() end, mode = "v", desc = "Search Visual selection" },
	{ "<leader>sb", function() require("fzf-lua").lgrep_curbuf() end, desc = "Search (Grep) Current Buffer" },
	{ "<leader>sB", function() require("fzf-lua").blines() end, desc = "Search Lines (Current Buffer)" },
	{ "<leader>sl", function() require("fzf-lua").lines() end, desc = "Search Lines (All Buffers)" },
	{ "<leader>st", function() require("fzf-lua").treesitter() end, desc = "Search Treesitter Symbols" },
	{ "<leader>sT", function() require("fzf-lua").tags() end, desc = "Search Project Tags" },
	{ "<leader>bt", function() require("fzf-lua").btags() end, desc = "Search Buffer Tags" },
	{ "<leader>s.", function() require("fzf-lua").resume() end, desc = "Resume Last Search" },
	{ "<leader>su", function() require("fzf-lua").undotree() end, desc = "Search Undo History" },

	-- Neovim Internals
	{ "<leader>sh", function() require("fzf-lua").help_tags() end, desc = "Search Help" },
	{ "<leader>sk", function() require("fzf-lua").keymaps() end, desc = "Search Keymaps" },
	{ "<leader>sj", function() require("fzf-lua").jumps() end, desc = "Search Jump List" },
	{ "<leader>sq", function() require("fzf-lua").quickfix() end, desc = "Search Quickfix List" },
	{ "<leader>sm", function() require("fzf-lua").marks() end, desc = "Search Marks" },
	{ "<leader>sR", function() require("fzf-lua").registers() end, desc = "Search Registers" },
	{ "<leader>sp", function() require("fzf-lua").spell_suggest() end, desc = "Search Spelling Suggestions" },

	-- Git Integration
	{ "<leader>gs", function() require("fzf-lua").git_status() end, desc = "Git Status" },
	{ "<leader>gb", function() require("fzf-lua").git_branches() end, desc = "Git Branches" },
	{ "<leader>gc", function() require("fzf-lua").git_commits() end, desc = "Git Commits" },
	{ "<leader>gC", function() require("fzf-lua").git_bcommits() end, desc = "Git Buffer Commits" },
	{ "<leader>gS", function() require("fzf-lua").git_stash() end, desc = "Git Stash" },
	{ "<leader>gd", function() require("fzf-lua").git_diff() end, desc = "Git Diff" },
	{ "<leader>gh", function() require("fzf-lua").git_hunks() end, desc = "Git Hunks" },
	{ "<leader>gB", function() require("fzf-lua").git_blame() end, desc = "Git Blame" },
	{ "<leader>gw", function() require("fzf-lua").git_worktrees() end, desc = "Git Worktrees" },

	-- LSP Integration
	{ "gd", function() require("fzf-lua").lsp_definitions() end, desc = "Goto Definition" },
	{ "gD", function() require("fzf-lua").lsp_declarations() end, desc = "Goto Declaration" },
	{ "gr", function() require("fzf-lua").lsp_references() end, desc = "Goto References" },
	{ "gI", function() require("fzf-lua").lsp_implementations() end, desc = "Goto Implementation" },
	{ "gy", function() require("fzf-lua").lsp_typedefs() end, desc = "Goto Type Definition" },
	{ "<leader>ca", function() require("fzf-lua").lsp_code_actions() end, desc = "LSP Code Action" },
	{ "<leader>ci", function() require("fzf-lua").lsp_incoming_calls() end, desc = "LSP Incoming Calls" },
	{ "<leader>co", function() require("fzf-lua").lsp_outgoing_calls() end, desc = "LSP Outgoing Calls" },
	{ "<leader>ss", function() require("fzf-lua").lsp_document_symbols() end, desc = "Search Document Symbols" },
	{ "<leader>sS", function() require("fzf-lua").lsp_live_workspace_symbols() end, desc = "Search Workspace Symbols" },
	{ "<leader>sd", function() require("fzf-lua").diagnostics_document() end, desc = "Search Document Diagnostics" },
	{ "<leader>sD", function() require("fzf-lua").diagnostics_workspace() end, desc = "Search Workspace Diagnostics" },
	{ "<leader>sf", function() require("fzf-lua").lsp_finder() end, desc = "LSP Finder (Combined View)" },

	-- UI
	{ "<leader>uC", function() require("fzf-lua").colorschemes() end, desc = "Search Colorschemes" },
}

utils.map_plugin_keys(fzf_keys)

-- Initialize fzf-lua directly to ensure it works from start
require("fzf-lua").setup({
	files = {
		cwd_prompt = false,
	},
})
