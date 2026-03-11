local MoveWindow = require("modes/w_move")
local FocusWindow = require("modes/w_focus")
--
-- local LeftRightHotkey = hs.loadSpoon("LeftRightHotkey")
--
-- if LeftRightHotkey then
-- 	LeftRightHotkey:bind({}, "rCmd", "t", function()
-- 		hs.alert.show("Right Command + T pressed")
-- 	end)
-- end
--
hs.window.animationDuration = 0
hs.grid.setGrid("4x4")
hs.grid.setMargins({ 0, 0 })

local hyper = { "ctrl", "alt", "shift", "cmd" }
local lrh = hs.loadSpoon("LeftRightHotkey")
local rCmd = { "rCmd" }

-- RELOAD

if lrh then
	lrh:start()

	lrh:bind(rCmd, "R", function()
		hs.reload()
		hs.alert.show("Config Reloaded", 0.5)
	end)

	MoveWindow(hs, rCmd, hyper, lrh)
	FocusWindow(hs, rCmd, hyper, lrh)
end

-- REASON
hs.hotkey.bind(hyper, "Q", function()
	hs.notify.new({ title = "The Lazy", informativeText = "Why are you doing this?" }):send()
end)
