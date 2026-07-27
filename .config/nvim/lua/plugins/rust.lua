-- rustaceanvim configures itself from `vim.g.rustaceanvim`.
-- Do NOT call require("rustaceanvim").setup(). Set the global BEFORE the
-- plugin's ftplugin runs, hence `init`. rust-analyzer + codelldb are provided
-- via mason (see mason.lua); rustaceanvim auto-detects the mason codelldb for DAP.
return {
	"mrcjkb/rustaceanvim",
	version = "^9",
	ft = { "rust" },
	lazy = false,
	init = function()
		vim.g.rustaceanvim = {
			-- DAP: rustaceanvim auto-detects the mason-installed codelldb.
			-- Leaving `dap` unset keeps that auto-detection.
			tools = {
				float_win_config = { border = "rounded" },
			},
			server = {
				on_attach = function(_, bufnr)
					local function map(lhs, rhs, desc)
						vim.keymap.set("n", lhs, rhs, { buffer = bufnr, desc = desc })
					end
					-- Rust actions live under <leader>c (Code group), buffer-local,
					-- on subkeys that don't collide with the global Refactor (<leader>r) maps.
					map("K", function() vim.cmd.RustLsp({ "hover", "actions" }) end, "Hover actions (Rust)")
					map("<leader>ca", function() vim.cmd.RustLsp("codeAction") end, "Code action (Rust)")
					map("<leader>cm", function() vim.cmd.RustLsp("expandMacro") end, "Expand macro")
					map("<leader>cC", function() vim.cmd.RustLsp("openCargo") end, "Open Cargo.toml")
					map("<leader>cD", function() vim.cmd.RustLsp("openDocs") end, "Open docs.rs")
					map("<leader>cM", function() vim.cmd.RustLsp("parentModule") end, "Parent module")
					map("<leader>ce", function() vim.cmd.RustLsp("explainError") end, "Explain error")
					map("<leader>cu", function() vim.cmd.RustLsp("runnables") end, "Runnables")
					map("<leader>cg", function() vim.cmd.RustLsp("debuggables") end, "Debuggables")
				end,
				default_settings = {
					["rust-analyzer"] = {
						cargo = {
							allFeatures = true,
							loadOutDirsFromCheck = true,
							buildScripts = { enable = true },
						},
						-- Use clippy for on-save checking instead of plain `cargo check`.
						checkOnSave = true,
						check = {
							command = "clippy",
							extraArgs = { "--no-deps" },
						},
						procMacro = {
							enable = true,
							ignored = {
								["async-trait"] = { "async_trait" },
								["napi-derive"] = { "napi" },
								["async-recursion"] = { "async_recursion" },
							},
						},
						inlayHints = {
							bindingModeHints = { enable = false },
							chainingHints = { enable = true },
							closingBraceHints = { enable = true, minLines = 25 },
							closureReturnTypeHints = { enable = "never" },
							lifetimeElisionHints = { enable = "never", useParameterNames = false },
							maxLength = 25,
							parameterHints = { enable = true },
							reborrowHints = { enable = "never" },
							renderColons = true,
							typeHints = {
								enable = true,
								hideClosureInitialization = false,
								hideNamedConstructor = false,
							},
						},
						imports = {
							granularity = { group = "module" },
							prefix = "self",
						},
						files = {
							excludeDirs = { ".git", ".direnv", "target", "node_modules" },
						},
					},
				},
			},
		}

		-- Toolchain bootstrap so a fresh machine is set up from inside nvim.
		-- nvim/mason cannot install the rustc/cargo compiler itself, so this
		-- shells out to brew+rustup. codelldb + bacon still come from mason
		-- (mason-tool-installer runs on startup). Run once per machine.
		vim.api.nvim_create_user_command("RustBootstrap", function()
			local script = table.concat({
				'echo "== Rust toolchain bootstrap =="',
				'command -v brew >/dev/null 2>&1 || { echo "ERROR: Homebrew not found. Install it first: https://brew.sh"; exit 1; }',
				'if ! command -v rustup >/dev/null 2>&1 && [ ! -x "$(brew --prefix rustup)/bin/rustup" ]; then echo "-- installing rustup via brew"; brew install rustup; fi',
				'export PATH="$(brew --prefix rustup)/bin:$PATH"',
				'echo "-- setting default stable toolchain"; rustup default stable',
				'echo "-- adding components"; rustup component add rust-analyzer rust-src clippy rustfmt',
				'echo; echo "Done. codelldb/bacon install via :Mason. Restart shell/nvim so PATH picks up the rustup proxies."',
			}, " && ")
			vim.cmd("botright 18split | enew")
			vim.bo.bufhidden = "wipe"
			vim.fn.jobstart({ "sh", "-lc", script }, { term = true })
			vim.cmd("startinsert")
		end, { desc = "Bootstrap Rust toolchain (rustup + components) via brew" })
	end,
}
