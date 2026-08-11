local map = function(mode, keys, cmd, opt)
	local opts = vim.tbl_deep_extend("force", { silent = true }, opt or {})
	vim.keymap.set(mode, keys, cmd, opts)
end

map("n", "<leader>xs", ":update<CR> :source $MYVIMRC<CR>", { desc = "Source" })
map("n", "<leader>xx", ":restart<CR>", { desc = "Restart neovim" })

-- File
map("n", "<leader>%", ":enew<CR>", { desc = "Create new file" })
map("n", "<leader>cp", function()
	local path = vim.fn.expand("%:p:.")
	vim.fn.setreg("+", path)
end, { desc = "Copy file path" })
map("n", "<leader>cP", function()
	local path = vim.fn.expand("%:p")
	vim.fn.setreg("+", path)
end, { desc = "Copy file full path" })

-- Deleting
map("n", "d", '"_d')
map("n", "x", '"_x')
map("n", "dd", '"_dd')

-- Pasting
map("n", "p", "]p")
map("n", "P", "[p")

-- Save & Quit
map("i", "jk", "<ESC>", { desc = "Exit insert mode" })
map("n", "<leader>w", ":silent w<CR>", { desc = "Save file" })
map("n", "<leader>wa", ":silent wa<CR>", { desc = "Save all files" })
map("n", "<leader>qq", ":silent qa<CR>", { desc = "Quit all" })
map("n", "<leader>wq", ":silent wqa<CR>", { desc = "Save & quit all" })
map("n", "<leader>W", ":silent wall ++p<CR>", { desc = "Save & create missing parent directories " })

-- clear search, diff update and redraw
map(
	"n",
	"<leader>ur",
	":nohlsearch<Bar>diffupdate<Bar>normal! <C-L><CR>",
	{ desc = "Redraw / Clear hlsearch / Diff Update" }
)
-- Editing
map("i", "<C-l>", "<Esc>la", { desc = "Move to the right one char", noremap = true })

-- Better indenting
map("v", "<", "<gv")
map("v", ">", ">gv")

-- stylua: ignore
map( "n", "gco", "o<ESC>Vcx<ESC><CMD>normal gcc<CR>fxa<BS>", { desc = "Add comment below", noremap = true, })
-- stylua: ignore
map( "n", "gcO", "O<ESC>Vcx<ESC><CMD>normal gcc<CR>fxa<BS>", { desc = "Add comment above", noremap = true, })

-- Window
map("n", "<leader>-", "<C-w>s", { desc = "Split window below", remap = true })
map("n", "<leader>|", "<C-w>v", { desc = "Split window right", remap = true })
map("n", "<leader>wd", "<C-w>c", { desc = "Delete current window", remap = true })

map("n", "<leader>wh", "<C-w>H", { desc = "Go to left window", remap = true })
map("n", "<leader>wl", "<C-w>L", { desc = "Go to right window", remap = true })
map("n", "<leader>wj", "<C-w>J", { desc = "Go to lower window", remap = true })
map("n", "<leader>wk", "<C-w>K", { desc = "Go to upper window", remap = true })

map("n", "<C-h>", "<C-w>h", { desc = "Go to left window", remap = true })
map("n", "<C-l>", "<C-w>l", { desc = "Go to right window", remap = true })
map("n", "<C-j>", "<C-w>j", { desc = "Go to lower window", remap = true })
map("n", "<C-k>", "<C-w>k", { desc = "Go to upper window", remap = true })

-- Move lines
map("n", "<A-j>", "<cmd>execute 'move .+' . v:count1<cr>==", { desc = "Move Down" })
map("n", "<A-k>", "<cmd>execute 'move .-' . (v:count1 + 1)<cr>==", { desc = "Move Up" })
map("i", "<A-j>", "<esc><cmd>m .+1<cr>==gi", { desc = "Move Down" })
map("i", "<A-k>", "<esc><cmd>m .-2<cr>==gi", { desc = "Move Up" })
map("v", "<A-j>", ":<C-u>execute \"'<,'>move '>+\" . v:count1<cr>gv=gv", { desc = "Move Down" })
map("v", "<A-k>", ":<C-u>execute \"'<,'>move '<-\" . (v:count1 + 1)<cr>gv=gv", { desc = "Move Up" })

-- better up/down
map({ "n", "x" }, "j", "v:count == 0 ? 'gj' : 'j'", { desc = "Down", expr = true })
map({ "n", "x" }, "<Down>", "v:count == 0 ? 'gj' : 'j'", { desc = "Down", expr = true })
map({ "n", "x" }, "k", "v:count == 0 ? 'gk' : 'k'", { desc = "Up", expr = true })
map({ "n", "x" }, "<Up>", "v:count == 0 ? 'gk' : 'k'", { desc = "Up", expr = true })

-- Format
map("n", "<leader>uF", "<cmd>ToggleFormat<cr>", { desc = "Toggle global format-on-save" })
map("n", "<leader>uf", "<cmd>ToggleBuffFormat<cr>", { desc = "Toggle format-on-save for buffer" })

-- Health
map("n", "<leader>hp", "<cmd>checkhealth pack<cr>", { desc = "Checkhealth vim.pack" })
map("n", "<leader>hl", "<cmd>checkhealth vim.lsp<cr>", { desc = "Checkhealth vim.lsp" })
map("n", "<leader>hx", "<cmd>checkhealth vim.deprecated<cr>", { desc = "Checkhealth vim.deprecated" })
map("n", "<leader>hh", "<cmd>checkhealth vim.health<cr>", { desc = "Checkhealth vim.health" })
map("n", "<leader>ht", "<cmd>checkhealth vim.treesitter<cr>", { desc = "Checkhealth vim.treesitter" })
map("n", "<leader>hv", "<cmd>checkhealth vim.provider<cr>", { desc = "Checkhealth vim.provider" })
map("n", "<leader>hn", "<cmd>checkhealth nvim-treesitter<cr>", { desc = "Checkhealth nvim-treesitter" })
map("n", "<leader>hs", "<cmd>checkhealth snacks<cr>", { desc = "Checkhealth snacks" })
map("n", "<leader>hd", "<cmd>checkhealth dap<cr>", { desc = "Checkhealth dap" })

-- Buffer
map("n", "<S-h>", "<cmd>bprevious<cr>", { desc = "Prev Buffer" })
map("n", "<S-l>", "<cmd>bnext<cr>", { desc = "Next Buffer" })
map("n", "[b", "<cmd>bprevious<cr>", { desc = "Prev Buffer" })
map("n", "]b", "<cmd>bnext<cr>", { desc = "Next Buffer" })
map("n", "<leader>k", vim.lsp.buf.signature_help, { desc = "Signature help" })

-- using ? reverses n/N in comparison to /
map("n", "n", "'Nn'[v:searchforward].'zv'", { expr = true, desc = "Next Search Result" })
map("x", "n", "'Nn'[v:searchforward]", { expr = true, desc = "Next Search Result" })
map("o", "n", "'Nn'[v:searchforward]", { expr = true, desc = "Next Search Result" })
map("n", "N", "'nN'[v:searchforward].'zv'", { expr = true, desc = "Prev Search Result" })
map("x", "N", "'nN'[v:searchforward]", { expr = true, desc = "Prev Search Result" })
map("o", "N", "'nN'[v:searchforward]", { expr = true, desc = "Prev Search Result" })

-- Tabs
map("n", "<leader><tab>l", "<cmd>tablast<cr>", { desc = "Last Tab" })
map("n", "<leader><tab>f", "<cmd>tabfirst<cr>", { desc = "First Tab" })
map("n", "<leader><tab>o", "<cmd>tabonly<cr>", { desc = "Close Other Tabs" })
map("n", "<leader><tab>d", "<cmd>tabclose<cr>", { desc = "Close Tab" })
map("n", "<leader><tab><tab>", "<cmd>tabnew<cr>", { desc = "New Tab" })
map("n", "<leader><tab>]", "<cmd>tabnext<cr>", { desc = "Next Tab" })
map("n", "<leader><tab>[", "<cmd>tabprevious<cr>", { desc = "Previous Tab" })
map("n", "]<tab>", "<cmd>tabnext<cr>", { desc = "Next Tab" })
map("n", "[<tab>", "<cmd>tabprevious<cr>", { desc = "Previous Tab" })

map("n", "<leader><tab>>", ":tabmove +1<CR>", { desc = "Move tab right" })
map("n", "<leader><tab><", ":tabmove -1<CR>", { desc = "Move tab left" })

-- Manage Packs
map("n", "<leader>pu", function()
	vim.pack.update()
end, { desc = "Pack update" })

map("n", "<leader>pb", ":'[,']t']<CR>", { desc = "Paste block below" })
map("n", "<leader>pt", ":'[,']t'[-1<CR>", { desc = "Paste block above" })

-- LSP
map("n", "<leader>cr", vim.lsp.buf.rename, { desc = "LSP Rename" })

-- Terminal Navigation
vim.api.nvim_create_autocmd("TermOpen", {
	group = vim.api.nvim_create_augroup("igmrrf_term_nav", { clear = true }),
	callback = function(event)
		local opts = { buffer = event.buf, silent = true }
		local function move_terminal(cmd)
			return function()
				local buf = vim.api.nvim_get_current_buf()
				local win = vim.api.nvim_get_current_win()
				if vim.api.nvim_win_get_config(win).relative ~= "" then
					vim.api.nvim_win_close(win, false)
				end
				vim.cmd(cmd)
				vim.api.nvim_win_set_buf(0, buf)
			end
		end

        --stylua: ignore
		vim.keymap.set({ "n" }, "<C-s>", move_terminal("split"), vim.tbl_extend("force", opts, { desc = "Move terminal to horizontal split" }))
		vim.keymap.set(
			{ "t", "n" },
			"<C-v>",
			move_terminal("vsplit"),
			vim.tbl_extend("force", opts, { desc = "Move terminal to vertical split" })
		)
		vim.keymap.set(
			{ "t", "n" },
			"<C-t>",
			move_terminal("tabnew"),
			vim.tbl_extend("force", opts, { desc = "Move terminal to new tab" })
		)
	end,
})
