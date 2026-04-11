local map = vim.keymap.set

map("n", "<leader>xs", ":update<CR> :source $MYVIMRC<CR>", { desc = "Source" })

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

-- Save & Quit
map("i", "jk", "<ESC>", { desc = "Exiti insert mode" })
map("n", "<leader>w", ":w<CR>", { desc = "Save file" })
map("n", "<leader>wa", ":wa<CR>", { desc = "Save all files" })
map("n", "<leader>qq", ":qa<CR>", { desc = "Quit all" })
map("n", "<leader>wq", ":wqa<CR>", { desc = "Save & quit all" })
map("n", "<leader>W", ":wall ++p<CR>", { desc = "Save & create missing parent directories " })

-- clear search, diff update and redraw
map(
	"n",
	"<leader>ur",
	":nohlsearch<Bar>diffupdate<Bar>normal! <C-L><CR>",
	{ desc = "Redraw / Clear hlsearch / Diff Update" }
)
-- Editing
map("i", "<C-l>", "<Esc>la", { desc = "Move to the right one char", noremap = true, silent = true })

-- Better indenting
map("v", "<", "<gv")
map("v", ">", ">gv")

-- commenting
map(
	"n",
	"gco",
	"o<ESC>Vcx<ESC><CMD>normal gcc<CR>fxa<BS>",
	{ desc = "Add comment below", noremap = true, silent = true }
)
map(
	"n",
	"gcO",
	"O<ESC>Vcx<ESC><CMD>normal gcc<CR>fxa<BS>",
	{ desc = "Add comment above", noremap = true, silent = true }
)

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
map({ "n", "x" }, "j", "v:count == 0 ? 'gj' : 'j'", { desc = "Down", expr = true, silent = true })
map({ "n", "x" }, "<Down>", "v:count == 0 ? 'gj' : 'j'", { desc = "Down", expr = true, silent = true })
map({ "n", "x" }, "k", "v:count == 0 ? 'gk' : 'k'", { desc = "Up", expr = true, silent = true })
map({ "n", "x" }, "<Up>", "v:count == 0 ? 'gk' : 'k'", { desc = "Up", expr = true, silent = true })

-- Format
map("n", "<leader>uF", "<cmd>ToggleFormat<cr>", { desc = "Toggle global format-on-save" })
map("n", "<leader>uf", "<cmd>ToggleBuffFormat<cr>", { desc = "Toggle format-on-save for buffer" })

-- Buffer
map("n", "<S-h>", "<cmd>bprevious<cr>", { desc = "Prev Buffer" })
map("n", "<S-l>", "<cmd>bnext<cr>", { desc = "Next Buffer" })
map("n", "[b", "<cmd>bprevious<cr>", { desc = "Prev Buffer" })
map("n", "]b", "<cmd>bnext<cr>", { desc = "Next Buffer" })
map("n", "<leader>bo", function()
	local current = vim.api.nvim_get_current_buf()
	for _, buf in ipairs(vim.api.nvim_list_bufs()) do
		if buf ~= current and vim.api.nvim_buf_is_loaded(buf) then
			local bo = vim.bo[buf]

			if bo.buftype == "" and bo.buflisted and not bo.modified then
				pcall(vim.api.nvim_buf_delete, buf, { force = false })
			end
		end
	end
end, { desc = "Delete Other File Buffers" })

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

map("n", "<leader><tab>>", ":tabmove +1<CR>", { desc = "Move tab right" })
map("n", "<leader><tab><", ":tabmove -1<CR>", { desc = "Move tab left" })

-- Manage Packs
map("n", "<leader>pU", function()
	vim.pack.update()
end)
-- Terminal
map("t", "<C-/>", "<cmd>close<cr>")
