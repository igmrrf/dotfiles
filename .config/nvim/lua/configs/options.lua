local opt = vim.opt

vim.o.winborder = "rounded"
-- stylua: ignore

opt.winborder = "rounded" -- set popup windows border
opt.laststatus = 3
opt.showmode = false
opt.termguicolors = true
opt.signcolumn = "yes"
opt.updatetime = 200
opt.timeoutlen = 400
opt.shiftround = true
opt.wrap = false
opt.spell = false
opt.cmdheight = 0
opt.virtualedit = "block"
opt.sessionoptions = { "buffers", "curdir", "help", "tabpages", "winsize", "globals", "skiprtp" }

-- Autocomplete Settings
opt.autocomplete = false -- let blink.cmp handle completion
opt.pumborder = "rounded" -- set suggestion window
opt.pummaxwidth = 120 -- set max widown width
opt.pumheight = 10 -- set height
opt.completeopt = "menu,menuone,noselect" -- set complete options
opt.complete = ".,w^5,b^5,u^3,t^3,o"

opt.wildoptions = "pum,fuzzy"
opt.wildmode = "longest:full,full"
--
-- Number settings
opt.number = true
opt.relativenumber = true
opt.cursorline = true
-- Scroll Settings
opt.scrolloff = 8
opt.sidescrolloff = 8

-- Indent Settings
opt.tabstop = 2
opt.shiftwidth = 2
opt.softtabstop = 2
opt.smartindent = true
opt.expandtab = true
opt.autoindent = true

-- Search settings
opt.smartcase = true
opt.ignorecase = true
opt.hlsearch = true -- highlight matches found
opt.incsearch = true -- highlight matches as you type

-- File Handling
opt.backup = false
opt.writebackup = false
opt.swapfile = false
opt.undofile = true
opt.confirm = true -- confirm to save changes before existing buffer
opt.shortmess:append("WcI")
opt.report = 9999

-- Split Behavior
opt.splitbelow = true
opt.splitright = true

-- opt.list           = true           -- show some invisible characters

-- Performance
opt.redrawtime = 10000
opt.maxmempattern = 20000
opt.iskeyword:append("-") -- Treat dash as part of word
opt.clipboard:append("unnamedplus") -- include system clipboard

-- Set these once globally
vim.o.foldlevelstart = 99
vim.o.foldlevel = 20

-- opt.background = "dark"
-- Floating window / popup-menu transparency
-- opt.winblend = 10
-- opt.pumblend = 10

opt.fillchars = {
	foldopen = "",
	foldclose = "",
	fold = " ",
	foldsep = " ",
	diff = "╱",
	eob = " ",
}
