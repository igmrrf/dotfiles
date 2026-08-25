return{
-- Functionality: Provides Ctags integration for Neovim to jump to definitions and references.
-- Testing: First, install `ctags` on your system. Change `enabled` to `true` in this file. Open a project and run `:Ctags` to generate a tags file, then use `<C-]>` on a symbol to jump to its definition.
"https://github.com/wsdjeg/ctags.nvim",
enabled = false,
dependencies = {
    "wsdjeg/job.nvim",
},
keys = {
    { "<leader>cT", "<cmd>Ctags<cr>", desc = "Generate Ctags" },
},
}
