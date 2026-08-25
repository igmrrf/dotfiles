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
		"DistractRender",
	},
	config = function(_, opts)
		require("distract").setup(opts)
	end,
    --stylua: ignore
	opts = {
		backend = "overlay",
		fps = 30,
		idle_timeout_ms = 5000,
		debounce_ms = 50,
		position = {
			anchor = "bottom",
			ground = "screen",
			parallax = { per_unit = 0.1, min = 0.075, max = 0.5 },
		},
		render = {
			mode = "2d",
			voxel_max_width = 16,
			voxel_depth = 4,
			yaw_degrees = 22.0,
		},
		assets = {
			gif_cat = {
				name = "gif_cat",
				asset_type = "sprite",
				spritesheet = {
					path = "~/Desktop/tmp/distract.nvim/assets/cat_walking_1.gif",
					frame_width = 20,
					frame_height = 15,
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
					path = "~/Desktop/tmp/distract.nvim/assets/cat_walking_2.gif",
					frame_width = 24,
					frame_height = 14,
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
				if not distract.is_running() then
					distract.start()
				end
				local row_coordinate = math.max(0, vim.o.lines - 4)
				local column_coordinate = math.floor(vim.o.columns * 0.1)
				distract.spawn("cat", { x = column_coordinate, y = row_coordinate, z = -4 })
			end,
			desc = "Distract: Spawn Cat (Compact Floor)",
		},
		{
			"<leader>Dr",
			function()
				local distract = require("distract")
				if not distract.is_running() then
					distract.start()
				end
				local row_coordinate = math.max(0, vim.o.lines - 4)
				local column_coordinate = math.floor(vim.o.columns * 0.1)
				distract.spawn("crab", { x = column_coordinate, y = row_coordinate, z = -4 })
			end,
			desc = "Distract: Spawn Crab (Compact Floor)",
		},
		{
			"<leader>Ds",
			function()
				local distract = require("distract")
				if not distract.is_running() then
					distract.start()
				end
				local row_coordinate = 2
				local column_coordinate = math.floor(vim.o.columns * 0.8)
				distract.spawn("sun", { x = column_coordinate, y = row_coordinate, z = -4 })
			end,
			desc = "Distract: Spawn Sun (Compact Sky)",
		},
		{
			"<leader>Dg",
			function()
				local distract = require("distract")
				if not distract.is_running() then
					distract.start()
				end
				local row_coordinate = math.max(0, vim.o.lines - 4)
				local column_coordinate = math.floor(vim.o.columns * 0.1)
				distract.spawn("gif_cat", { x = column_coordinate, y = row_coordinate, z = -3 })
			end,
			desc = "Distract: Spawn GIF Cat 1 (Compact Floor)",
		},
		{
			"<leader>DG",
			function()
				local distract = require("distract")
				if not distract.is_running() then
					distract.start()
				end
				local row_coordinate = math.max(0, vim.o.lines - 4)
				local column_coordinate = math.floor(vim.o.columns * 0.1)
				distract.spawn("gif_cat_2", { x = column_coordinate, y = row_coordinate, z = -3 })
			end,
			desc = "Distract: Spawn GIF Cat 2 (Compact Floor)",
		},
		{
			"<leader>DW",
			function()
				local distract = require("distract")
				if not distract.is_running() then
					distract.start()
				end
				local row_coordinate = math.max(0, vim.o.lines - 4)
				local column_coordinate = math.floor(vim.o.columns * 0.1)
				distract.spawn("cat_walking", { x = column_coordinate, y = row_coordinate, z = -4 })
			end,
			desc = "Distract: Spawn Cat Walking (Compact Floor)",
		},
		{
			"<leader>D3",
			function()
				local distract = require("distract")
				local current_render = distract.get_render()
				local next_mode = (current_render.mode == "3d") and "2d" or "3d"
				distract.set_render({ mode = next_mode, voxel_max_width = 16, voxel_depth = 4 })
				if not distract.is_running() then
					distract.start()
				end
				vim.notify(string.format("[Distract] Render mode switched to '%s'", next_mode), vim.log.levels.INFO)
			end,
			desc = "Distract: Toggle 2D/3D Render Engine",
		},
		{
			"<leader>D3s",
			function()
				local distract = require("distract")
				distract.set_render({ mode = "3d", voxel_max_width = 16, voxel_depth = 4, yaw_degrees = 22.0 })
				if not distract.is_running() then
					distract.start()
				end
				local row_coordinate = math.max(0, vim.o.lines - 4)
				local column_coordinate = math.floor(vim.o.columns * 0.1)
				distract.spawn("cat", { x = column_coordinate, y = row_coordinate, z = -4 })
			end,
			desc = "Distract: Render 3D Sprite (Compact)",
		},
		{
			"<leader>Dk",
			function()
				local distract = require("distract")
				if not distract.is_running() then
					distract.start()
				end
				local row_coordinate = math.max(0, vim.o.lines - 4)
				local column_coordinate = math.floor(vim.o.columns * 0.1)
				distract.spawn("gudong", { x = column_coordinate, y = row_coordinate, z = -5 })
			end,
			desc = "Distract: Spawn Gudong (Compact Codex Pet)",
		},
		{
			"<leader>Dki",
			function()
				local distract = require("distract")
				if not distract.is_running() then
					distract.start()
				end
				local row_coordinate = math.max(0, vim.o.lines - 4)
				local column_coordinate = math.floor(vim.o.columns * 0.1)
				distract.spawn("iris", { x = column_coordinate, y = row_coordinate, z = -5 })
			end,
			desc = "Distract: Spawn Iris (Compact Codex Pet)",
		},
		{
			"<leader>Dkm",
			function()
				local distract = require("distract")
				if not distract.is_running() then
					distract.start()
				end
				local row_coordinate = math.max(0, vim.o.lines - 10)
				local column_coordinate = math.floor(vim.o.columns * 0.1)
				distract.spawn("minty", { x = column_coordinate, y = row_coordinate, z = -5 })
			end,
			desc = "Distract: Spawn Minty (Compact Codex Pet)",
		},
		{
			"<leader>D3k",
			function()
				local distract = require("distract")
				distract.set_render({ mode = "3d", voxel_max_width = 16, voxel_depth = 4, yaw_degrees = 22.0 })
				if not distract.is_running() then
					distract.start()
				end
				local row_coordinate = math.max(0, vim.o.lines - 4)
				local column_coordinate = math.floor(vim.o.columns * 0.1)
				distract.spawn("gudong", { x = column_coordinate, y = row_coordinate, z = -5 })
			end,
			desc = "Distract: Render 3D Gudong (Compact Codex Pet)",
		},
		{ "<leader>Dj", "<cmd>DistractAction jump cat<cr>", desc = "Distract: Cat Jump" },
		{ "<leader>Dp", "<cmd>DistractAction clip crab<cr>", desc = "Distract: Crab Clip Claws" },
		{ "<leader>DS", "<cmd>DistractAction eclipse sun<cr>", desc = "Distract: Solar Eclipse" },
		{ "<leader>Dkw", "<cmd>DistractAction wave gudong<cr>", desc = "Distract: Gudong Wave" },
		{ "<leader>Dkj", "<cmd>DistractAction jump gudong<cr>", desc = "Distract: Gudong Jump" },
		{ "<leader>Dkr", "<cmd>DistractAction review gudong<cr>", desc = "Distract: Gudong Review" },
		{ "<leader>Dkf", "<cmd>DistractAction fail gudong<cr>", desc = "Distract: Gudong Fail" },
		{ "<leader>Dx", "<cmd>DistractClear<cr>", desc = "Distract: Clear Entities" },
		{ "<leader>Dt", "<cmd>DistractToggle<cr>", desc = "Distract: Toggle Engine" },
		{ "<leader>D?", "<cmd>DistractStatus<cr>", desc = "Distract: Entity Status" },
		{ "<leader>DR", "<cmd>DistractRender<cr>", desc = "Distract: Query Render Settings" },
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
