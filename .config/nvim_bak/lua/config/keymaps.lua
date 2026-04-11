local map = vim.keymap.set

map("n", "<leader>o", ":update<CR> :source $MYVIMRC<CR>", { desc = "Source " })
map("n", "<leader>so", ":source %<CR>", { desc = "Source " })

-- lazy
map("n", "<leader>l", "<cmd>Lazy<cr>", { desc = "Lazy" })

-- new file
map("n", "<leader>fn", "<cmd>enew<cr>", { desc = "New File" })

-- Copy Full File-Path
map("n", "<leader>cp", function()
	local path = vim.fn.expand("%:p")
	vim.fn.setreg("+", path)
	print("file:", path)
end, { desc = "Copy file full path" })

-- Deleting
map("n", "d", '"_d')
map("n", "x", '"_x')
map("n", "dd", '"_dd')

-- Exiting Insert Mode
map("i", "jk", "<ESC>", { desc = "Exit insert mode", silent = true })
map("i", "jj", "<ESC> :wa <cr>", { desc = "Exit insert mode and save", silent = true })

-- better indenting: maintain v after </>
map("v", "<", "<gv")
map("v", ">", ">gv")

-- Clear search and stop snippet on escape
map({ "i", "n", "s" }, "<esc>", function()
	vim.cmd("noh")
	return "<esc>"
end, { expr = true, desc = "Escape and Clear hlsearch" })

-- Clear search, diff update and redraw
-- taken from runtime/lua/_editor.lua
map(
	"n",
	"<leader>ur",
	"<Cmd>nohlsearch<Bar>diffupdate<Bar>normal! <C-L><CR>",
	{ desc = "Redraw / Clear hlsearch / Diff Update" }
)

-- Moving in insertMode
map("i", "<C-l>", "<Esc>la", { noremap = true, silent = true })

-- Save and Quit
map({ "i", "x", "n", "s" }, "<C-s>", "<cmd>w<cr><esc>", { desc = "Save File" })
map("n", "<leader>w", "<cmd>w<cr>", { desc = "Save file" })
map("n", "<leader>qq", "<cmd>qa<cr>", { desc = "Quit All" })
map("n", "<leader>wq", "<cmd>wqa<cr>", { desc = "Quit All" })

-- commenting
map("n", "gco", "o<esc>Vcx<esc><cmd>normal gcc<cr>fxa<bs>", { desc = "Add Comment Below" })
map("n", "gcO", "O<esc>Vcx<esc><cmd>normal gcc<cr>fxa<bs>", { desc = "Add Comment Above" })

-- hightlight cursor
map("n", "<leader>ui", vim.show_pos, { desc = "Inspect Pos" })
map("n", "<leader>uI", function()
	vim.treesitter.inspect_tree()
	vim.api.nvim_input("I")
end, { desc = "Inspect syntax tree" })

-- tabs
map("n", "<leader><tab>l", "<cmd>tablast<cr>", { desc = "Last Tab" })
map("n", "<leader><tab>o", "<cmd>tabonly<cr>", { desc = "Close Other Tabs" })
map("n", "<leader><tab>f", "<cmd>tabfirst<cr>", { desc = "First Tab" })
map("n", "<leader><tab><tab>", "<cmd>tabnew<cr>", { desc = "New Tab" })
map("n", "<leader><tab>]", "<cmd>tabnext<cr>", { desc = "Next Tab" })
map("n", "<leader><tab>d", "<cmd>tabclose<cr>", { desc = "Close Tab" })
map("n", "<leader><tab>[", "<cmd>tabprevious<cr>", { desc = "Previous Tab" })

-- Tab moving
map("n", "<leader><tab>m", ":tabmove<CR>", { desc = "Move tab" })
map("n", "<leader><tab>>", ":tabmove +1<CR>", { desc = "Move tab right" })
map("n", "<leader><tab><", ":tabmove -1<CR>", { desc = "Move tab left" })

-- Windows
map("n", "<leader>-", "<C-W>s", { desc = "Split Window Below", remap = true })
map("n", "<leader>|", "<C-W>v", { desc = "Split Window Right", remap = true })
map("n", "<leader>wd", "<C-W>c", { desc = "Delete Window", remap = true })

-- Move to window using the <ctrl> hjkl keys -- commented out to use vim-tmux-navigator
map("n", "<C-h>", "<C-w>h", { desc = "Go to Left Window", remap = true })
map("n", "<C-j>", "<C-w>j", { desc = "Go to Lower Window", remap = true })
map("n", "<C-k>", "<C-w>k", { desc = "Go to Upper Window", remap = true })
map("n", "<C-l>", "<C-w>l", { desc = "Go to Right Window", remap = true })

map("n", "<leader>wh", "<C-w>H") -- move window far left
map("n", "<leader>wl", "<C-w>L") -- move window far right
map("n", "<leader>wk", "<C-w>K") -- move window top
map("n", "<leader>wj", "<C-w>J") -- move window bottom

-- location list
map("n", "<leader>xl", function()
	local success, err = pcall(vim.fn.getloclist(0, { winid = 0 }).winid ~= 0 and vim.cmd.lclose or vim.cmd.lopen)
	if not success and err then
		vim.notify(err, vim.log.levels.ERROR)
	end
end, { desc = "Location List" })

-- quickfix list
map("n", "<leader>xq", function()
	local success, err = pcall(vim.fn.getqflist({ winid = 0 }).winid ~= 0 and vim.cmd.cclose or vim.cmd.copen)
	if not success and err then
		vim.notify(err, vim.log.levels.ERROR)
	end
end, { desc = "Quickfix List" })

map("n", "[q", vim.cmd.cprev, { desc = "Previous Quickfix" })
map("n", "]q", vim.cmd.cnext, { desc = "Next Quickfix" })

-- buffers
map("n", "<S-h>", "<cmd>bprevious<cr>", { desc = "Prev Buffer" })
map("n", "<S-l>", "<cmd>bnext<cr>", { desc = "Next Buffer" })
map("n", "[b", "<cmd>bprevious<cr>", { desc = "Prev Buffer" })
map("n", "]b", "<cmd>bnext<cr>", { desc = "Next Buffer" })

map("n", "<leader>bb", "<cmd>e #<cr>", { desc = "Switch to Other Buffer" })

map("n", "<leader>`", "<cmd>e #<cr>", { desc = "Switch to Other Buffer" })

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
	vim.notify("Other saved buffers deleted", vim.log.levels.INFO)
end, { desc = "Delete Other File Buffers" })

-- map("n", "<leader>bd", "<cmd>bp|bd #<cr>", { desc = "Delete Buffer" })
map("n", "<leader>bd", function()
	local bufs = vim.fn.getbufinfo({ buflisted = 1 })
	-- If this is the last, delete and open dashboard
	if #bufs == 1 then
		vim.api.nvim_buf_delete(bufs[1].bufnr, { force = true })
		require("snacks.dashboard").open()
		return
	end

	local current = vim.api.nvim_get_current_buf()

	vim.cmd("bp")

	if vim.api.nvim_buf_is_valid(current) then
		vim.api.nvim_buf_delete(current, { force = true })
	else
		vim.cmd("bd #")
	end
end, { desc = "Delete Buffer" })

map("n", "<leader>bD", "<cmd>:bd<cr>", { desc = "Delete Buffer and Window" })

-- Format
map("n", "<leader>uF", "<cmd>ToggleFormat<cr>", { desc = "Toggle global format-on-save" })
map("n", "<leader>uf", "<cmd>ToggleBuffFormat<cr>", { desc = "Toggle format-on-save for buffer" })

map("n", "<leader>Ef", "<cmd>echo &filetype<cr>", { desc = "Echo file type" })
map("n", "<leader>Eb", "<cmd>echo &buftype<cr>", { desc = "Echo file type" })

-- Terminal Mappings
map("t", "<C-/>", "<cmd>close<cr>", { desc = "Hide Terminal" })
map("t", "<C-_>", "<cmd>close<cr>", { desc = "Hide Terminal" })
map("t", "<C-]>", "<C-\\><C-n>", { desc = "Enter Copy Mode" })

local gotod = function(next, severity)
	local get = next and vim.diagnostic.get_next or vim.diagnostic.get_prev
	severity = severity and vim.diagnostic.severity[severity] or nil
	return function()
		local diag = get({ severity = severity })
		if diag then
			vim.diagnostic.jump({ diagnostic = diag })
			vim.defer_fn(function()
				vim.diagnostic.open_float(nil, { focus = false })
			end, 10)
		end
	end
end

map("n", "<leader>cd", vim.diagnostic.open_float, { desc = "Line Diagnostics" })
map("n", "]d", gotod(true), { desc = "Next Diagnostic" })
map("n", "[d", gotod(false), { desc = "Prev Diagnostic" })
map("n", "]e", gotod(true, vim.diagnostic.severity[1]), { desc = "Next Error" })
map("n", "[e", gotod(false, vim.diagnostic.severity[1]), { desc = "Prev Error" })
map("n", "]w", gotod(true, vim.diagnostic.severity[2]), { desc = "Next Warning" })
map("n", "[w", gotod(false, vim.diagnostic.severity[2]), { desc = "Prev Warning" })

vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, { desc = "LSP Code Action" })
vim.keymap.set("n", "<leader>k", vim.lsp.buf.signature_help, { desc = "Signature Help" })

-- better up/down
map({ "n", "x" }, "j", "v:count == 0 ? 'gj' : 'j'", { desc = "Down", expr = true, silent = true })
map({ "n", "x" }, "<Down>", "v:count == 0 ? 'gj' : 'j'", { desc = "Down", expr = true, silent = true })
map({ "n", "x" }, "k", "v:count == 0 ? 'gk' : 'k'", { desc = "Up", expr = true, silent = true })
map({ "n", "x" }, "<Up>", "v:count == 0 ? 'gk' : 'k'", { desc = "Up", expr = true, silent = true })

-- Resize window using <ctrl> arrow keys
map("n", "<C-Up>", "<cmd>resize +5<cr>", { desc = "Increase Window Height" })
map("n", "<C-Down>", "<cmd>resize -5<cr>", { desc = "Decrease Window Height" })
map("n", "<C-Left>", "<cmd>vertical resize -5<cr>", { desc = "Decrease Window Width" })
map("n", "<C-Right>", "<cmd>vertical resize +5<cr>", { desc = "Increase Window Width" })

-- Move Lines
map("n", "<A-j>", "<cmd>execute 'move .+' . v:count1<cr>==", { desc = "Move Down" })
map("n", "<A-k>", "<cmd>execute 'move .-' . (v:count1 + 1)<cr>==", { desc = "Move Up" })
map("i", "<A-j>", "<esc><cmd>m .+1<cr>==gi", { desc = "Move Down" })
map("i", "<A-k>", "<esc><cmd>m .-2<cr>==gi", { desc = "Move Up" })
map("v", "<A-j>", ":<C-u>execute \"'<,'>move '>+\" . v:count1<cr>gv=gv", { desc = "Move Down" })
map("v", "<A-k>", ":<C-u>execute \"'<,'>move '<-\" . (v:count1 + 1)<cr>gv=gv", { desc = "Move Up" })

-- Move Lines
map("v", "K", ":m '<-2<CR>gv=gv")
map("v", "J", ":m '>+1<CR>gv=gv")

-- using ? reverses n/N in comparison to /
map("n", "n", "'Nn'[v:searchforward].'zv'", { expr = true, desc = "Next Search Result" })
map("x", "n", "'Nn'[v:searchforward]", { expr = true, desc = "Next Search Result" })
map("o", "n", "'Nn'[v:searchforward]", { expr = true, desc = "Next Search Result" })
map("n", "N", "'nN'[v:searchforward].'zv'", { expr = true, desc = "Prev Search Result" })
map("x", "N", "'nN'[v:searchforward]", { expr = true, desc = "Prev Search Result" })
map("o", "N", "'nN'[v:searchforward]", { expr = true, desc = "Prev Search Result" })

--keywordprg
map("n", "<leader>K", "<cmd>norm! K<cr>", { desc = "Keywordprg" })

local function open_floating_netrw()
	-- Calculate window size and position
	local width = math.floor(vim.o.columns * 0.8)
	local height = math.floor(vim.o.lines * 0.8)
	local col = math.floor((vim.o.columns - width) / 2)
	local row = math.floor((vim.o.lines - height) / 2)

	-- Create a new unlisted buffer
	local buf = vim.api.nvim_create_buf(false, true)

	-- Define window configuration
	local win_opts = {
		relative = "editor",
		width = width,
		height = height,
		col = col,
		row = row,
		style = "minimal",
		border = "rounded",
	}

	-- Open the window and focus it
	local win = vim.api.nvim_open_win(buf, true, win_opts)

	-- Launch Netrw in the new buffer
	vim.cmd("Explore")
end

-- Create a keybinding to trigger it
vim.keymap.set("n", "<leader>fe", open_floating_netrw, { desc = "Open floating Netrw" })

-- local term = require("utils.trash")
-- term.setup({ persist = true })
--
-- vim.keymap.set("n", "<leader>tn", "<cmd>ViMongo<cr>", { desc = "Toggle LazyNPM terminal" })

-- vim.keymap.set("n", "<leader>tg", function()
-- 	term.toggle("lazygit")
-- end, { desc = "Toggle LazyNPM terminal" })
--
-- vim.keymap.set("n", "<leader>tt", function()
-- 	term.toggle("top")
-- end, { desc = "Toggle htop terminal" })
--
-- vim.keymap.set("n", "<leader>tm", function()
-- 	term.toggle("vi-mongo")
-- end, { desc = "Toggle htop terminal" })
