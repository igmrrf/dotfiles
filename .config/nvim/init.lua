local site_path = vim.fn.stdpath("data") .. "/site"
vim.opt.packpath:prepend(site_path)

require("configs")
require("plugins")
