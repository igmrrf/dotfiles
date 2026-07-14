vim.pack.add({ src = "https://github.com/xdagiz/jjui.nvim" })

-- stylua: ignore
local keys = {
    { "<leader>jj",  function() require("jjui").open() end,            mode = { "n" }, desc = "Open jjui", },
    { "<leader>jt",  function() require("jjui").toggle() end,          mode = { "n" }, desc = "Toggle jjui", },
}

require("utils").map_plugin_keys(keys)
