return {
	"laytan/cloak.nvim",
    -- TODO: Implement all previews to use cloak for certain file types
	event = {
		"BufReadPost .env*",
		"BufNewFile .env*",
		"BufReadPost .dev.vars*",
		"BufNewFile .dev.vars*",
		"BufReadPost *.secret*",
		"BufReadPost *.pem",
		"BufReadPost *.key",
		"BufReadPost *.credentials*",
	},
	cmd = { "CloakToggle", "CloakPreviewLine", "CloakEnable", "CloakDisable" },
	keys = {
		{ "<leader>cK", "<cmd>CloakToggle<cr>", mode = { "n" }, desc = "Toggle Cloak" },
		{ "<leader>ck", "<cmd>CloakPreviewLine<cr>", mode = { "n" }, desc = "Enable Cloak Preview" },
	},
	opts = {},
}
