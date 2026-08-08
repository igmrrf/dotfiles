return {
	"stevearc/oil.nvim",
	cmd = "Oil",
	keys = {
		{ "<leader>e", "<cmd>Oil --float --preview<cr>", desc = "Open parent directory with Oil" },
	},
	opts = {
		default_file_explorer = false,
		keymaps = {
			["z"] = { "actions.parent", mode = "n" },
			["<leader>e"] = { "actions.close", mode = "n" },
		},
		skip_confirm_for_simple_edits = true,
		delete_to_trash = true,
		watch_for_changes = true,

		float = {
			padding = 2,
			max_width = 0.8,
			max_height = 0.8,
		},
		view_options = {
			show_hidden = true,
			is_always_hidden = function(name, bufnr)
				return name:match("^%.env.*$")
			end,
		},
	},
}
