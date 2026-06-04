vim.pack.add({
	{ src = "https://github.com/igmrrf/Arduino-Nvim" },
	{ src = "https://github.com/nvim-telescope/telescope.nvim" },
	{ src = "https://github.com/igmrrf/arduino_nvim", name = "arduino_nvim" },
})

vim.cmd.packadd("arduino_nvim")
require("arduino-nvim").setup({
	mode = "float", -- or "buffer"
	float_opts = {
		width = 0.8,
		height = 0.8,
		border = "rounded",
		title = " Arduino TUI ",
	},
})
-- vim.cmd.packadd("telescope.nvim")
local utils = require("utils")

utils.lazy_load_ft("Arduino-Nvim", { "arduino" }, function()
	-- vim.api.nvim_create_user_command("CompileSketch", function()
	-- 	os.execute("arduino-cli compile")
	-- end, {
	-- 	desc = "Compile arduino sketch",
	-- })
	--
	-- vim.api.nvim_create_user_command("UploadSketch", function()
	-- 	vim.fn.jobstart("arduino-cli upload", {
	-- 		on_stdout = function(chan_id, data, name)
	-- 			print("Output: " .. table.concat(data, "\n"))
	-- 			print("Name: " .. name .. " Chan: " .. chan_id)
	-- 		end,
	-- 		on_exit = function(chan_id, code, name)
	-- 			print("Process finished with code" .. code)
	-- 			print("Name: " .. name .. " Chan: " .. chan_id)
	-- 		end,
	-- 	})
	-- end, {
	-- 	desc = "Upload arduino sketch",
	-- })

	vim.keymap.set("n", "<leader>Ac", ":!arduino-cli compile<CR>", { desc = "Compile arduino sketch" })
	vim.keymap.set("n", "<leader>Au", ":!arduino-cli upload<CR>", { desc = "Upload arduino sketch" })
	require("Arduino-Nvim").setup({ picker = "telescope" })
end)
