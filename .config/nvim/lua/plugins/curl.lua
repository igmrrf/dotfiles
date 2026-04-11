vim.pack.add({
	"https://github.com/nvim-lua/plenary.nvim",
	{ src = "https://github.com/oysandvik94/curl.nvim", name = "curl.nvim" },
})

vim.api.nvim_create_user_command("CurlOpen", function(opts)
	vim.cmd("packadd curl.nvim")
	if not package.loaded["curl.nvim"] then
		require("curl.nvim").setup({}) -- This emulates `config = true`
	end
	vim.api.nvim_del_user_command("CurlOpen")
	vim.cmd("CurlOpen " .. opts.args)
end, { nargs = "*", bang = true })

-- stylua: ignore
local keys = {
    { "<leader>Rc",  function() require("curl").open_curl_tab() end,            mode = { "n" }, desc = "Open a curl tab scoped to the current working directory", },
    { "<leader>RC",  function() require("curl").open_global_tab() end,          mode = { "n" }, desc = "Open a curl tab with global scope", },
    { "<leader>Rsc", function() require("curl").create_scoped_collection() end, mode = { "n" }, desc = "Create or open a collection with a name from user input", },
    { "<leader>RsC", function() require("curl").create_global_collection() end, mode = { "n" }, desc = "Create or open a global collection with a name from user input", },
    { "<leader>Rpc", function() require("curl").pick_scoped_collection() end,   mode = { "n" }, desc = "Choose a scoped collection and open it", },
    { "<leader>RpC", function() require("curl").pick_global_collection() end,   mode = { "n" }, desc = "Choose a global collection and open it", },
}

-- require("curl.nvim").setup({})
require("utils").map_plugin_keys(keys)
