return {
	{

		"gbprod/substitute.nvim",
		event = { "BufReadPre", "BufNewFile" },
		config = function()
			local substitute = require("substitute")

			substitute.setup()

			-- set keymaps
			local keymap = vim.keymap -- for conciseness

			keymap.set("n", "s", substitute.operator, { desc = "Substitute with motion" })
			keymap.set("n", "ss", substitute.line, { desc = "Substitute line" })
			keymap.set("n", "S", substitute.eol, { desc = "Substitute to end of line" })
			keymap.set("x", "s", substitute.visual, { desc = "Substitute in visual mode" })
		end,
	},
	{
		"oysandvik94/curl.nvim",
		cmd = { "CurlOpen" },
		dependencies = {
			"nvim-lua/plenary.nvim",
		},
        -- stylua: ignore
        keys = {
            { "<leader>Rc",  function() require("curl").open_curl_tab() end,            mode = { "n" }, desc = "Open a curl tab scoped to the current working directory",        },
            { "<leader>RC",  function() require("curl").open_global_tab() end,          mode = { "n" }, desc = "Open a curl tab with global scope",                              },
            { "<leader>Rsc", function() require("curl").create_scoped_collection() end, mode = { "n" }, desc = "Create or open a collection with a name from user input",        },
            { "<leader>RsC", function() require("curl").create_global_collection() end, mode = { "n" }, desc = "Create or open a global collection with a name from user input", },
            { "<leader>Rpc", function() require("curl").pick_scoped_collection() end,   mode = { "n" }, desc = "Choose a scoped collection and open it",                         },
            { "<leader>RpC", function() require("curl").pick_global_collection() end,   mode = { "n" }, desc = "Choose a global collection and open it",                         },
        },
		config = true,
	},
	{
		"laytan/cloak.nvim",
		event = "VeryLazy",
		lazy = true,
        -- stylua: ignore
		keys = {
			{ "<leader>cK", "<cmd>CloakToggle<cr>",      mode = { "n" }, desc = "Toggle Cloak",         },
			{ "<leader>ck", "<cmd>CloakPreviewLine<cr>", mode = { "n" }, desc = "Enable Cloak Preview", },
		},
		opts = {},
	},
	{
		"epwalsh/obsidian.nvim",
		version = "*",
		lazy = true,
		ft = "markdown",
		dependencies = {
			"nvim-lua/plenary.nvim",
		},
		opts = {
			workspaces = {
				{
					name = "personal",
					path = "~/tldo",
				},
			},
		},
	},
	{
		"wakatime/vim-wakatime",
		lazy = false,
	},
	{
		"ThePrimeagen/harpoon",
		branch = "harpoon2",
		dependencies = { "nvim-lua/plenary.nvim" },
		opts = {
			settings = {
				save_on_toggle = true,
				sync_on_ui_close = true,
			},
		},
        -- stylua: ignore
        config = function(_, opts)
            local harpoon = require("harpoon")
            harpoon:setup(opts)

            -- basic mappings
            local map = vim.keymap.set
            map("n", "<leader>h", function() harpoon:list():add() end, { desc = "Harpoon Add File" })
            map("n", "<leader>H", function() harpoon.ui:toggle_quick_menu(harpoon:list()) end, { desc = "Harpoon Menu" })
            -- direct navigation (slots 1-4)
            map("n", "<leader>1", function() harpoon:list():select(1) end, { desc = "Harpoon File 1" })
            map("n", "<leader>2", function() harpoon:list():select(2) end, { desc = "Harpoon File 2" })
            map("n", "<leader>3", function() harpoon:list():select(3) end, { desc = "Harpoon File 3" })
            map("n", "<leader>4", function() harpoon:list():select(4) end, { desc = "Harpoon File 4" })
        end,
	},
}
