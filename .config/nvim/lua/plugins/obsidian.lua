vim.pack.add({
    "https://github.com/nvim-lua/plenary.nvim",
    { src = "https://github.com/epwalsh/obsidian.nvim", name = "obsidian" }
})

require("utils").lazy_load_ft("obsidian", "markdown", function()
    require("obsidian").setup({
        workspaces = {
            {
                name = "personal",
                path = "~/tldo",
            },
        },
    })
end)
