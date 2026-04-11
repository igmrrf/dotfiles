return {
	"glebzlat/arduino-nvim",
	config = {
		function()
			require("arduino-nvim").setup()
		end,
		filetype = "arduino",
	},
}
