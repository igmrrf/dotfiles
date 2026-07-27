return {
	"oysandvik94/curl.nvim",
	name = "curl.nvim",
	dependencies = { "nvim-lua/plenary.nvim" },
	cmd = {
		"CurlOpen",
		"CurlOpenGlobal",
		"CurlCreateScopedCollection",
		"CurlCreateGlobalCollection",
		"CurlPickScopedCollection",
		"CurlPickGlobalCollection",
	},
	keys = {
		{
			"<leader>Rc",
			function()
				require("curl").open_curl_tab()
			end,
			mode = { "n" },
			desc = "Open a curl tab scoped to the current working directory",
		},
		{
			"<leader>RC",
			function()
				require("curl").open_global_tab()
			end,
			mode = { "n" },
			desc = "Open a curl tab with global scope",
		},
		{
			"<leader>Rsc",
			function()
				require("curl").create_scoped_collection()
			end,
			mode = { "n" },
			desc = "Create or open a collection with a name from user input",
		},
		{
			"<leader>RsC",
			function()
				require("curl").create_global_collection()
			end,
			mode = { "n" },
			desc = "Create or open a global collection with a name from user input",
		},
		{
			"<leader>Rpc",
			function()
				require("curl").pick_scoped_collection()
			end,
			mode = { "n" },
			desc = "Choose a scoped collection and open it",
		},
		{
			"<leader>RpC",
			function()
				require("curl").pick_global_collection()
			end,
			mode = { "n" },
			desc = "Choose a global collection and open it",
		},
	},
	opts = {},
}
