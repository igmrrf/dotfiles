return {
	"igmrrf/Arduino-Nvim",
	name = "Arduino-Nvim",
	ft = "arduino",
	dependencies = {
		{ "igmrrf/arduino_nvim", name = "arduino_nvim" },
	},
	config = function()
		require("arduino-nvim").setup({
			mode = "float",
			float_opts = {
				width = 0.8,
				height = 0.8,
				border = "rounded",
				title = " Arduino TUI ",
			},
		})
		require("Arduino-Nvim").setup({ picker = "snacks" })
	end,
	keys = {
		{ "<leader>Ac", ":!arduino-cli compile<CR>", ft = "arduino", desc = "Compile arduino sketch" },
		{ "<leader>Au", ":!arduino-cli upload<CR>", ft = "arduino", desc = "Upload arduino sketch" },
	},
}
