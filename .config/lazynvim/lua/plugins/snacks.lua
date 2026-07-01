vim.keymap.set("n", "<leader>yc", function()
  Snacks.terminal("claude")
end, { desc = "spin up claude terminal" })

vim.keymap.set("n", "<leader>yd", function()
  Snacks.terminal("lazydocker")
end, { desc = "spin up lazy docker" })
return {
  "folke/snacks.nvim",
  opts = {
    terminal = {
      win = {
        position = "float",
        border = "rounded",
      },
    },
  },
}
