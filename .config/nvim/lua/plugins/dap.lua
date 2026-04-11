vim.pack.add({
	"theHamsta/nvim-dap-virtual-text",
	"leoluz/nvim-dap-go",

	"nvim-neotest/nvim-nio",
	"rcarriga/nvim-dap-ui",

	"https://github.com/mfussenegger/nvim-dap",
})
local dap_icons = {
	Stopped = { "▶", "DiagnosticWarn", "DapStoppedLine" }, -- current execution point
	Breakpoint = { "", "DiagnosticError" }, -- regular breakpoint
	BreakpointCondition = { "", "DiagnosticInfo" }, -- conditional breakpoint
	BreakpointRejected = { "", "DiagnosticError" }, -- failed breakpoint
	LogPoint = { "◆", "DiagnosticHint" }, -- logpoint
}
local utils = require("utils")
utils.lazy_load_event("dapui", { "BufReadPost" }, function(opts)
	local dap = require("dap")
	local dapui = require("dapui")
	dapui.setup(opts)
	dap.listeners.after.event_initialized["dapui_config"] = function()
		dapui.open({})
	end
	dap.listeners.before.event_terminated["dapui_config"] = function()
		dapui.close({})
	end
	dap.listeners.before.event_exited["dapui_config"] = function()
		dapui.close({})
	end

	vim.keymap.set("n", "<leader>du", function()
		require("dapui").open()
	end, {
		desc = "Open Dap UI ",
	})
end)

        -- stylua: ignore
       local keys = {
            { "<leader>dB", function() require("dap").set_breakpoint(vim.fn.input('Breakpoint condition: ')) end, desc = "Breakpoint Condition" },
            { "<leader>db", function() require("dap").toggle_breakpoint() end,                                    desc = "Toggle Breakpoint" },
            { "<leader>dc", function() require("dap").continue() end,                                             desc = "Run/Continue" },
            { "<leader>dC", function() require("dap").run_to_cursor() end,                                        desc = "Run to Cursor" },
            { "<leader>dg", function() require("dap").goto_() end,                                                desc = "Go to Line (No Execute)" },
            { "<leader>di", function() require("dap").step_into() end,                                            desc = "Step Into" },
            { "<leader>dj", function() require("dap").down() end,                                                 desc = "Down" },
            { "<leader>dk", function() require("dap").up() end,                                                   desc = "Up" },
            { "<leader>dl", function() require("dap").run_last() end,                                             desc = "Run Last" },
            { "<leader>dO", function() require("dap").step_out() end,                                             desc = "Step Out" },
            { "<leader>do", function() require("dap").step_over() end,                                            desc = "Step Over" },
            { "<leader>dP", function() require("dap").pause() end,                                                desc = "Pause" },
            { "<leader>dr", function() require("dap").repl.toggle() end,                                          desc = "Toggle REPL" },
            { "<leader>ds", function() require("dap").session() end,                                              desc = "Session" },
            { "<leader>dt", function() require("dap").terminate() end,                                            desc = "Terminate" },
            { "<leader>dw", function() require("dap.ui.widgets").hover() end,                                     desc = "Widgets" },
        }
utils.map_plugin_keys(keys)

utils.lazy_load_event("dap", "BufReadPost", function()
	local dap, dapui = require("dap"), require("dapui")
	vim.api.nvim_set_hl(0, "DapStoppedLine", { default = true, link = "Visual" })
	-- local web_icons = require("nvim-web-devicons").get_icons()
	-- print(vim.inspect(web_icons))

	for name, sign in pairs(dap_icons) do
		sign = type(sign) == "table" and sign or { sign }
		vim.fn.sign_define("Dap" .. name, {
			text = sign[1],
			texthl = sign[2] or "DiagnosticInfo",
			linehl = sign[3],
			numhl = sign[3],
		})
	end
	local jspath = vim.fn.stdpath("data") .. "/mason/packages/js-debug-adapter/js-debug/src/dapDebugServer.js"
	if not dap.adapters["pwa-node"] then
		require("dap").adapters["pwa-node"] = {
			type = "server",
			host = "localhost",
			port = "${port}",
			executable = {
				command = "node",
				args = {
					jspath,
					"${port}",
				},
			},
		}
	end

	dap.adapters["pwa-chrome"] = {
		type = "server",
		host = "localhost",
		port = "${port}",
		executable = {
			command = "node",
			args = {
				jspath,
				"${port}",
			},
		},
	}

	if not dap.adapters["node"] then
		dap.adapters["node"] = function(cb, config)
			if config.type == "node" then
				config.type = "pwa-node"
			end
			local nativeAdapter = dap.adapters["pwa-node"]
			if type(nativeAdapter) == "function" then
				nativeAdapter(cb, config)
			else
				cb(nativeAdapter)
			end
		end
	end

	local js_filetypes = { "typescript", "javascript", "typescriptreact", "javascriptreact" }

	local vscode = require("dap.ext.vscode")

	vscode.type_to_filetypes["node"] = js_filetypes
	vscode.type_to_filetypes["pwa-node"] = js_filetypes

	for _, language in ipairs(js_filetypes) do
		if not dap.configurations[language] then
			dap.configurations[language] = {
				-- 1. Standard Chrome Debugging
				{
					type = "pwa-chrome",
					request = "launch",
					name = "Launch Chrome (pwa)",
					url = "http://localhost:3000",
					webRoot = "${workspaceFolder}",
					userDataDir = "${workspaceFolder}/.vscode/chrome",
					sourceMaps = true,
				},

				-- 2. Run a single Node/TS file
				{
					type = "pwa-node",
					request = "launch",
					name = "Launch file",
					program = "${file}",
					cwd = "${workspaceFolder}",
					sourceMaps = true,
				},

				-- 3. Attach to a running Node process
				{
					type = "pwa-node",
					request = "attach",
					name = "Attach",
					processId = require("dap.utils").pick_process,
					cwd = "${workspaceFolder}",
					sourceMaps = true,
				},

				-- 4. Next.js: Server-side (Fixed from node-terminal)
				{
					type = "pwa-node",
					request = "launch",
					name = "Next.js: server-side",
					cwd = "${workspaceFolder}",
					runtimeExecutable = "npm",
					runtimeArgs = { "run", "dev" },
					sourceMaps = true,
					resolveSourceMapLocations = {
						"${workspaceFolder}/**",
						"!**/node_modules/**",
					},
					skipFiles = {
						"<node_internals>/**",
						"**/node_modules/**",
					},
				},

				-- 5: Next.js: Client-side
				{
					name = "Next.js: Client-side",
					type = "pwa-chrome",
					request = "launch",
					url = "http://localhost:3000",
					webRoot = "${workspaceFolder}",
					sourceMaps = true,
				},
			}
		end
	end
end)
