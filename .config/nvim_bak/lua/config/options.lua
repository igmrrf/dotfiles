local opt = vim.opt
vim.opt.shortmess:remove("I")

opt.winborder = "rounded"
opt.scrolloff = 8
opt.sidescrolloff = 8

opt.number = true
opt.relativenumber = true

opt.cursorline = true
opt.wrap = false

opt.tabstop = 2
opt.shiftwidth = 2
opt.softtabstop = 2
opt.expandtab = true
opt.smartindent = true
opt.autoindent = true

opt.clipboard:append("unnamedplus")

-- Search Settings
opt.smartcase = true -- Don't ignore case with capitals
opt.ignorecase = true -- Ignore case
opt.hlsearch = true -- Don't highlight search results
opt.incsearch = true -- Show matches as you type

-- Visual Settings
opt.termguicolors = true -- Enable 24bit color support
opt.signcolumn = "yes" -- Always show the signcolumn, otherwise it would shift the text each time
-- opt.colorcolumn = "100" -- Show column at 100 characters
opt.showmatch = true -- Highlight matching brackets
opt.matchtime = 2 -- How long to show matching bracket
opt.cmdheight = 0 -- Command line height
opt.completeopt = "menu,menuone,noselect"
opt.showmode = false -- Dont show mode since we have a statuslinef/in command line
opt.pumblend = 10 -- Popup transparency
opt.pumheight = 10 -- Maximum number of entries in a popup
opt.conceallevel = 2 -- 0(Not hide) Hide * markup for bold and italic, but not markers with substitutions
opt.winblend = 0 -- Floating window transparency
opt.concealcursor = "" -- Don't hide cursor line markup
-- opt.lazyredraw = true    -- Don't redraw during macros
opt.synmaxcol = 300 -- Syntax highlighting limit

-- File Handling
opt.backup = false -- Don't create backup files
opt.writebackup = false -- Don't create backup files before writing
opt.swapfile = false -- Don't create swapfiles
opt.undofile = true -- Persistent undo
opt.undodir = vim.fn.expand("~/.vim/undodir") -- Undo directory
opt.updatetime = 200 -- Faster completion
opt.timeoutlen = vim.g.vscode and 1000 or 300 -- Lower than default (1000) to quickly trigger which-key
opt.undolevels = 10000
opt.ttimeoutlen = 0 -- Key code timeout
opt.autoread = true -- Auto reload files changed outside vim
opt.autowrite = false -- Don't auto save

-- Behavior Settings
opt.hidden = true -- Allow hidden buffers
opt.errorbells = false -- No error bells
opt.backspace = "indent,eol,start" -- Better backspace behavior
opt.autochdir = false -- Don't autochange dir
opt.iskeyword:append("-") -- Treat dash as part of word
opt.path:append("**") -- include subdirectories in search
-- opt.selection = "exclusive" -- Exclusive selction
opt.mouse = "a" -- Enable mouse mode
opt.clipboard:append("unnamedplus") -- Sync with system clipboard
opt.modifiable = true -- Allow buffer modifications
opt.encoding = "UTF-8" -- set encoding

-- Cursor Settings
-- opt.guicursor =
-- "n-v-c-ve:block,i-ci:ver25,r-cr:hor20,o:hor50,a:blinkwait700-blinkoff400-blinkon250-Cursor/lCursor,sm:block-blinkwait175-blinkoff150-blinkon175"

-- Split behavior
opt.splitbelow = true -- Put new windows below current
opt.splitright = true -- Put new windows right of current

-- Command-line completion
opt.wildmenu = true
opt.wildmode = "longest:full,full"
opt.wildignore:append({ "*.o", "*.obj", "*.pyc", "*.class", "*.jar" })

-- Better diff options
opt.diffopt:append("linematch:60")

-- Performance improvements
opt.redrawtime = 10000
opt.maxmempattern = 20000

-- Set these once globally
vim.o.foldmethod = "expr"
vim.o.foldexpr = "v:lua.vim.treesitter.foldexpr()"
vim.o.foldlevelstart = 99
vim.o.foldlevel = 20

opt.background = "dark"
opt.confirm = true -- Confirm to save changes before exiting modified buffer
opt.fillchars = {
	foldopen = "",
	foldclose = "",
	fold = " ",
	foldsep = " ",
	diff = "╱",
	eob = " ",
}

opt.formatoptions = "jcroqlnt" -- tcqj
opt.grepformat = "%f:%l:%c:%m"
opt.grepprg = "rg --vimgrep"
opt.inccommand = "nosplit" -- preview incremental substitute
opt.jumpoptions = "view"
opt.laststatus = 3 -- global statusline
opt.linebreak = true -- Wrap lines at convenient points
opt.ruler = false -- Disable the default ruler
opt.list = true -- Show some invisible characters (tabs...
opt.sessionoptions = { "buffers", "curdir", "tabpages", "winsize", "help", "globals", "skiprtp", "folds" }
opt.shiftround = true -- Round indent
opt.shortmess:append({ W = true, I = true, c = true, C = true })
opt.spelllang = { "en" }
opt.splitkeep = "screen"
opt.virtualedit = "block" -- Allow cursor to move where there is no text in visual block mode
opt.wildmode = "longest:full,full" -- Command-line completion mode
opt.winminwidth = 5 -- Minimum window width
