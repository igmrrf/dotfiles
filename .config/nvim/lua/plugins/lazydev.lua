vim.pack.add({
    { src = "https://github.com/folke/lazydev.nvim", name = "lazydev" }
})

require("utils").lazy_load_ft("lazydev", "lua", function()
    require("lazydev").setup({
        library = {
            { path = "${3rd}/luv/library", words = { "vim%.uv" } },
        },
        integrations = {
            lspconfig = true,
            cmp = true,
        }
    })
end)
