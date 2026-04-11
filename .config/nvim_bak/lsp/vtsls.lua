---@type vim.lsp.Config
return {
	cmd = { "vtsls", "--stdio" },
	init_options = {
		hostInfo = "neovim",
	},
	filetypes = {
		"javascript",
		"javascriptreact",
		"javascript.jsx",
		"typescript",
		"typescriptreact",
		"typescript.tsx",
	},

	settings = {
		complete_function_calls = true,
		vtsls = {
			enableMoveToFileCodeAction = true,
			autoUseWorkspaceTsdk = true,
			experimental = {
				maxInlayHintLength = 30,
				completion = {
					enableServerSideFuzzyMatch = true,
				},
			},
		},
		javascript = {
			updateImportsOnFileMove = { enabled = "always" },
		},
		typescript = {
			updateImportsOnFileMove = {
				enabled = "always",
			},
			suggest = {
				completeFunctionCalls = true,
			},
			inlayHints = {
				enumMemberValues = { enabled = true },
				functionLikeReturnTypes = { enabled = true },
				parameterNames = { enabled = "literals" },
				parameterTypes = { enabled = true },
				propertyDeclarationTypes = { enabled = true },
				variableTypes = { enabled = false },
			},
		},
	},
	root_dir = function(bufnr, on_dir)
		-- The project root is where the LSP can be started from
		-- As stated in the documentation above, this LSP supports monorepos and simple projects.
		-- We select then from the project root, which is identified by the presence of a package
		-- manager lock file.
		local root_markers = { "package-lock.json", "yarn.lock", "pnpm-lock.yaml", "bun.lockb", "bun.lock", "deno.lock" }
		-- Give the root markers equal priority by wrapping them in a table
		root_markers = vim.fn.has("nvim-0.11.3") == 1 and { root_markers } or root_markers
		local project_root = vim.fs.root(bufnr, root_markers)
		if not project_root then
			return
		end

		on_dir(project_root)
	end,
    -- stylua: ignore
    on_attach = function(client, bufnr)
        local function map(mode, lhs, rhs, desc)
            vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, desc = desc })
        end

        -- =========================================================================
        -- IMPORT MANAGEMENT (The "Safe" Way)
        -- =========================================================================
        -- Removes only unused imports (no touchy local variables!)
        map("n", "<leader>cu", function()
            vim.lsp.buf.code_action({
                context = { only = { "source.removeUnusedImports.ts" }, diagnostics = {} },
                apply = true,
            })
        end, "Remove unused imports")

        -- Sorts AND removes unused imports
        map("n", "<leader>co", function()
            vim.lsp.buf.code_action({
                context = { only = { "source.organizeImports.ts" }, diagnostics = {} },
                apply = true,
            })
        end, "Organize/Sort imports")

        -- ONLY sorts imports (keeps unused ones)
        map("n", "<leader>cs", function()
            vim.lsp.buf.code_action({
                context = { only = { "source.sortImports.ts" }, diagnostics = {} },
                apply = true,
            })
        end, "Sort imports only")

        -- Auto-adds all missing imports that have a clear match
        map("n", "<leader>ci", function()
            vim.lsp.buf.code_action({
                context = { only = { "source.addMissingImports.ts" }, diagnostics = {} },
                apply = true,
            })
        end, "Add missing imports")

        -- =========================================================================
        -- GLOBAL CLEANUP (The "Aggressive" Way)
        -- =========================================================================

        -- Replaces your old <leader>cu: Removes unused imports AND local variables
        map("n", "<leader>cX", function()
            vim.lsp.buf.code_action({
                context = { only = { "source.removeUnused.ts" }, diagnostics = {} },
                apply = true,
            })
        end, "Clean ALL unused symbols (Aggressive)")

        -- Applies all automatic fixes (imports, types, variables, etc.)
        map("n", "<leader>cf", function()
            vim.lsp.buf.code_action({
                context = { only = { "source.fixAll.ts" }, diagnostics = {} },
                apply = true,
            })
        end, "Fix all diagnostics")

        -- =========================================================================
        -- UTILITIES & REFACTORING
        -- =========================================================================

        -- Rename file and update all imports project-wide
        map("n", "<leader>cR", function()
            vim.lsp.buf.execute_command({ command = "typescript.renameFile" })
        end, "Rename File & Sync Imports")

        -- Go to source definition (skips .d.ts files)
        map("n", "gS", function()
            vim.lsp.buf.execute_command({ command = "typescript.goToSourceDefinition" })
        end, "Go to Source Definition")

            map("n", "<leader>co", function()
                vim.lsp.buf.execute_command({
                    command = "_typescript.organizeImports",
                    arguments = { vim.api.nvim_buf_get_name(0) },
                })
            end, "Organize Imports")

        -- Select between workspace vs global TS version
        map("n", "<leader>cV", function()
            vim.lsp.buf.execute_command({ command = "typescript.selectTypeScriptVersion" })
        end, "Select TS version")
    end,
}
