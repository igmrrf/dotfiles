vim.pack.add({
    { src = "https://github.com/laytan/cloak.nvim", name = "cloak.nvim" }
})

local utils = require("utils")

local keys = {
    { "<leader>cK", "<cmd>CloakToggle<cr>",      mode = { "n" }, desc = "Toggle Cloak", },
    { "<leader>ck", "<cmd>CloakPreviewLine<cr>", mode = { "n" }, desc = "Enable Cloak Preview", }
}

utils.map_plugin_keys(keys)

utils.lazy_load_event("cloak.nvim", { "BufReadPre", "BufNewFile" }, function()
    require("cloak").setup({})
end)
