vim.pack.add({
	"https://github.com/nvim-neotest/nvim-nio",
	"https://github.com/nvim-neotest/neotest-jest",
	"https://github.com/marilari88/neotest-vitest",
	"https://github.com/nvim-neotest/neotest-python",
	"https://github.com/lawrence-laz/neotest-zig",
	"https://github.com/fredrikaverpil/neotest-golang",

	{ src = "https://github.com/mrcjkb/rustaceanvim" },
	{ src = "https://github.com/nvim-neotest/neotest" },
})

require("neotest").setup({
	adapters = {
		["neotest-jest"] = {
			jestCommand = "npm test --",
			jestConfigFile = "custom.jest.config.ts",
			env = { CI = true },
			cwd = function(path)
				return vim.fn.getcwd()
			end,
		},
		["neotest-zig"] = {},
		["neotest-vitest"] = {},
		["rustaceanvim.neotest"] = {},
		["neotest-python"] = {},
		["neotest-golang"] = {
			-- Here we can set options for neotest-golang, e.g.
			-- go_test_args = { "-v", "-race", "-count=1", "-timeout=60s" },
			dap_go_enabled = true, -- requires leoluz/nvim-dap-go
		},
	},
})
