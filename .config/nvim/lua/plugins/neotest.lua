vim.pack.add({
	"https://github.com/nvim-neotest/nvim-nio",
	"https://github.com/nvim-neotest/neotest-plenary",
	"https://github.com/rcasia/neotest-bash",
	"https://github.com/volodya-lombrozo/neotest-ruby-minitest",
	"https://github.com/nvim-neotest/neotest-jest",
	"https://github.com/nvim-neotest/neotest-python",
	"https://github.com/lawrence-laz/neotest-zig",
	"https://github.com/fredrikaverpil/neotest-golang",
	"https://github.com/arthur944/neotest-bun",
	"https://github.com/leoluz/nvim-dap-go",
	"https://github.com/antoinemadec/FixCursorHold.nvim",

	{ src = "https://github.com/mrcjkb/rustaceanvim" },
	{ src = "https://github.com/nvim-neotest/neotest" },
})
vim.cmd.packadd("neotest")
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
			dap_go_enabled = true, -- natively hooks into leoluz/nvim-dap-go
		}),
		require("rustaceanvim.neotest"),
		require("neotest-bun"),
	},
})


-- stylua: ignore
local keys = {
    {"<leader>t", "", desc = "+test"},
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
  }
require("utils").map_plugin_keys(keys)
