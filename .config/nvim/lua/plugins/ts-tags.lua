return {
	"windwp/nvim-ts-autotag",
	ft = {
		"astro",
		"glimmer",
		"handlebars",
		"html",
		"javascript",
		"javascriptreact",
		"markdown",
		"php",
		"svelte",
		"typescript",
		"typescriptreact",
		"vue",
		"xml",
	},
	opts = {
		opts = {
			enable_close = true,
			enable_rename = true,
			enable_close_on_slash = false,
		},
		per_filetype = {
			["html"] = {
				enable_close = false,
			},
		},
	},
}
