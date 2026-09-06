-- stylua: ignore start
--[[ ============================================================================
  keymaps_reference.lua — Full keymap inventory for this Neovim config.

  Dedup rule: ONE row per (lhs, modes). The row's `source` is the effective owner
  (what pressing it actually does today). When a plugin/custom map displaces a
  built-in, the note says so; surviving near-identical built-in twins are noted.

  Row format: { lhs, modes, source, description [, note] }
    lhs    : the key sequence ("<leader>" = <Space>)
    modes  : n=normal, i=insert, x=visual-only, s=select, v=visual+select,
             o=operator-pending, c=command-line, t=terminal-job
    source : "builtin" | "custom" | "plugin:<name>" (may be combined, e.g.
             "custom+plugin:bufferline" when both define the same thing)

  Tables are sorted alphabetically at load time (see `sorted()` below).
  Run `:lua require("keymaps_reference").show()` to view everything as a
  readable scratch buffer. `require("keymaps_reference").count()` prints totals.
============================================================================ ]]

local M = {}

--------------------------------------------------------------------------------
-- BUILT-IN (Neovim 0.12.5 defaults) — incl. all new 0.11/0.12 default maps
--------------------------------------------------------------------------------
local B = {
	-- Normal: basic motions
	{ "h", "n", "builtin", "Move cursor left" },
	{ "l", "n", "builtin", "Move cursor right" },
	{ "j", "n", "builtin", "Move cursor down (line-wise)", "-> displaced by custom smart-j (display-line gj without count)" },
	{ "k", "n", "builtin", "Move cursor up (line-wise)", "-> displaced by custom smart-k" },
	{ "<Down>", "nx", "builtin", "Move cursor down", "-> displaced by custom expr map" },
	{ "<Up>", "nx", "builtin", "Move cursor up", "-> displaced by custom expr map" },
	{ "0", "n", "builtin", "Move to beginning of line" },
	{ "^", "n", "builtin", "Move to first non-blank character of line" },
	{ "$", "n", "builtin", "Move to end of line" },
	{ "w", "n", "builtin", "Jump to start of next word" },
	{ "W", "n", "builtin", "Jump to start of next WORD" },
	{ "e", "n", "builtin", "Jump to end of word" },
	{ "E", "n", "builtin", "Jump to end of WORD" },
	{ "b", "n", "builtin", "Jump to start of previous word" },
	{ "B", "n", "builtin", "Jump to start of previous WORD" },
	{ "ge", "n", "builtin", "Jump backward to end of previous word" },
	{ "gg", "n", "builtin", "Go to beginning of file ([count]gg goes to line N)" },
	{ "G", "n", "builtin", "Go to end of file ([count]G goes to line N)" },
	{ "H", "n", "builtin", "Go to top of screen (restored in rev 3)" },
	{ "M", "n", "builtin", "Go to middle of screen" },
	{ "L", "n", "builtin", "Go to bottom of screen (restored in rev 3)" },
	{ "<C-d>", "n", "builtin", "Scroll half-screen down" },
	{ "<C-u>", "n", "builtin", "Scroll half-screen up" },
	{ "zz", "n", "builtin", "Center current line in window" },
	{ "zt", "n", "builtin", "Current line to top of window" },
	{ "zb", "n", "builtin", "Current line to bottom of window" },
	{ "<C-f>", "n", "builtin", "Scroll full-screen forward" },
	{ "<C-b>", "n", "builtin", "Scroll full-screen backward" },
	{ "%", "n", "builtin", "Jump to matching bracket/parenthesis" },
	{ "{", "n", "builtin", "Jump to previous blank line (paragraph)" },
	{ "}", "n", "builtin", "Jump to next blank line (paragraph)" },
	{ "[[", "nt", "builtin", "Previous section / (term buffers) jump shell prompts backward", "-> global [[ shadowed by snacks.words; inside terminals the builtin buffer-local prompt-jump wins back" },
	{ "]]", "nt", "builtin", "Next section / (term buffers) jump shell prompts forward", "-> global ]] shadowed by snacks.words; terminal prompt-jump wins inside terminals" },
	{ "<C-o>", "n", "builtin", "Jump to older position in jump list" },
	{ "<C-i>", "n", "builtin", "Jump to newer position in jump list (<Tab>)" },
	{ "<C-^>", "n", "builtin", "Switch to alternate (previous) buffer" },
	{ "gf", "n", "builtin", "Go to file whose name is under cursor" },

	-- Normal: editing
	{ "i", "n", "builtin", "Enter insert mode before cursor" },
	{ "I", "n", "builtin", "Enter insert mode at first non-blank of line" },
	{ "a", "n", "builtin", "Enter insert mode after cursor" },
	{ "A", "n", "builtin", "Enter insert mode at end of line" },
	{ "o", "n", "builtin", "Open new line below and enter insert mode" },
	{ "O", "n", "builtin", "Open new line above and enter insert mode" },
	{ "gi", "n", "builtin", "Insert at position where insert mode stopped last" },
	{ "gI", "n", "builtin", "Insert at column 1 of current line (restored rev 3; implementations = gri)" },
	{ "x", "nx", "builtin", "Delete character under cursor (normal mode)", "-> n-mode displaced by custom blackhole delete ('\"_x')" },
	{ "X", "n", "builtin", "Delete character before cursor" },
	{ "d", "no", "builtin", "Delete motion/textobject (cut)", "-> n-mode displaced by custom blackhole delete ('\"_d')" },
	{ "dd", "n", "builtin", "Delete current line (cut)", "-> displaced by custom blackhole '\"_dd'" },
	{ "D", "n", "builtin", "Delete from cursor to end of line" },
	{ "c", "no", "builtin", "Change motion/textobject (delete + insert)" },
	{ "cc", "n", "builtin", "Change current line (alias S)" },
	{ "s", "n", "builtin", "Substitute character (delete char + insert)" },
	{ "S", "n", "builtin", "Substitute line (delete line + insert)"},
	{ "r", "n", "builtin", "Replace single character (intact)", "flash only takes r in operator-pending" },
	{ "R", "n", "builtin", "Enter Replace mode (overtype) (intact)", "flash only takes R in o/x" },
	{ "y", "no", "builtin", "Yank (copy) motion/textobject" },
	{ "yy", "n", "builtin", "Yank current line" },
	{ "Y", "n", "builtin", "Yank from cursor to end of line (explicit y$ default map)" },
	{ "p", "n", "builtin", "Paste after cursor", "-> displaced by custom ]p (paste below, indent-adjusted)" },
	{ "P", "n", "builtin", "Paste before cursor", "-> displaced by custom [p (paste above, indent-adjusted)" },
	{ "gp", "n", "builtin", "Paste after cursor, leave cursor after pasted text" },
	{ "gP", "n", "builtin", "Paste before cursor, leave cursor after pasted text" },
	{ "\"{register}", "nix", "builtin", "Use {register} for next delete/yank/paste (e.g. \"ap, \"ayy)" },
	{ "u", "n", "builtin", "Undo" },
	{ "<C-r>", "n", "builtin", "Redo" },
	{ ".", "n", "builtin", "Repeat last change" },
	{ "&", "n", "builtin", "Repeat last :substitute with same flags (0.12 default map)" },
	{ ">>", "n", "builtin", "Indent current line" },
	{ "<<", "n", "builtin", "Unindent current line" },
	{ "J", "n", "builtin", "Join current line with next" },
	{ "gJ", "n", "builtin", "Join lines without inserting space" },
	{ "~", "n", "builtin", "Toggle case of character under cursor" },
	{ "gu", "no", "builtin", "Lowercase motion/textobject (guw, guu)" },
	{ "gU", "no", "builtin", "Uppercase motion/textobject (gUw, gUU)" },
	{ "g~", "no", "builtin", "Toggle case of motion/textobject" },
	{ "ga", "nx", "builtin", "Print ascii/hex/digraph value of char under cursor" },
	{ ";", "nxo", "builtin", "Repeat latest f/t/F/T move", "-> extended/replaced by treesitter-textobjects repeatable move" },
	{ ",", "nxo", "builtin", "Repeat latest f/t/F/T move backwards", "-> extended/replaced by treesitter-textobjects repeatable move" },
	{ "K", "n", "builtin", "Hover: keywordprg/man; with LSP attached -> vim.lsp.buf.hover()", "-> rust buffers: rustaceanvim hover-actions replaces it" },
	{ "gcc", "n", "builtin", "Toggle comment on line (built-in commenting, 0.10+)", "complements custom gco/gcO" },
	{ "gc{motion}", "nxo", "builtin", "Toggle comment on motion (x) / comment textobject (o)", "complements custom gco/gcO" },
	{ "gx", "nx", "builtin", "Open filepath/URI under cursor with system handler (vim.ui.open)", "NEW-ish default; also handles documentLink" },
	{ "ZQ", "n", "builtin", "Quit current window without saving (:q!)" },
	{ "ZZ", "n", "builtin", "Write current file and quit (:x)" },
	{ "ZR", "n", "builtin", "Restart Neovim (:restart, session restored) — NEW 0.12 default; [1-8]ZR restarts w/o session restore, 9ZR also skips modified-check", "custom <leader>xx removed rev 3" },
	{ "Q", "n", "builtin", "Replay last recorded macro (nvim repurposed Ex-mode Q)" },

	-- Normal: search
	{ "/", "n", "builtin", "Search forward (/pattern<CR>)" },
	{ "?", "n", "builtin", "Search backward (?pattern<CR>)" },
	{ "n", "nxo", "builtin", "Repeat last search forward", "-> displaced by custom swapped-direction n (+zv); pairs with ?" },
	{ "N", "nxo", "builtin", "Repeat last search backward", "-> displaced by custom swapped-direction N (+zv)" },
	{ "*", "nx", "builtin", "Search word under cursor forward; visual * searches selection", "v_* added as default long ago" },
	{ "#", "nx", "builtin", "Search word under cursor backward; visual # searches selection" },

	-- Normal: marks, macros, folds
	{ "m{a-z}", "n", "builtin", "Set mark {a-z}" },
	{ "'{a-z}", "n", "builtin", "Jump to beginning of marked line" },
	{ "`{a-z}", "n", "builtin", "Jump to exact marked position" },
	{ "''", "n", "builtin", "Jump to position before latest jump" },
	{ "``", "n", "builtin", "Jump to exact position before latest jump / previous file" },
	{ "q{reg}", "n", "builtin", "Start recording macro into register", "-> special windows & overseer/dashboard buffers: q closes instead (buffer-local)" },
	{ "@{reg}", "n", "builtin", "Execute macro in register" },
	{ "@@", "n", "builtin", "Repeat last executed macro" },
	{ "za", "n", "builtin", "Toggle fold under cursor" },
	{ "zA", "n", "builtin", "Toggle fold recursively" },
	{ "zo", "n", "builtin", "Open fold" },
	{ "zO", "n", "builtin", "Open fold recursively" },
	{ "zc", "n", "builtin", "Close fold" },
	{ "zC", "n", "builtin", "Close fold recursively" },
	{ "zr", "n", "builtin", "Open one fold level throughout buffer (reduce folding)" },
	{ "zm", "n", "builtin", "Close one fold level throughout buffer (more folding)" },
	{ "zR", "n", "builtin", "Open all folds" },
	{ "zM", "n", "builtin", "Close all folds" },

	-- Normal: 0.11/0.12 default LSP maps (mapped unconditionally)
	{ "grn", "n", "builtin", "vim.lsp.buf.rename()" },
	{ "gra", "nx", "builtin", "vim.lsp.buf.code_action()" },
	{ "grx", "n", "builtin", "vim.lsp.codelens.run()" },
	{ "grr", "n", "builtin", "vim.lsp.buf.references()", "primary references binding since snacks gr duplicate removed" },
	{ "gri", "n", "builtin", "vim.lsp.buf.implementation()" },
	{ "grt", "n", "builtin", "vim.lsp.buf.type_definition()" },
	{ "gO", "n", "builtin", "vim.lsp.buf.document_symbol()", "native alternative to snacks <leader>ss" },
	{ "<C-S>", "is", "builtin", "vim.lsp.buf.signature_help()", "insert-mode twin of custom <leader>k" },

	-- Normal: 0.12 default diagnostics maps
	{ "]d", "n", "builtin", "Jump to next diagnostic (count-aware, restored rev 3)" },
	{ "[d", "n", "builtin", "Jump to previous diagnostic (restored rev 3)" },
	{ "]D", "n", "builtin", "Jump to LAST diagnostic in buffer (new default)" },
	{ "[D", "n", "builtin", "Jump to FIRST diagnostic in buffer (new default)" },
	{ "<C-w>d", "n", "builtin", "Show diagnostics under cursor in float", "twin of custom <leader>cd" },
	{ "<C-w><C-D>", "n", "builtin", "Alias of <C-w>d" },

	-- Normal: unimpaired-style defaults (all [x / ]x pairs below are stock now)
	{ "[b", "n", "builtin", ":bprevious", "= custom/bufferline twin; see plugin rows for who wins" },
	{ "]b", "n", "builtin", ":bnext" },
	{ "[B", "n", "builtin", ":brewind / first buffer (restored rev 3)" },
	{ "]B", "n", "builtin", ":blast / last buffer (restored rev 3)" },
	{ "[q", "n", "builtin", ":cprevious (quickfix)" },
	{ "]q", "n", "builtin", ":cnext (quickfix)" },
	{ "[Q", "n", "builtin", ":crewind (first quickfix)" },
	{ "]Q", "n", "builtin", ":clast (last quickfix)" },
	{ "[<C-q>", "n", "builtin", ":cpfile (prev quickfix file)" },
	{ "]<C-q>", "n", "builtin", ":cnfile (next quickfix file)" },
	{ "[l", "n", "builtin", ":lprevious (loclist)" },
	{ "]l", "n", "builtin", ":lnext (loclist)" },
	{ "[L", "n", "builtin", ":lrewind (first loclist)" },
	{ "]L", "n", "builtin", ":llast (last loclist)" },
	{ "[<C-l>", "n", "builtin", ":lpfile (prev loclist file)", "distinct from plain <C-L> clear-search" },
	{ "]<C-l>", "n", "builtin", ":lnfile (next loclist file)" },
	{ "[a", "n", "builtin", ":previous (arglist)" },
	{ "]a", "n", "builtin", ":next (arglist)" },
	{ "[A", "n", "builtin", ":rewind / [count]argument (arglist)" },
	{ "]A", "n", "builtin", ":last / [count]argument (arglist)" },
	{ "[t", "n", "builtin", ":tprevious (tag stack, restored rev 3)" },
	{ "]t", "n", "builtin", ":tnext (tag stack, restored rev 3)" },
	{ "[T", "n", "builtin", ":trewind (first tag)" },
	{ "]T", "n", "builtin", ":tlast (last tag)" },
	{ "[<C-t>", "n", "builtin", ":ptprevious (preview-tag prev)" },
	{ "]<C-t>", "n", "builtin", ":ptnext (preview-tag next)" },
	{ "[<Space>", "n", "builtin", "Add empty line above cursor" },
	{ "]<Space>", "n", "builtin", "Add empty line below cursor" },

	-- Normal: misc single-key defaults
	{ "<C-l>", "n", "builtin", "Clear hlsearch + diff update + redraw (0.10+ default; restored rev 3 — window-right is <C-w>l again)" },

	-- Visual/Select/Operator-pending defaults
	{ "v", "n", "builtin", "Start visual (characterwise) mode" },
	{ "V", "n", "builtin", "Start visual linewise mode" },
	{ "<C-v>", "n", "builtin", "Start visual block mode" },
	{ "y", "x", "builtin", "Yank selected text" },
	{ "d", "x", "builtin", "Delete selected text (cuts to unnamed register)", "only normal d/x/dd were blackholed" },
	{ "x", "x", "builtin", "Delete selected character(s)" },
	{ "c", "x", "builtin", "Change selected text" },
	{ ">", "x", "builtin", "Indent selection", "-> displaced by custom >gv keeps selection" },
	{ "<", "x", "builtin", "Unindent selection", "-> displaced by custom <gv keeps selection" },
	{ "u", "x", "builtin", "Lowercase selection" },
	{ "U", "x", "builtin", "Uppercase selection" },
	{ "~", "x", "builtin", "Toggle case of selection" },
	{ "o", "x", "builtin", "Jump to other end of selection" },
	{ "O", "x", "builtin", "Jump to other corner (blockwise)" },
	{ "gv", "n", "builtin", "Reselect last visual selection" },
	{ "@{reg}", "x", "builtin", "Execute macro on each line of linewise selection (0.10+ default)" },
	{ "Q", "x", "builtin", "Replay last recorded macro on each line of selection" },
	{ "[n", "x", "builtin", "Select previous treesitter node (incremental selection)" },
	{ "]n", "x", "builtin", "Select next treesitter node" },
	{ "[N", "x", "builtin", "Grow selection to previous sibling node" },
	{ "]N", "x", "builtin", "Grow selection to next sibling node" },
	{ "an", "xo", "builtin", "Select parent (outer) node — treesitter, LSP selection_range fallback" },
	{ "in", "xo", "builtin", "Select child (inner) node — treesitter, LSP fallback" },

	-- Insert/Select mode defaults
	{ "<Esc>", "i", "builtin", "Exit insert mode", "custom: jk also exits" },
	{ "<Tab>", "is", "builtin", "Jump forward in snippet if active, else literal Tab", "-> blink.cmp re-maps Tab (snippet_forward/select_next/fallback)" },
	{ "<S-Tab>", "is", "builtin", "Jump backward in snippet if active", "-> blink.cmp re-maps S-Tab" },
	{ "<C-h>", "i", "builtin", "Delete character before cursor" },
	{ "<C-w>", "i", "builtin", "Delete word before cursor (adds undo break-point)" },
	{ "<C-u>", "i", "builtin", "Delete to beginning of inserted text (adds undo break-point)" },
	{ "<C-t>", "i", "builtin", "Indent one shiftwidth in insert mode" },
	{ "<C-d>", "i", "builtin", "Unindent one shiftwidth in insert mode" },
	{ "<C-o>", "i", "builtin", "Execute one normal-mode command then return to insert" },
	{ "<C-r>", "i", "builtin", "Insert contents of register (<C-r>\")" },
	{ "<C-n>", "i", "builtin", "Built-in completion: next match", "-> blink select_next; minuet cycle; whisper dictation all claim <C-n>" },
	{ "<C-p>", "i", "builtin", "Built-in completion: previous match", "-> blink select_prev; minuet cycle" },
	{ "<C-y>", "i", "builtin", "Insert character from line above", "-> taken by copilot accept + minuet accept_line" },
	{ "<C-e>", "i", "builtin", "Insert character from line below", "-> taken by blink.cmp dismiss menu" },
	{ "<C-k>", "i", "builtin", "Start digraph entry", "-> taken by blink.cmp show/hide signature" },
	{ "<C-l>", "i", "builtin", "Leave insert mode", "-> remapped: custom move-right-one-char" },

	-- Command-line mode
	{ ":", "n", "builtin", "Enter command-line mode" },
	{ "<C-c>", "c", "builtin", "Cancel command" },
	{ "<Esc>", "c", "builtin", "Exit command-line mode" },
	{ "<Up>", "c", "builtin", "Previous command in history" },
	{ "<Down>", "c", "builtin", "Next command in history" },
	{ "<C-r>\"", "c", "builtin", "Insert contents of unnamed register" },
	{ "<C-r>=", "c", "builtin", "Insert result of Vimscript/Lua expression" },

	-- Terminal mode
	{ "<C-\\><C-n>", "t", "builtin", "Exit terminal (job) mode to normal" },
}

--------------------------------------------------------------------------------
-- CUSTOM keymaps — configs/keymaps.lua, diagnostics.lua, autocmds, init.lua
-- Rev 3 removals (builtins win): <S-h>/<S-l>, [b/]b, n-mode <C-l>,
-- <leader>ur (=builtin <C-L>), <leader>xx (=builtin ZR), <leader>xq,
-- ]d/[d (builtin diagnostic jumps restored).
--------------------------------------------------------------------------------
local C = {
	-- Core (init.lua + configs/keymaps.lua)
	{ "<leader>p", "n", "custom", "Pack manager dashboard (:Pack)" },
	{ "<leader>%", "n", "custom", "Create new file (:enew)" },
	{ "<leader>-", "n", "custom", "Split window below (= <C-w>s)" },
	{ "<leader>|", "n", "custom", "Split window right (= <C-w>v)" },
	{ "<leader>cP", "n", "custom", "Copy full absolute file path to clipboard" },
	{ "<leader>cp", "n", "custom", "Copy relative file path to clipboard" },
	{ "<leader>cr", "n", "custom", "LSP Rename symbol", "native twin grn exists; kotlin buffers override this with Run Project" },
	{ "<leader>d", "nx", "custom", "Delete without yanking (blackhole register \"_\")" },
	{ "<leader>cd", "n", "custom", "Show line diagnostics in float", "= builtin <C-w>d twin" },
	{ "<leader>hd", "n", "custom", "checkhealth dap" },
	{ "<leader>hh", "n", "custom", "checkhealth vim.health" },
	{ "<leader>hl", "n", "custom", "checkhealth vim.lsp" },
	{ "<leader>hn", "n", "custom", "checkhealth nvim-treesitter" },
	{ "<leader>hp", "n", "custom", "checkhealth pack (vim.pack)" },
	{ "<leader>hs", "n", "custom", "checkhealth snacks" },
	{ "<leader>ht", "n", "custom", "checkhealth vim.treesitter" },
	{ "<leader>hv", "n", "custom", "checkhealth vim.provider" },
	{ "<leader>hx", "n", "custom", "checkhealth vim.deprecated" },
	{ "<leader>k", "n", "custom", "LSP signature help", "native insert-mode twin <C-S> exists" },
	{ "<leader>pb", "n", "custom", "Paste block below current line ('[,']t'])" },
	{ "<leader>pt", "n", "custom", "Paste block above current line ('[,']t'[-1)" },
	{ "<leader>pu", "n", "custom", "Update all plugins (vim.pack.update)" },
	{ "<leader>qq", "n", "custom", "Quit all (:silent qa)" },
	{ "<leader>uF", "n", "custom", "Toggle global format-on-save (:ToggleFormat)", "conform.nvim duplicate removed rev 3" },
	{ "<leader>uf", "n", "custom", "Toggle format-on-save for buffer (:ToggleBuffFormat)", "conform.nvim duplicate removed rev 3" },
	{ "<leader>w", "n", "custom", "Save file (:silent w)" },
	{ "<leader>wa", "n", "custom", "Save all files (:silent wa)" },
	{ "<leader>wd", "n", "custom", "Delete (close) current window" },
	{ "<leader>wq", "n", "custom", "Save & quit all (:silent wqa)" },
	{ "<leader>W", "n", "custom", "Save all + create missing parent dirs (:silent wall ++p)" },
	{ "<leader>xl", "n", "custom", "Location list from file diagnostics (toggle close)", "native twins: [l ]l navigate loclist" },
	{ "<leader>xs", "n", "custom", "Save + source $MYVIMRC" },
	{ "[e", "n", "custom", "Previous ERROR diagnostic (float preview)", "no builtin severity twin" },
	{ "]e", "n", "custom", "Next ERROR diagnostic (float preview)" },
	{ "[w", "n", "custom", "Previous WARNING diagnostic (float preview)" },
	{ "]w", "n", "custom", "Next WARNING diagnostic (float preview)" },
	{ "d", "n", "custom", "Delete to blackhole register (never yanks)" },
	{ "dd", "n", "custom", "Delete line to blackhole register" },
	{ "gco", "n", "custom", "Add comment on new line below", "complements builtin gc/gcc operators" },
	{ "gcO", "n", "custom", "Add comment on new line above" },
	{ "jk", "i", "custom", "Exit insert mode (<ESC>)" },
	{ "j", "nx", "custom", "Move down (display-line gj when no count, line-wise j with count)" },
	{ "k", "nx", "custom", "Move up (display-line gk when no count)" },
	{ "<Down>", "nx", "custom", "Same smart-down behavior as j" },
	{ "<Up>", "nx", "custom", "Same smart-up behavior as k" },
	{ "n", "nxo", "custom", "Next search result (direction swapped: 'Nn'[v:searchforward]) + open fold (zv)", "displaces builtin n/N; pairs with ? backward search" },
	{ "N", "nxo", "custom", "Prev search result (direction swapped) + open fold (zv)", "displaces builtin N" },
	{ "p", "n", "custom", "Paste below with indent adjustment (]p)", "plain paste-at-cursor: use ]p charwise behavior or gp/gP" },
	{ "P", "n", "custom", "Paste above with indent adjustment ([p)" },
	{ "x", "n", "custom", "Delete char to blackhole register" },
	{ "<", "v", "custom", "Unindent selection and keep selection (<gv)" },
	{ ">", "v", "custom", "Indent selection and keep selection (>gv)" },
	{ "<A-j>", "niv", "custom", "Move line/selection down (auto-indent)" },
	{ "<A-k>", "niv", "custom", "Move line/selection up (auto-indent)" },
	{ "<C-h>", "n", "custom", "Go to left window (<C-w>h)" },
	{ "<C-j>", "n", "custom", "Go to lower window (<C-w>j)" },
	{ "<C-k>", "n", "custom", "Go to upper window (<C-w>k)" },
	{ "<C-l>", "n", "custom", "Go to right window (<C-w>l)", "SHADOWS builtin <C-L> clear-search/redraw" },
	{ "<C-l>", "i", "custom", "Move cursor right one char (<Esc>la)" },
	{ "<leader><tab>", "n", "custom", "New tab (:tabnew)" }, -- <leader><tab><tab>
	{ "<leader><tab>[", "n", "custom", "Previous tab", "native twin [<tab>" },
	{ "<leader><tab>]", "n", "custom", "Next tab" },
	{ "<leader><tab><", "n", "custom", "Move tab left (:tabmove -1)" },
	{ "<leader><tab>>", "n", "custom", "Move tab right (:tabmove +1)" },
	{ "<leader><tab>d", "n", "custom", "Close tab (:tabclose)" },
	{ "<leader><tab>f", "n", "custom", "First tab (:tabfirst)" },
	{ "<leader><tab>l", "n", "custom", "Last tab (:tablast)" },
	{ "<leader><tab>o", "n", "custom", "Close other tabs (:tabonly)" },
	{ "<C-,>", "n", "custom", "Terminal buffer: move terminal to horizontal split", "term buffers only; replaces XOFF freeze" },
	{ "<C-t>", "nt", "custom", "Terminal buffer: move terminal to new tab", "term buffers only (buffer-local; normal-mode <C-t> tag-pop untouched elsewhere)" },
	{ "<C-.>", "nt", "custom", "Terminal buffer: move terminal to vertical split", "term buffers only" },

	-- Diagnostics (configs/diagnostics.lua) — [d ]d deduped into builtin rows

	-- Autocmd/usercmd buffer-local (autocmds.lua + usercmds.lua + overseer + dashboard)
	{ "q", "n", "custom+plugin", "Buffer-local: close special windows (help, qf, notify, lspinfo, checkhealth, grug-far, neotest panels), overseer lists & task terminals; on dashboard: quit", "replaces macro recording in those buffers" },
}

--------------------------------------------------------------------------------
-- PLUGIN keymaps — every mapping registered by a plugin spec (deduped)
--------------------------------------------------------------------------------
local P = {
	-- blink.cmp (insert/cmdline completion)
	{ "<C-space>", "i", "plugin:blink.cmp", "Show completion / show-hide documentation" },
	{ "<C-e>", "i", "plugin:blink.cmp", "Hide completion menu (fallback if hidden)", "displaces builtin insert-char-from-line-below" },
	{ "<CR>", "i", "plugin:blink.cmp", "Accept selected completion (fallback to newline)" },
	{ "<Tab>", "i", "plugin:blink.cmp", "Snippet forward / select next / fallback", "supersedes builtin i_<Tab> snippet-jump (same intent)" },
	{ "<S-Tab>", "i", "plugin:blink.cmp", "Snippet backward / select prev / fallback", "supersedes builtin i_<S-Tab>" },
	{ "<Up>", "i", "plugin:blink.cmp", "Select previous completion item" },
	{ "<Down>", "i", "plugin:blink.cmp", "Select next completion item" },
	{ "<C-p>", "i", "plugin:blink.cmp+minuet", "Select prev completion item / cycle AI suggestion prev", "displaces builtin completion prev" },
	{ "<C-n>", "i", "plugin:blink.cmp+minuet", "Select next completion item / cycle AI suggestion next", "displaces builtin completion next" },
	{ "<C-b>", "ic", "plugin:blink.cmp", "Scroll documentation window up" },
	{ "<C-f>", "ic", "plugin:blink.cmp", "Scroll documentation window down" },
	{ "<C-k>", "i", "plugin:blink.cmp", "Show/hide signature help", "displaces builtin digraph entry" },

	-- copilot.vim
	{ "<C-Y>", "i", "plugin:copilot.vim", "Accept Copilot suggestion (lazy: loads via :Copilot)", "same physical key as minuet accept <C-y>; ambiguous ownership once both loaded" },

	-- minuet-ai (virtual text ghost completions)
	{ "<C-y>", "i", "plugin:minuet", "Accept AI virtual-text suggestion (when shown)", "displaces builtin insert-char-from-above; collides with copilot <C-Y>" },
	{ "<C-a>", "i", "plugin:minuet", "Accept AI suggestion line (when shown)", "insert only; normal <C-a> is dial" },
	{ "<Escape>", "i", "plugin:minuet", "Dismiss AI virtual text (when shown)" },

	-- whisper.nvim
	{ "<M-n>", "niv", "plugin:whisper", "Toggle whisper voice dictation (streams text)", "moved off <C-n> in rev 3 (frees builtin completion-next)" },

	-- flash.nvim
	{ "s", "nxo", "plugin:flash", "Flash jump (labelled multi-cursor jump anywhere)", "KEPT override of builtin substitute s — TODO in flash.lua to rebind/remove" },
	{ "S", "nxo", "plugin:flash", "Flash Treesitter select node", "KEPT override of builtin substitute-line S — TODO in flash.lua" },
	{ "r", "o", "plugin:flash", "Remote Flash (operate from remote location)", "normal r replace-char untouched" },
	{ "R", "ox", "plugin:flash", "Flash Treesitter search", "normal R replace-mode untouched" },
	{ "<C-s>", "c", "plugin:flash", "Toggle Flash search in command-line" },

	-- dial.nvim
	{ "<C-a>", "n", "plugin:dial", "Smart increment (numbers, dates, bools, semver)", "KEPT override of builtin increment — strict superset" },
	{ "<C-x>", "n", "plugin:dial", "Smart decrement", "KEPT override of builtin decrement — strict superset" },
	{ "g<C-a>", "n", "plugin:dial", "Sequential increment across visually selected lines" },
	{ "g<C-x>", "n", "plugin:dial", "Sequential decrement across visually selected lines" },
	{ "<C-a>", "v", "plugin:dial", "Smart increment on selection" },
	{ "<C-x>", "v", "plugin:dial", "Smart decrement on selection" },
	{ "g<C-a>", "v", "plugin:dial", "Sequential increment over selected lines" },
	{ "g<C-x>", "v", "plugin:dial", "Sequential decrement over selected lines" },

	-- vim-easy-align
	{ "ga", "nx", "plugin:easy-align", "EasyAlign: align around interactive delimiter (press ga, then char)", "KEPT override of builtin ga info-printout (:ascii works) — TODO in easy-align.lua" },

	-- nvim-surround (remapped onto gz prefixes; default ys/cs/ds disabled)
	{ "gza", "n", "plugin:nvim-surround", "Add surround to motion (ys replacement)" },
	{ "gzA", "n", "plugin:nvim-surround", "Add surround to motion, include line" },
	{ "gzz", "n", "plugin:nvim-surround", "Add surround to current line" },
	{ "gzZ", "n", "plugin:nvim-surround", "Add surround to current line, include line" },
	{ "gzd", "n", "plugin:nvim-surround", "Delete surrounding pair (ds replacement)" },
	{ "gzr", "n", "plugin:nvim-surround", "Change surrounding pair (cs replacement)" },
	{ "gza", "x", "plugin:nvim-surround", "Surround visual selection" },
	{ "gzA", "x", "plugin:nvim-surround", "Surround visual selection with line" },
	{ "<C-g>z", "i", "plugin:nvim-surround", "Add surround while typing in insert mode" },
	{ "<C-g>Z", "i", "plugin:nvim-surround", "Add surround with newlines while in insert mode" },

	-- treesitter + textobjects
	{ "af", "xo", "plugin:treesitter-textobjects", "Select outer function" },
	{ "if", "xo", "plugin:treesitter-textobjects", "Select inner function" },
	{ "ac", "xo", "plugin:treesitter-textobjects", "Select outer class" },
	{ "ic", "xo", "plugin:treesitter-textobjects", "Select inner class" },
	{ "al", "xo", "plugin:treesitter-textobjects", "Select outer loop" },
	{ "il", "xo", "plugin:treesitter-textobjects", "Select inner loop" },
	{ "]f", "nxo", "plugin:treesitter-textobjects", "Jump to next function start" },
	{ "]F", "nxo", "plugin:treesitter-textobjects", "Jump to next function end" },
	{ "[f", "nxo", "plugin:treesitter-textobjects", "Jump to previous function start" },
	{ "[F", "nxo", "plugin:treesitter-textobjects", "Jump to previous function end" },
	{ "]c", "nxo", "plugin:treesitter-textobjects", "Jump to next class/struct start" },
	{ "]C", "nxo", "plugin:treesitter-textobjects", "Jump to next class/struct end" },
	{ "[c", "nxo", "plugin:treesitter-textobjects", "Jump to previous class/struct start" },
	{ "[C", "nxo", "plugin:treesitter-textobjects", "Jump to previous class/struct end" },
	{ ";", "nxo", "plugin:treesitter-textobjects", "Repeat last textobject move forward (also repeats f/t)", "extends builtin ;" },
	{ ",", "nxo", "plugin:treesitter-textobjects", "Repeat last textobject move backward", "extends builtin ," },

	-- todo-comments.nvim — keys removed rev 3 (builtin [t/]t tag-nav restored);
	-- TODO in spec: rebind to a free pair like ]x/[x if TODO-jumping is missed.

	-- gitsigns.nvim
	{ "]h", "n", "plugin:gitsigns", "Next git hunk" },
	{ "[h", "n", "plugin:gitsigns", "Previous git hunk" },
	{ "<leader>ghS", "n", "plugin:gitsigns", "Stage hunk" },
	{ "<leader>ghR", "n", "plugin:gitsigns", "Reset (discard) hunk" },
	{ "<leader>ghp", "n", "plugin:gitsigns", "Preview hunk diff" },
	{ "<leader>ghi", "n", "plugin:gitsigns", "Preview hunk inline" },
	{ "<leader>ghb", "n", "plugin:gitsigns", "Blame line (full)" },
	{ "<leader>ghd", "n", "plugin:gitsigns", "Diff this buffer" },
	{ "<leader>ghD", "n", "plugin:gitsigns", "Diff this against last commit (~)" },

	-- bufferline.nvim
	{ "<leader>bp", "n", "plugin:bufferline", "Toggle pin buffer" },
	{ "<leader>bP", "n", "plugin:bufferline", "Close non-pinned buffers" },
	{ "<leader>br", "n", "plugin:bufferline", "Close buffers to the right" },
	{ "<leader>bl", "n", "plugin:bufferline", "Close buffers to the left" },
	{ "<leader>bs", "n", "plugin:bufferline", "Pick buffer (jump by letter)" },
	{ "<leader>bc", "n", "plugin:bufferline", "Pick & close buffer" },
	{ "<leader>bD", "n", "plugin:tabscope", "Remove tab-local buffer" },

	-- snacks.nvim — pickers
	{ "<leader><space>", "n", "plugin:snacks", "Picker: smart find files" },
	{ "<leader>,", "n", "plugin:snacks", "Picker: buffers" },
	{ "<leader>/", "n", "plugin:snacks", "Picker: grep (live project search)" },
	{ "<leader>:", "n", "plugin:snacks", "Picker: command history" },
	{ "<leader>fi", "n", "plugin:snacks", "Picker: find git-ignored & hidden files" },
	{ "<leader>fb", "n", "plugin:snacks", "Picker: buffers" },
	{ "<leader>fc", "n", "plugin:snacks", "Picker: find config file" },
	{ "<leader>ff", "n", "plugin:snacks", "Picker: find files (smart)" },
	{ "<leader>fg", "n", "plugin:snacks", "Picker: find git-tracked files" },
	{ "<leader>fp", "n", "plugin:snacks", "Picker: projects" },
	{ "gai", "n", "plugin:snacks", "Picker: LSP incoming calls" },
	{ "gao", "n", "plugin:snacks", "Picker: LSP outgoing calls" },
	{ "]]", "nt", "plugin:snacks", "Jump to next highlighted word reference (LSP words)", "displaces builtin section-motion; inside terminals builtin prompt-jump (buf-local) wins" },
	{ "[[", "nt", "plugin:snacks", "Jump to previous highlighted word reference", "same terminal caveat" },
	{ "<C-;>", "n", "plugin:snacks", "Picker: spelling suggestions" },
	{ "<leader>s\"", "n", "plugin:snacks", "Picker: registers" },
	{ "<leader>s/", "n", "plugin:snacks", "Picker: search history" },
	{ "<leader>sa", "n", "plugin:snacks", "Picker: autocmds" },
	{ "<leader>sb", "n", "plugin:snacks", "Picker: buffer lines" },
	{ "<leader>sB", "n", "plugin:snacks", "Picker: grep open buffers" },
	{ "<leader>sc", "n", "plugin:snacks", "Picker: command history" },
	{ "<leader>sC", "n", "plugin:snacks", "Picker: commands" },
	{ "<leader>sd", "n", "plugin:snacks", "Picker: workspace diagnostics" },
	{ "<leader>sD", "n", "plugin:snacks", "Picker: buffer diagnostics" },
	{ "<leader>sg", "n", "plugin:snacks", "Picker: grep" },
	{ "<leader>sG", "n", "plugin:snacks", "Picker: grep incl. ignored files" },
	{ "<leader>sh", "n", "plugin:snacks", "Picker: help pages" },
	{ "<leader>sH", "n", "plugin:snacks", "Picker: highlight groups" },
	{ "<leader>si", "n", "plugin:snacks", "Picker: icon browser" },
	{ "<leader>sj", "n", "plugin:snacks", "Picker: jump list" },
	{ "<leader>sk", "n", "plugin:snacks", "Picker: all keymaps" },
	{ "<leader>sl", "n", "plugin:snacks", "Picker: location list" },
	{ "<leader>sm", "n", "plugin:snacks", "Picker: marks" },
	{ "<leader>sM", "n", "plugin:snacks", "Picker: man pages" },
	{ "<leader>sp", "n", "plugin:snacks", "Picker: projects (plugin-spec search)" },
	{ "<leader>sP", "n", "plugin:snacks", "Picker: system processes" },
	{ "<leader>sq", "n", "plugin:snacks", "Picker: quickfix list" },
	{ "<leader>sR", "n", "plugin:snacks", "Picker: resume last picker" },
	{ "<leader>ss", "n", "plugin:snacks", "Picker: LSP document symbols", "native twin gO still works" },
	{ "<leader>sS", "n", "plugin:snacks", "Picker: LSP workspace symbols" },
	{ "grd", "n", "plugin:snacks", "Picker: LSP definitions" },
	{ "grD", "n", "plugin:snacks", "Picker: LSP declarations" },
	{ "<leader>st", "nx", "plugin:snacks", "Picker: TODO comments" },
	{ "<leader>sT", "n", "plugin:snacks", "Picker: treesitter symbols" },
	{ "<leader>su", "n", "plugin:snacks", "Picker: undo history" },
	{ "<leader>sw", "nx", "plugin:snacks", "Picker: grep visual selection or word" },
	{ "<leader>s.", "n", "plugin:snacks", "Picker: select scratch buffer" },
	{ "<leader>uC", "n", "plugin:snacks", "Picker: colorschemes preview/switch" },

	-- snacks.nvim — git & github
	{ "<leader>gb", "n", "plugin:snacks", "Picker: git branches" },
	{ "<leader>g.", "n", "plugin:snacks", "Git blame current line popup" },
	{ "<leader>gl", "n", "plugin:snacks", "Picker: git log" },
	{ "<leader>gL", "n", "plugin:snacks", "Picker: git log of current line" },
	{ "<leader>gf", "n", "plugin:snacks", "Picker: git log of current file" },
	{ "<leader>gs", "n", "plugin:snacks", "Picker: git status" },
	{ "<leader>gS", "n", "plugin:snacks", "Picker: git stash list" },
	{ "<leader>gd", "n", "plugin:snacks", "Picker: git diff hunks" },
	{ "<leader>gi", "n", "plugin:snacks", "Picker: GitHub issues (open)" },
	{ "<leader>gI", "n", "plugin:snacks", "Picker: GitHub issues (all)" },
	{ "<leader>gp", "n", "plugin:snacks", "Picker: GitHub PRs (open)" },
	{ "<leader>gP", "n", "plugin:snacks", "Picker: GitHub PRs (all)" },
	{ "<leader>gB", "nv", "plugin:snacks", "Open repo/line in browser (gitbrowse)", "builtin gx opens URLs too" },
	{ "<leader>gg", "n", "plugin:snacks", "Open Lazygit in float" },

	-- snacks.nvim — buffers/files/scratch/misc
	{ "<leader>bd", "n", "plugin:snacks", "Delete current buffer (keep window)" },
	{ "<leader>bq", "n", "plugin:snacks", "Delete all buffers" },
	{ "<leader>bo", "n", "plugin:snacks", "Delete other buffers" },
	{ "<leader>.", "n", "plugin:snacks", "Toggle scratch buffer" },
	{ "<leader>cR", "n", "plugin:snacks", "Rename file (updates LSP imports)" },
	{ "<leader>uz", "n", "plugin:snacks", "Toggle zen mode" },
	{ "<leader>um", "n", "plugin:snacks", "Toggle zoom (maximize window)" },
	{ "<leader>un", "n", "plugin:snacks", "Dismiss all notifications" },
	{ "<C-/>", "nitx", "plugin:snacks", "Toggle floating terminal" },
	{ "<A-/>", "nt", "plugin:snacks", "Open disposable floating terminal (starts in insert)" },
	{ "<C-_>", "nt", "plugin:snacks", "Toggle floating terminal (hidden alias of <C-/>)" },
	{ "<C-]>", "t", "plugin:snacks", "In terminal: enter copy/normal mode (<C-\\><C-n>)" },

	-- snacks.nvim — toggles (Snacks.toggle.*:map)
	{ "<leader>ua", "n", "plugin:snacks", "Toggle animations" },
	{ "<leader>ub", "n", "plugin:snacks", "Toggle dark/light background" },
	{ "<leader>uc", "n", "plugin:snacks", "Toggle conceallevel (0 <-> 2)" },
	{ "<leader>ud", "n", "plugin:snacks", "Toggle diagnostics display" },
	{ "<leader>uD", "n", "plugin:snacks", "Toggle dim mode" },
	{ "<leader>ug", "n", "plugin:snacks", "Toggle indent guides" },
	{ "<leader>uh", "n", "plugin:snacks", "Toggle profiler highlights" },
	{ "<leader>ui", "n", "plugin:snacks", "Toggle LSP inlay hints" },
	{ "<leader>ul", "n", "plugin:snacks", "Toggle absolute/relative line numbers" },
	{ "<leader>uL", "n", "plugin:snacks", "Toggle relative number" },
	{ "<leader>up", "n", "plugin:snacks", "Toggle profiler" },
	{ "<leader>us", "n", "plugin:snacks", "Toggle spelling" },
	{ "<leader>uS", "n", "plugin:snacks", "Toggle smooth scrolling" },
	{ "<leader>uT", "n", "plugin:snacks", "Toggle treesitter highlighting" },
	{ "<leader>uw", "n", "plugin:snacks", "Toggle line wrap" },
	{ "<leader>uW", "n", "plugin:snacks", "Toggle LSP word reference highlighting" },
	{ "<leader>uq", "n", "plugin:snacks", "Toggle session saving (persistence)" },

	-- snacks.nvim — profiler
	{ "<leader>dpp", "n", "plugin:snacks", "Profiler: scratch my-own-buffer report" },
	{ "<leader>dps", "n", "plugin:snacks", "Profiler: start" },
	{ "<leader>dpS", "n", "plugin:snacks", "Profiler: stop" },
	{ "<leader>dpt", "n", "plugin:snacks", "Profiler: toggle" },

	-- snacks.nvim — external CLI terminals
	{ "<leader>ya", "n", "plugin:snacks", "Terminal: tuicr (TUI color registry)" },
	{ "<leader>yb", "n", "plugin:snacks", "Terminal: btop (system monitor)" },
	{ "<leader>yc", "n", "plugin:snacks", "Terminal: claude CLI" },
	{ "<leader>yd", "n", "plugin:snacks", "Terminal: lazydocker" },
	{ "<leader>yg", "n", "plugin:snacks", "Terminal: agy (Gemini CLI)" },
	{ "<leader>yG", "n", "plugin:snacks", "Terminal: agy --resume (Gemini CLI resume)" },
	{ "<leader>ym", "n", "plugin:vi-mongo", "Open vi-mongo (MongoDB TUI)" },
	{ "<leader>yp", "n", "plugin:snacks", "Terminal: spotify_player" },
	{ "<leader>yt", "n", "plugin:snacks", "Terminal: taskui (Taskwarrior TUI)" },
	{ "<leader>yy", "n", "plugin:snacks", "Terminal: yazi file explorer" },

	-- snacks.nvim — dashboard preset (buffer-local on dashboard)
	{ "f", "n", "plugin:snacks-dashboard", "Dashboard: find file", "dashboard buffer only" },
	{ "n", "n", "plugin:snacks-dashboard", "Dashboard: new file", "dashboard buffer only" },
	{ "g", "n", "plugin:snacks-dashboard", "Dashboard: find text (grep)", "dashboard buffer only" },
	{ "r", "n", "plugin:snacks-dashboard", "Dashboard: recent files", "dashboard buffer only" },
	{ "s", "n", "plugin:snacks-dashboard", "Dashboard: restore session (persistence)", "dashboard buffer only" },
	{ "u", "n", "plugin:snacks-dashboard", "Dashboard: update plugins (:Pack sync)", "dashboard buffer only" },
	{ "p", "n", "plugin:snacks-dashboard", "Dashboard: open Pack manager", "dashboard buffer only" },

	-- snacks.nvim — netrw enhancement (buffer-local)
	{ "R", "n", "custom", "Netrw: rename/move entry under cursor (with LSP-aware rename)", "netrw buffers only; defined inside snacks config" },

	-- snacks.nvim — LSP code actions
	{ "<leader>ca", "nx", "plugin:snacks", "Code action", "rust buffers: rustaceanvim version wins; native twin gra exists" },
	{ "<leader>co", "n", "plugin:snacks", "Organize imports (apply code action)" },

	-- trouble.nvim
	{ "<leader>xx", "n", "plugin:trouble", "Toggle diagnostics list (Trouble)", "sole owner rev 3 (custom :restart removed — native ZR)" },
	{ "<leader>xX", "n", "plugin:trouble", "Toggle buffer diagnostics (Trouble)" },
	{ "<leader>xq", "n", "plugin:trouble", "Toggle quickfix list (Trouble)", "sole owner rev 3 (custom removed; native: PopUp > Show All Diagnostics, [q/]q)" },

	-- oil.nvim
	{ "<leader>e", "n", "plugin:oil", "Open parent dir in Oil (float+preview); inside Oil buffer: close explorer", "oil buffers only for close" },
	{ "z", "n", "plugin:oil", "Oil buffer: go to parent directory", "oil buffers only" },
	{ "<leader>w", "n", "plugin:oil", "Oil buffer: save edits without confirmation", "oil buffers only; shadows save-file <leader>w there" },

	-- conform.nvim
	{ "<leader>fm", "n", "plugin:conform", "Format buffer (async, LSP fallback)" },

	-- undotree
	{ "<leader>uu", "n", "plugin:undotree", "Toggle undo tree panel" },

	-- mason.nvim
	{ "<leader>m", "n", "plugin:mason", "Open Mason LSP/tool installer UI" },

	-- persistence.nvim
	{ "<leader>qs", "n", "plugin:persistence", "Restore session (current directory)" },
	{ "<leader>qS", "n", "plugin:persistence", "Select / search session" },
	{ "<leader>ql", "n", "plugin:persistence", "Restore last session" },
	{ "<leader>qd", "n", "plugin:persistence", "Stop session saving for this exit" },



	-- overseer.nvim
	{ "<leader>oo", "n", "plugin:overseer", "Toggle task list" },
	{ "<leader>ox", "n", "plugin:overseer", "Close task list" },
	{ "<leader>or", "n", "plugin:overseer", "Run task template" },
	{ "<leader>of", "n", "plugin:overseer", "Run task, output in float" },
	{ "<leader>ov", "n", "plugin:overseer", "Run task, output in vertical split" },
	{ "<leader>oh", "n", "plugin:overseer", "Run task, output in horizontal split" },
	{ "<leader>oc", "nv", "plugin:overseer", "Run shell command as task" },
	{ "<leader>oq", "n", "plugin:overseer", "Task action menu" },
	{ "<leader>ok", "n", "plugin:overseer", "checkhealth overseer" },
	{ "<C-c>", "n", "plugin:overseer", "Overseer list/output & task terminals: close window", "buffer-local" },
	{ "<Esc>", "t", "plugin:overseer", "Task terminal: exit terminal mode (<C-\\><C-n>)", "buffer-local" },
	{ "<Esc><Esc>", "t", "plugin:overseer", "Task terminal: exit terminal mode", "buffer-local" },
	{ "<C-h>", "t", "plugin:overseer", "Task terminal: go to left window", "buffer-local" },
	{ "<C-j>", "t", "plugin:overseer", "Task terminal: go to window below", "buffer-local" },
	{ "<C-k>", "t", "plugin:overseer", "Task terminal: go to window above", "buffer-local" },
	{ "<C-l>", "t", "plugin:overseer", "Task terminal: go to right window", "buffer-local" },
	{ "<C-q>", "t", "plugin:overseer", "Task terminal: close window", "buffer-local" },

	-- neotest
	{ "<leader>ta", "n", "plugin:neotest", "Attach to nearest test run" },
	{ "<leader>tt", "n", "plugin:neotest", "Run tests in current file" },
	{ "<leader>tT", "n", "plugin:neotest", "Run all test files in cwd" },
	{ "<leader>tr", "n", "plugin:neotest", "Run nearest test" },
	{ "<leader>tl", "n", "plugin:neotest", "Re-run last test" },
	{ "<leader>ts", "n", "plugin:neotest", "Toggle test summary tree" },
	{ "<leader>to", "n", "plugin:neotest", "Show test output (enter)" },
	{ "<leader>tO", "n", "plugin:neotest", "Toggle test output panel" },
	{ "<leader>tS", "n", "plugin:neotest", "Stop running tests" },
	{ "<leader>tw", "n", "plugin:neotest", "Toggle watch mode on file" },

	-- refactoring.nvim
	{ "<leader>re", "nv", "plugin:refactoring", "Pick refactor operation from list" },
	{ "<leader>rf", "v", "plugin:refactoring", "Extract function from selection" },
	{ "<leader>rv", "v", "plugin:refactoring", "Extract variable from selection" },
	{ "<leader>ri", "nv", "plugin:refactoring", "Inline variable" },
	{ "<leader>rb", "n", "plugin:refactoring", "Extract block" },
	{ "<leader>rP", "n", "plugin:refactoring", "Debug: insert printf statement" },
	{ "<leader>rp", "nv", "plugin:refactoring", "Debug: print variable (global again — kulala scoped to http buffers rev 3)" },
	{ "<leader>rc", "n", "plugin:refactoring+kulala", "Global: refactor cleanup debug prints / In http buffers: send request", "scoped split rev 3" },

	-- kulala.nvim — buffer-local on http buffers since rev 3 (was global,
	-- shadowing refactoring rp/rc; pack.nvim ignores ft on key entries)
	{ "<leader>ra", "n", "plugin:kulala", "HTTP: send all requests in file", "http buffers only" },
	{ "<leader>ri", "n", "plugin:kulala", "HTTP: inspect request", "http buffers only" },
	{ "<leader>rt", "n", "plugin:kulala", "HTTP: toggle headers/body view", "http buffers only" },
	{ "<leader>rn", "n", "plugin:kulala", "HTTP: create/open rest.http in project root", "http buffers only" },

	-- grug-far.nvim
	{ "<leader>sr", "nv", "plugin:grug-far", "Search & replace across project (prefills current ext)" },

	-- obsidian.nvim (markdown ft lazy)
	{ "<leader>ob", "n", "plugin:obsidian", "Obsidian: open today's daily note" },
	{ "<leader>oT", "n", "plugin:obsidian", "Obsidian: apply Today template" },

	-- leetcode.nvim (desc commented out due to pack.nvim keys bug)
	{ "<leader>Ll", "n", "plugin:leetcode", "LeetCode menu (:Leet)" },
	{ "<leader>LL", "n", "plugin:leetcode", "LeetCode problem list" },
	{ "<leader>Lr", "n", "plugin:leetcode", "LeetCode run solution" },
	{ "<leader>Ls", "n", "plugin:leetcode", "LeetCode submit solution" },
	{ "<leader>Ld", "n", "plugin:leetcode", "LeetCode toggle description" },
	{ "<leader>Li", "n", "plugin:leetcode", "LeetCode problem info" },
	{ "<leader>Lc", "n", "plugin:leetcode", "LeetCode open console (testcases)" },

	-- cloak.nvim
	{ "<leader>cK", "n", "plugin:cloak", "Toggle cloaking of secrets (.env etc.)" },
	{ "<leader>ck", "n", "plugin:cloak", "Preview (uncloak) current line" },

	-- arduino
	{ "<leader>Ac", "n", "plugin:arduino-nvim", "Compile Arduino sketch (:!arduino-cli compile)", "arduino buffers only (rev 3)" },
	{ "<leader>Au", "n", "plugin:arduino-nvim", "Upload Arduino sketch (:!arduino-cli upload)", "arduino buffers only (rev 3)" },

	-- crates.nvim (Cargo.toml buffers)
	{ "<leader>Cv", "n", "plugin:crates", "Crates: show versions popup", "Cargo.toml only" },
	{ "<leader>Cf", "n", "plugin:crates", "Crates: show features popup", "Cargo.toml only" },
	{ "<leader>Cd", "n", "plugin:crates", "Crates: show dependencies popup", "Cargo.toml only" },
	{ "<leader>Cu", "n", "plugin:crates", "Crates: update crate version", "Cargo.toml only" },
	{ "<leader>CU", "n", "plugin:crates", "Crates: upgrade crate (major)", "Cargo.toml only" },
	{ "<leader>CD", "n", "plugin:crates", "Crates: open docs.rs documentation", "Cargo.toml only" },
	{ "<leader>Cx", "n", "plugin:crates", "Crates: expand dep to inline table", "Cargo.toml only" },

	-- rustaceanvim (rust buffers)
	{ "K", "n", "plugin:rustaceanvim", "Hover actions (Rust)", "rust buffers; displaces builtin K hover there" },
	{ "<leader>cm", "n", "plugin:rustaceanvim", "Expand macro recursively", "rust buffers" },
	{ "<leader>cC", "n", "plugin:rustaceanvim", "Open Cargo.toml", "rust buffers" },
	{ "<leader>cD", "n", "plugin:rustaceanvim", "Open docs.rs for symbol", "rust buffers" },
	{ "<leader>cM", "n", "plugin:rustaceanvim", "Jump to parent module", "rust buffers" },
	{ "<leader>ce", "n", "plugin:rustaceanvim", "Explain error under cursor", "rust buffers" },
	{ "<leader>cu", "n", "plugin:rustaceanvim", "Runnables (run/test targets picker)", "rust buffers" },
	{ "<leader>cg", "n", "plugin:rustaceanvim", "Debuggables (debug targets picker)", "rust buffers" },

	-- kotlin.nvim (kotlin buffers)
	{ "<leader>cb", "n", "plugin:kotlin", "Kotlin: build project (gradle/maven/kotlinc)", "kotlin ft; overrides snacks cb delete-buffer there" },
	{ "<leader>cr", "n", "plugin:kotlin", "Kotlin: run project/script", "kotlin ft; overrides rename there (native twin grn unaffected)" },
	{ "<leader>ct", "n", "plugin:kotlin", "Kotlin: run tests (gradle/maven)", "kotlin ft" },

	-- nvim-dap + dap-ui
	{ "<leader>db", "n", "plugin:nvim-dap", "Toggle breakpoint" },
	{ "<leader>dB", "n", "plugin:nvim-dap", "Breakpoint with condition prompt" },
	{ "<leader>dc", "n", "plugin:nvim-dap", "Start/continue debugging" },
	{ "<leader>dC", "n", "plugin:nvim-dap", "Run to cursor" },
	{ "<leader>dg", "n", "plugin:nvim-dap", "Go to line (without executing)" },
	{ "<leader>di", "n", "plugin:nvim-dap", "Step into" },
	{ "<leader>dO", "n", "plugin:nvim-dap", "Step out" },
	{ "<leader>do", "n", "plugin:nvim-dap", "Step over" },
	{ "<leader>dj", "n", "plugin:nvim-dap", "Go down stack frame" },
	{ "<leader>dk", "n", "plugin:nvim-dap", "Go up stack frame" },
	{ "<leader>dl", "n", "plugin:nvim-dap", "Run last configuration" },
	{ "<leader>dP", "n", "plugin:nvim-dap", "Pause execution" },
	{ "<leader>dr", "n", "plugin:nvim-dap", "Hover widget / REPL (dap.ui.widgets.hover)" },
	{ "<leader>dw", "n", "plugin:nvim-dap", "Widgets hover (same target as dr)", "duplicate target of dr" },
	{ "<leader>ds", "n", "plugin:nvim-dap", "Debug session control" },
	{ "<leader>dt", "n", "plugin:nvim-dap", "Terminate debug session" },
	{ "<leader>du", "n", "plugin:nvim-dap-ui", "Open DAP UI" },
	{ "<leader>dx", "n", "plugin:nvim-dap-ui", "Close DAP UI" },

	-- cellular-automaton.nvim
	{ "<leader>fml", "n", "plugin:cellular-automaton", "Make it rain animation" },
	{ "<leader>gol", "n", "plugin:cellular-automaton", "Game of Life animation" },

	-- distract.nvim (enabled = false — currently inactive)
	{ "<leader>Dc", "n", "plugin:distract", "Spawn cat on floor", "PLUGIN DISABLED" },
	{ "<leader>Dr", "n", "plugin:distract", "Spawn crab on floor", "PLUGIN DISABLED" },
	{ "<leader>Ds", "n", "plugin:distract", "Spawn sun in sky", "PLUGIN DISABLED" },
	{ "<leader>Dg", "n", "plugin:distract", "Spawn GIF cat 1", "PLUGIN DISABLED" },
	{ "<leader>DG", "n", "plugin:distract", "Spawn GIF cat 2", "PLUGIN DISABLED" },
	{ "<leader>Dj", "n", "plugin:distract", "Cat jumps", "PLUGIN DISABLED" },
	{ "<leader>Dp", "n", "plugin:distract", "Crab clips claws", "PLUGIN DISABLED" },
	{ "<leader>DS", "n", "plugin:distract", "Solar eclipse", "PLUGIN DISABLED" },
	{ "<leader>Dx", "n", "plugin:distract", "Clear entities", "PLUGIN DISABLED" },
	{ "<leader>Dt", "n", "plugin:distract", "Toggle engine", "PLUGIN DISABLED" },
	{ "<leader>D?", "n", "plugin:distract", "Entity status", "PLUGIN DISABLED" },
	{ "<leader>Db", "n", "plugin:distract", "Query backend", "PLUGIN DISABLED" },
	{ "<leader>Dbh", "n", "plugin:distract", "Backend halfblock", "PLUGIN DISABLED" },
	{ "<leader>Dbo", "n", "plugin:distract", "Backend overlay", "PLUGIN DISABLED" },
	{ "<leader>DB", "n", "plugin:distract", "Toggle backend", "PLUGIN DISABLED" },

	-- dbee.nvim
	{ "<leader>De", "n", "plugin:dbee", "Toggle DBee SQL UI" },
	{ "<leader>DE", "n", "plugin:dbee", "Open DBee SQL UI" },
}

--------------------------------------------------------------------------------
-- CONFLICTS / SHADOWED MAPS — collisions worth knowing about (rev 2)
--------------------------------------------------------------------------------
local X = {
	-- RESOLVED in rev 3 (builtins restored): H/L (<S-h>/<S-l> removed), [b ]b,
	-- [B ]B (bufferline keys removed), [t ]t (todo-comments keys removed),
	-- ]d/[d (custom gotod twins removed), <C-L> (custom window-right removed),
	-- <leader>ur (= builtin <C-L>), <leader>xx (native ZR; trouble now sole
	-- owner), <leader>xq (trouble sole owner), gI/gr/gy (snacks pickers
	-- removed; natives grr/gri/grt/gO own them, grd/grD re-added), conform uf/uF dupes.
	{ "<C-a>/<C-x>", "nv", "KEPT", "dial.nvim replaces builtin inc/dec - strict superset (dates, bools, semver)." },
	{ ";/,", "nxo", "KEPT", "treesitter repeatable-move extends builtin f/t repetition to textobject moves." },
	{ "s/S", "nxo", "KEPT+TODO", "flash jump/Treesitter displace builtin substitute char/line (cl/cc survive). flash.lua TODO to rebind or remove." },
	{ "K", "n(rust)", "KEPT", "rustaceanvim hover-actions replace builtin K LSP-hover in Rust buffers only." },
	{ "<leader>cb/cr", "n(kotlin)", "KEPT", "Build/run override snacks delete-buffer & rename inside Kotlin buffers (rename twin grn unaffected)." },
	{ "<leader>e/<leader>w (oil)", "n(oil)", "CONTEXT", "Inside Oil buffers <leader>e closes and <leader>w force-saves, shadowing global meanings there." },
	{ "q", "n", "BUFFER-LOCAL", "Macro record becomes close/quit in help/qf/notify/checkhealth/neotest/grug-far/overseer/dashboard buffers." },
	{ "<C-y>", "i", "CONFLICT", "copilot accept (<C-Y>) vs minuet accept_line (<C-y>) vs builtin insert-char-from-above. Last-loaded wins; ambiguous." },
	{ "<Tab>/<S-Tab>", "is", "SUPERSEDED", "blink snippet_forward/backward supersedes builtin i_/s_ snippet jump (same intent, richer fallback)." },
	{ "<C-k>/<C-e>", "i", "OVERRIDDEN", "builtin digraph entry & insert-char-below replaced by blink signature/dismiss." },
	{ "j/k + n/N + d/x/dd/p/P", "-", "REMAP", "Deliberate customs: display-line moves, ?-paired swapped search dirs, blackhole deletes, ]p/[p paste." },
	{ "> / <", "x", "REMAP", "Indent/unindent keep selection via gv (deliberate)." },
	{ "]]/[[", "nt", "OVERRIDDEN", "snacks.words LSP-reference jumping displaces section motions; INSIDE terminals builtin shell-prompt jumps win back (buffer-local)." },
	{ "<C-s>", "n(term)", "REPLACED", "XOFF flow-control freeze replaced by move-terminal-to-split (buffer-local, good)." },
	{ "<C-w>d ~ <leader>cd", "n", "TWIN", "Both show diagnostic float - consider dropping one." },
	{ "<C-S> ~ <leader>k", "is/n", "TWIN", "Insert-mode builtin signature-help coexists with normal-mode custom <leader>k." },
	{ "gx", "nx", "NEW BUILTIN", "0.12 gx opens URIs/document-links via vim.ui.open - pairs with <leader>gB gitbrowse." },
	{ "grn/gra/grr/gri/grt/grx/gO", "n", "NEW BUILTIN", "0.11+ unconditional LSP maps - now the primary bindings after rev 3 cleanup." },
	{ "an/in/[n/]n/[N/]N", "xo", "NEW BUILTIN", "0.12 incremental node selection - complements ts-textobjects af/if/ac/ic/al/il." },
	{ ":restart / ZR", "cmd/n", "NOTE", "Builtin 0.12: ZR restarts (session kept), [1-8]ZR w/o session, 9ZR ignores changes. Old custom <leader>xx removed as redundant." },
	{ "whisper <M-n>", "niv", "RESOLVED", "Dictation trigger moved off <C-n> (was blocking builtin completion-next & blink select-next)." },
	{ "kulala/arduino ft-keys", "-", "RESOLVED", "pack.nvim silently ignores ft on key entries (KEYMAP_OPTS whitelist) - both now bind buffer-local maps via FileType autocmd." },
	{ "<leader>i/<leader>v", "-", "UNUSED", "which-key declares groups Tips/Venv but nothing maps under them (dead groups)." }
}

--------------------------------------------------------------------------------
-- which-key leader GROUPS (labels only, no mappings)
--------------------------------------------------------------------------------
local G = {
	{ "<leader>A", "Arduino" },
	{ "<leader>b", "Buffer" },
	{ "<leader>c", "Code" },
	{ "<leader>C", "Crates" },
	{ "<leader>d", "Debug" },
	{ "<leader>dp", "Profiler" },
	{ "<leader>D", "Database (SQL) / Distract (disabled)" },
	{ "<leader>f", "Find (implicit)" },
	{ "<leader>g", "Git" },
	{ "<leader>gh", "Hunks" },
	{ "<leader>h", "Health / Harpoon" },
	{ "<leader>i", "Tips (unused group)" },
	{ "<leader>L", "LeetCode" },
	{ "<leader>n", "Notifications (implicit)" },
	{ "<leader>o", "Overseer / Obsidian notes" },
	{ "<leader>p", "Pack + Project" },
	{ "<leader>q", "Quit" },
	{ "<leader>r", "Refactor / REST API" },
	{ "<leader>s", "Search" },
	{ "<leader>t", "Test (Neotest, implicit)" },
	{ "<leader>u", "UI / Toggles" },
	{ "<leader>v", "Venv (unused group)" },
	{ "<leader>w", "Window / Save" },
	{ "<leader>x", "System (trouble/quickfix)" },
	{ "<leader>y", "External CLI terminals (yazi, btop...)" },
	{ "<leader><tab>", "Tabs" },
}

--------------------------------------------------------------------------------
-- Sort helpers + accessors
--------------------------------------------------------------------------------
local function sorted(list)
	local t = {}
	for i = 1, #list do
		t[i] = list[i]
	end
	table.sort(t, function(a, b)
		local ka, kb = a[1]:lower(), b[1]:lower()
		if ka == kb then
			return tostring(a[2]) < tostring(b[2])
		end
		return ka < kb
	end)
	return t
end

M.builtins = sorted(B)
M.custom = sorted(C)
M.plugins = sorted(P)
M.conflicts = sorted(X)
M.groups = sorted(G)

--- Total number of documented mappings (excluding conflicts/groups).
function M.count()
	return #M.builtins + #M.custom + #M.plugins
end

--- Open a scratch buffer rendering everything as markdown tables.
function M.show()
	local lines = {}
	local function add(s)
		lines[#lines + 1] = s
	end
	local function section(title, rows, has_note)
		add("")
		add("# " .. title .. " (" .. #rows .. ")")
		add("")
		add("| Key | Mode | Source | Description | Notes |")
		add("| --- | --- | --- | --- | --- |")
		for _, r in ipairs(rows) do
			local lhs, mode, src, desc = tostring(r[1]), tostring(r[2]), tostring(r[3]), tostring(r[4])
			local note = r[5] and tostring(r[5]) or ""
			if not has_note then
				note = ""
			end
			lhs = lhs:gsub("|", "\\|")
			note = note:gsub("|", "\\|")
			add(string.format("| `%s` | %s | %s | %s | %s |", lhs, mode, src, desc, note))
		end
	end

	add("# Keymap Reference (rev 3 — builtins-first conflict resolution, NVIM 0.12.5)")
	add("")
	add(
		"Total mappings: "
			.. M.count()
			.. " — builtins "
			.. #M.builtins
			.. ", custom "
			.. #M.custom
			.. ", plugin "
			.. #M.plugins
	)
	add("")
	add("Modes: n=normal, i=insert, x=visual, v=visual+select, o=operator-pending, c=cmdline, t=terminal")

	section("Conflicts & Overrides", M.conflicts, true)
	section("Leader Groups (which-key labels)", M.groups, false)
	section("Custom Keymaps", M.custom, true)
	section("Plugin Keymaps", M.plugins, true)
	section("Built-in Keymaps (0.12.5)", M.builtins, true)

	local buf = vim.api.nvim_create_buf(false, true)
	vim.bo[buf].bufhidden = "wipe"
	vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
	vim.bo[buf].filetype = "markdown"
	vim.cmd("split")
	vim.api.nvim_win_set_buf(0, buf)
	vim.wo[0].wrap = false
end

return M
