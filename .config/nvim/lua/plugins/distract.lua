return {
	"igmrrf/distract.nvim",
	-- Lazy load on command invocation or keys
	cmd = {
		"DistractStart",
		"DistractStop",
		"DistractToggle",
		"DistractSpawn",
		"DistractAction",
		"DistractClear",
		"DistractStatus",
		"DistractBackend",
		"DistractBuild",
	},
	-- Configuration passed to require("distract").setup(opts)
	opts = {
		-- "halfblock" (In-terminal 24-bit Truecolor half-block renderer - default)
		-- "overlay"   (Hardware-accelerated GPU desktop overlay via Rust engine)
		backend = "kitty",
		fps = 30,
		idle_timeout_ms = 5000, -- Time before pets fall asleep (5s)
		debounce_ms = 50, -- Keystroke event throttling
		-- cell_width = nil,  -- Overlay only: explicit cell pixel width for HiDPI
		-- cell_height = nil, -- Overlay only: explicit cell pixel height for HiDPI
        --stylua: ignore
		assets = {
			gif_cat = {
				name = "gif_cat",
				asset_type = "sprite",
				spritesheet = {
					path = "~/Desktop/packages/distract.nvim/assets/cat_walking_1_scaled.gif",
				},
				initial_state = "idle",
				states = {
					idle = {
						animation = { frames = { 0 }, fps = 1.0, loop_anim = true },
						physics = { target_vx = 0.0, wrap_mode = "clamp" },
						transitions = {
							on_event = { typing = "run", moving = "walk" },
						},
					},
					walk = {
						animation = {
							frames = { 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14 },
							fps = 6.0,
							loop_anim = true,
						},
						physics = { target_vx = 0.5, wrap_mode = "bounce" },
						transitions = {
							on_event = { typing = "run", idle = "idle" },
							timeout_ms = 4000,
							on_timeout = "idle",
						},
					},
					run = {
						animation = {
							frames = { 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14 },
							fps = 12.0,
							loop_anim = true,
						},
						physics = { target_vx = 1.1, wrap_mode = "bounce" },
						transitions = {
							timeout_ms = 1500,
							on_timeout = "walk",
							on_event = { idle = "idle" },
						},
					},
				},
			},
			gif_cat_2 = {
				name = "gif_cat_2",
				asset_type = "sprite",
				spritesheet = {
					path = "~/Desktop/packages/distract.nvim/assets/cat_walking_2_scaled.gif",
				},
				initial_state = "idle",
				states = {
					idle = {
						animation = { frames = { 0 }, fps = 1.0, loop_anim = true },
						physics = { target_vx = 0.0, wrap_mode = "clamp" },
						transitions = {
							on_event = { typing = "run", moving = "walk" },
						},
					},
					walk = {
						animation = {
							frames = {
								0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15,
								16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31,
							},
							fps = 8.0,
							loop_anim = true,
						},
						physics = { target_vx = 0.6, wrap_mode = "bounce" },
						transitions = {
							on_event = { typing = "run", idle = "idle" },
							timeout_ms = 4000,
							on_timeout = "idle",
						},
					},
					run = {
						animation = {
							frames = {
								0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15,
								16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31,
							},
							fps = 16.0,
							loop_anim = true,
						},
						physics = { target_vx = 1.2, wrap_mode = "bounce" },
						transitions = {
							timeout_ms = 1500,
							on_timeout = "walk",
							on_event = { idle = "idle" },
						},
					},
				},
			},
		},
	},
	-- Keymaps managed directly by pack.nvim
	keys = {
		{
			"<leader>Dc",
			function()
				local distract = require("distract")
				local y = math.max(0, vim.o.lines - 6)
				local x = math.floor(vim.o.columns * 0.1)
				if distract.is_overlay() then
					local cw, ch = require("distract.external").cell_size()
					distract.spawn("cat", { x = x * cw, y = y * ch })
				else
					distract.spawn("cat", { x = x, y = y })
				end
			end,
			desc = "Distract: Spawn Cat (Floor)",
		},
		{
			"<leader>Dr",
			function()
				local distract = require("distract")
				local y = math.max(0, vim.o.lines - 6)
				local x = math.floor(vim.o.columns * 0.1)
				if distract.is_overlay() then
					local cw, ch = require("distract.external").cell_size()
					distract.spawn("crab", { x = x * cw, y = y * ch })
				else
					distract.spawn("crab", { x = x, y = y })
				end
			end,
			desc = "Distract: Spawn Crab (Floor)",
		},
		{
			"<leader>Ds",
			function()
				local distract = require("distract")
				local y = 3
				local x = math.floor(vim.o.columns * 0.7)
				if distract.is_overlay() then
					local cw, ch = require("distract.external").cell_size()
					distract.spawn("sun", { x = x * cw, y = y * ch })
				else
					distract.spawn("sun", { x = x, y = y })
				end
			end,
			desc = "Distract: Spawn Sun (Sky)",
		},
		{
			"<leader>Dg",
			function()
				local distract = require("distract")
				local y = math.max(0, vim.o.lines - 6)
				local x = math.floor(vim.o.columns * 0.1)
				if distract.is_overlay() then
					local cw, ch = require("distract.external").cell_size()
					distract.spawn("gif_cat", { x = x * cw, y = y * ch })
				else
					distract.spawn("gif_cat", { x = x, y = y })
				end
			end,
			desc = "Distract: Spawn GIF Cat 1 (Floor)",
		},
		{
			"<leader>DG",
			function()
				local distract = require("distract")
				local y = math.max(0, vim.o.lines - 6)
				local x = math.floor(vim.o.columns * 0.1)
				if distract.is_overlay() then
					local cw, ch = require("distract.external").cell_size()
					distract.spawn("gif_cat_2", { x = x * cw, y = y * ch })
				else
					distract.spawn("gif_cat_2", { x = x, y = y })
				end
			end,
			desc = "Distract: Spawn GIF Cat 2 (Floor)",
		},
		{ "<leader>Dj", "<cmd>DistractAction jump cat<cr>", desc = "Distract: Cat Jump" },
		{ "<leader>Dp", "<cmd>DistractAction clip crab<cr>", desc = "Distract: Crab Clip Claws" },
		{ "<leader>DS", "<cmd>DistractAction eclipse sun<cr>", desc = "Distract: Solar Eclipse" },
		{ "<leader>Dx", "<cmd>DistractClear<cr>", desc = "Distract: Clear Entities" },
		{ "<leader>Dt", "<cmd>DistractToggle<cr>", desc = "Distract: Toggle Engine" },
		{ "<leader>D?", "<cmd>DistractStatus<cr>", desc = "Distract: Entity Status" },
		{ "<leader>Dbh", "<cmd>DistractBackend halfblock<cr>", desc = "Distract: Backend Halfblock" },
		{ "<leader>Dbo", "<cmd>DistractBackend overlay<cr>", desc = "Distract: Backend Overlay" },
		{
			"<leader>DB",
			function()
				local distract = require("distract")
				local current = distract.get_backend()
				local next_backend = (current == "halfblock") and "overlay" or "halfblock"
				distract.set_backend(next_backend)
			end,
			desc = "Distract: Toggle Backend",
		},
		{ "<leader>Db", "<cmd>DistractBackend<cr>", desc = "Distract: Query Backend" },
	},
}
