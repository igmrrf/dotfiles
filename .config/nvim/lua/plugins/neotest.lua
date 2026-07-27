return {
	"nvim-neotest/neotest",
	name = "neotest",
	lazy = true,
	dependencies = {
		"nvim-neotest/nvim-nio",
		"nvim-neotest/neotest-plenary",
		"rcasia/neotest-bash",
		"volodya-lombrozo/neotest-ruby-minitest",
		"nvim-neotest/neotest-jest",
		"nvim-neotest/neotest-python",
		"lawrence-laz/neotest-zig",
		"fredrikaverpil/neotest-golang",
		"arthur944/neotest-bun",
		"leoluz/nvim-dap-go",
		"antoinemadec/FixCursorHold.nvim",
		"mrcjkb/rustaceanvim",
	},
	config = function()
		require("neotest").setup({
			adapters = {
				require("neotest-plenary"),
				require("neotest-bash"),
				require("neotest-ruby-minitest"),
				require("neotest-jest")({
					jestCommand = "npm test --",
					jestConfigFile = "custom.jest.config.ts",
					env = { CI = true },
				}),
				require("neotest-python"),
				require("neotest-zig"),
				require("neotest-golang")({
					dap_go_enabled = true,
				}),
				require("rustaceanvim.neotest"),
				require("neotest-bun"),
			},
		})
	end,
	keys = {
		{ "<leader>ta", function() require("neotest").run.attach() end, desc = "Attach to Test (Neotest)" },
		{ "<leader>tt", function() require("neotest").run.run(vim.fn.expand("%")) end, desc = "Run File (Neotest)" },
		{ "<leader>tT", function() require("neotest").run.run(vim.uv.cwd()) end, desc = "Run All Test Files (Neotest)" },
		{ "<leader>tr", function() require("neotest").run.run() end, desc = "Run Nearest (Neotest)" },
		{ "<leader>tl", function() require("neotest").run.run_last() end, desc = "Run Last (Neotest)" },
		{ "<leader>ts", function() require("neotest").summary.toggle() end, desc = "Toggle Summary (Neotest)" },
		{ "<leader>to", function() require("neotest").output.open({ enter = true, auto_close = true }) end, desc = "Show Output (Neotest)" },
		{ "<leader>tO", function() require("neotest").output_panel.toggle() end, desc = "Toggle Output Panel (Neotest)" },
		{ "<leader>tS", function() require("neotest").run.stop() end, desc = "Stop (Neotest)" },
		{ "<leader>tw", function() require("neotest").watch.toggle(vim.fn.expand("%")) end, desc = "Toggle Watch (Neotest)" },
	},
}
