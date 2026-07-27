return {
	"vuki656/package-info.nvim",
	ft = "json",
	dependencies = { "MunifTanjim/nui.nvim" },
	opts = {},
	keys = {
		{ "<leader>Ps", "<cmd>PackageInfoShow<cr>", desc = "Show Package Info" },
		{ "<leader>Ph", "<cmd>PackageInfoHide<cr>", desc = "Hide Package Info" },
		{ "<leader>Pc", "<cmd>PackageInfoChangeVersion<cr>", desc = "Change Package Version" },
		{ "<leader>Pt", "<cmd>PackageInfoToggle<cr>", desc = "Toggle Package Info" },
		{ "<leader>Pd", "<cmd>PackageInfoDelete<cr>", desc = "Delete Package" },
		{ "<leader>Pu", "<cmd>PackageInfoUpdate<cr>", desc = "Update Package" },
		{ "<leader>Pi", "<cmd>PackageInfoInstall<cr>", desc = "Install Package" },
	},
}
