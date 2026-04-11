vim.pack.add({
	{ src = "p00f/clangd_extensions.nvim" },
})

require("clangd_extensions").setup({
	inlay_hints = {
		inline = false,
	},
	ast = {
		--These require codicons (https://github.com/microsoft/vscode-codicons)
		role_icons = {
			type = "",
			declaration = "",
			expression = "",
			specifier = "",
			statement = "",
			["template argument"] = "",
		},
		kind_icons = {
			Compound = "",
			Recovery = "",
			TranslationUnit = "",
			PackExpansion = "",
			TemplateTypeParm = "",
			TemplateTemplateParm = "",
			TemplateParamObject = "",
		},
	},
})
