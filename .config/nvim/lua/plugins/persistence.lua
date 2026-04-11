vim.pack.add({
    { src = "https://github.com/folke/persistence.nvim", name = "persistence" }
})

local utils = require("utils")

local keys = {
    { "<leader>qs", function() require("persistence").load() end,                desc = "Restore Session" },
    { "<leader>qS", function() require("persistence").select() end,              desc = "Select Session" },
    { "<leader>ql", function() require("persistence").load({ last = true }) end, desc = "Restore Last Session" },
    { "<leader>qd", function() require("persistence").stop() end,                desc = "Don't Save Current Session" },
}

utils.map_plugin_keys(keys)

utils.lazy_load_event("persistence", { "BufReadPre" }, function()
    require("persistence").setup({})
end)
