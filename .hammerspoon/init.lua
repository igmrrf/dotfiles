hs.window.animationDuration = 0
hs.grid.setGrid("4x4")
hs.grid.setMargins({ 0, 0 })

local hyper = { "ctrl", "alt", "cmd" }
local hyper_shift = { "ctrl", "alt", "cmd", "shift" }
local lrh = hs.loadSpoon("LeftRightHotkey")
local rCmd = { "rCmd" }

-- RELOAD

if lrh then
	lrh:start()

	lrh:bind(rCmd, "R", function()
		hs.reload()
		hs.alert.show("Config Reloaded", 0.5)
	end)
end
-- REASON
hs.hotkey.bind(hyper, "Q", function()
	hs.notify.new({ title = "The Lazy", informativeText = "Why are you doing this?" }):send()
end)
PaperWM = hs.loadSpoon("PaperWM")
-- focus adjacent window with 3 finger swipe
local actions = PaperWM.actions.actions()
local current_id, threshold
Swipe = hs.loadSpoon("Swipe")
Swipe:start(3, function(direction, distance, id)
	if id == current_id then
		if distance > threshold then
			threshold = math.huge -- trigger once per swipe

			-- use "natural" scrolling
			if direction == "left" then
				actions.focus_right()
			elseif direction == "right" then
				actions.focus_left()
			elseif direction == "up" then
				actions.focus_down()
			elseif direction == "down" then
				actions.focus_up()
			end
		end
	else
		current_id = id
		threshold = 0.2 -- swipe distance > 20% of trackpad size
	end
end)
-- Add this to your init.lua to manually fix the layout
hs.hotkey.bind({ "alt", "cmd", "shift" }, "R", function()
	PaperWM:tileSpace(hs.spaces.focusedSpace())
end)
-- Paper

PaperWM:bindHotkeys({
	-- switch to a new focused window in tiled grid
	focus_left = { hyper, "h" },
	focus_right = { hyper, "l" },
	focus_up = { hyper, "k" },
	focus_down = { hyper, "j" },

	-- switch windows by cycling forward/backward
	-- (forward = down or right, backward = up or left)
	focus_prev = { hyper, "p" },
	focus_next = { hyper, "n" },

	-- move windows around in tiled grid
	swap_left = { hyper_shift, "h" },
	swap_right = { hyper_shift, "l" },
	swap_up = { hyper_shift, "k" },
	swap_down = { hyper_shift, "j" },

	-- position and resize focused window
	center_window = { hyper, "c" },
	full_width = { hyper, "m" },
	cycle_width = { hyper, "r" },

	reverse_cycle_width = { { "ctrl", "alt", "cmd" }, "r" },
	cycle_height = { hyper_shift, "r" },
	reverse_cycle_height = { { "ctrl", "alt", "cmd", "shift" }, "r" },

	-- increase/decrease width
	increase_width = { hyper, "=" },
	decrease_width = { hyper, "-" },

	-- move focused window into / out of a column
	slurp_in = { hyper, "i" },
	barf_out = { hyper, "o" },

	-- split screen focused window with left window
	split_screen = { hyper, "s" },

	-- move the focused window into / out of the tiling layer
	toggle_floating = { hyper, "escape" },
	-- raise all floating windows on top of tiled windows
	focus_floating = { hyper, "f" },

	-- focus the first / second / etc window in the current space
	focus_window_1 = { hyper, "1" },
	focus_window_2 = { hyper, "2" },
	focus_window_3 = { hyper, "3" },
	focus_window_4 = { hyper, "4" },
	focus_window_5 = { hyper, "5" },
	focus_window_6 = { hyper, "6" },
	focus_window_7 = { hyper, "7" },
	focus_window_8 = { hyper, "8" },
	focus_window_9 = { hyper, "9" },

	-- -- switch to a new Mission Control space
	-- switch_space_l = { hyper_shift, "," },
	-- switch_space_r = { hyper_shift, "." },
	-- switch_space_1 = { hyper_shift, "1" },
	-- switch_space_2 = { hyper_shift, "2" },
	-- switch_space_3 = { hyper_shift, "3" },
	-- switch_space_4 = { hyper_shift, "4" },
	-- switch_space_5 = { hyper_shift, "5" },
	-- switch_space_6 = { hyper_shift, "6" },
	-- switch_space_7 = { hyper_shift, "7" },
	-- switch_space_8 = { hyper_shift, "8" },
	-- switch_space_9 = { hyper_shift, "9" },

	-- move focused window to a new space and tile
	move_window_1 = { hyper_shift, "1" },
	move_window_2 = { hyper_shift, "2" },
	move_window_3 = { hyper_shift, "3" },
	move_window_4 = { hyper_shift, "4" },
	move_window_5 = { hyper_shift, "5" },
	move_window_6 = { hyper_shift, "6" },
	move_window_7 = { hyper_shift, "7" },
	move_window_8 = { hyper_shift, "8" },
	move_window_9 = { hyper_shift, "9" },
})
PaperWM:start()

WarpMouse = hs.loadSpoon("WarpMouse")
WarpMouse.margin = 8 -- optionally set how far past a screen edge the mouse should warp, default is 2 pixels
WarpMouse:start()
ActiveSpace = hs.loadSpoon("ActiveSpace")
ActiveSpace.compact = true
ActiveSpace:start()
