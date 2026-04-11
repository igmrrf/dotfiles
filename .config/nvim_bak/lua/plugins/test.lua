return {
	{
		"nvim-neotest/neotest",
		dependencies = {
			"nvim-neotest/nvim-nio",
			"nvim-neotest/neotest-jest",
			"marilari88/neotest-vitest",
			"nvim-neotest/neotest-python",
			"lawrence-laz/neotest-zig",
			"fredrikaverpil/neotest-golang",
			"mrcjkb/rustaceanvim",
		},
		opts = {
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
		},
	},
}
