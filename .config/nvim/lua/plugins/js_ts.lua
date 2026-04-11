vim.pack.add({
	"MunifTanjim/nui.nvim",
	"vuki656/package-info.nvim",
})
local utils = require("utils")
utils.lazy_load_ft("package-info", "package.json", function()
	local keys = {
		{ "<leader>Ps", "<cmd>PackageInfoShow<cr>", desc = "Show Package Info" },
		{ "<leader>Ph", "<cmd>PackageInfoHide<cr>", desc = "Hide Package Info" },
		{ "<leader>Pc", "<cmd>PackageInfoChangeVersion<cr>", desc = "Change Package Version" },
		{ "<leader>Pt", "<cmd>PackageInfoToggle<cr>", desc = "Toggle Package Info" },
		{ "<leader>Pd", "<cmd>PackageInfoDelete<cr>", desc = "Delete Package" },
		{ "<leader>Pu", "<cmd>PackageInfoUpdate<cr>", desc = "Update Package" },
		{ "<leader>Pi", "<cmd>PackageInfoInstall<cr>", desc = "Install Package" },
	}
	utils.map_plugin_keys(keys)
end)
