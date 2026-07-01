-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
--
local map = vim.keymap.set

map("i", "jk", "<ESC>")
map("n", "d", '"_d')
map("n", "x", '"_x')
map("n", "dd", '"_dd')

map("n", "<leader>cp", function()
  local path = vim.fn.expand("%:p:.")
  vim.fn.setreg("+", path)
end, { desc = "Copy file path" })
map("n", "<leader>cP", function()
  local path = vim.fn.expand("%:p")
  vim.fn.setreg("+", path)
end, { desc = "Copy file full path" })
map("t", "<C-]>", "<C-\\><C-n>", { desc = "Enter copy mode" })
