return {
	"igmrrf/dbee.nvim",
	dependencies = {
		"MunifTanjim/nui.nvim",
	},
	keys = {
		{
			"<leader>De",
			function()
				require("dbee").toggle()
			end,
			desc = "Toggle DBee UI",
		},
		{
			"<leader>DE",
			function()
				require("dbee").open()
			end,
			desc = "Open DBee UI",
		},
	},
	build = function()
		-- Install tries to automatically detect the install method.
		-- if it fails, try calling it with one of these parameters:
		--    "curl", "wget", "bitsadmin", "go"
		require("dbee").install()
	end,
	config = function()
		require("dbee").setup({
			window_layout = require("dbee.layouts").Default:new({
				on_switch = "close",
			}),
		})
	end,
}
