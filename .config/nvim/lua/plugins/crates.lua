-- Cargo.toml dependency management: version hints, feature toggles, upgrades, docs.
-- Native `vim.lsp.completion` won't feed crates' completion source, but inline
-- version hints, popups and the keymaps below all work.
return {
	"saecki/crates.nvim",
	name = "crates",
	tag = "stable",
	event = { "BufRead Cargo.toml" },
	dependencies = { "nvim-lua/plenary.nvim" },
	config = function()
		require("crates").setup({
			completion = {
				crates = { enabled = false },
			},
			lsp = {
				enabled = true,
				actions = true,
				completion = true,
				hover = true,
			},
		})

		local function set_keymaps(bufnr)
			local crates = require("crates")
			local function map(lhs, rhs, desc)
				vim.keymap.set("n", lhs, rhs, { buffer = bufnr, desc = desc })
			end
			-- Buffer-local to Cargo.toml, under the <leader>C "Crates" group
			-- so nothing collides with the Rust action maps in rust.lua.
			map("<leader>Cv", crates.show_versions_popup, "Crate versions")
			map("<leader>Cf", crates.show_features_popup, "Crate features")
			map("<leader>Cd", crates.show_dependencies_popup, "Crate dependencies")
			map("<leader>Cu", crates.update_crate, "Update crate")
			map("<leader>CU", crates.upgrade_crate, "Upgrade crate")
			map("<leader>CD", crates.open_documentation, "Open crate docs")
			map("<leader>Cx", crates.expand_plain_crate_to_inline_table, "Expand to inline table")
		end

		vim.api.nvim_create_autocmd("BufRead", {
			group = vim.api.nvim_create_augroup("CratesKeymaps", { clear = true }),
			pattern = "Cargo.toml",
			callback = function(ev)
				set_keymaps(ev.buf)
			end,
		})

		-- Apply to the buffer that triggered plugin load.
		if vim.fn.expand("%:t") == "Cargo.toml" then
			set_keymaps(0)
		end
	end,
}
