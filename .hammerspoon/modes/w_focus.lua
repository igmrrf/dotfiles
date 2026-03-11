function FocusWindow(hs, rCmd, hyper, lrh)
	local focusMode = hs.hotkey.modal.new()

	local function a_mode()
		focusMode:enter()
	end
	local function x_mode()
		focusMode:exit()
	end

	lrh:bind(rCmd, "F", a_mode)
	hs.hotkey.bind(hyper, "F", a_mode)

	-- This runs when you enter the mode
	function focusMode:entered()
		hs.alert.show("Focus Mode Active", 0.5)
	end

	-- This runs when you exit (Press Escape or the trigger again)
	function focusMode:exited()
		hs.alert.show("Focus Mode Exited", 0.5)
	end

	focusMode:bind({}, "escape", x_mode)

	focusMode:bind(hyper, "F", x_mode)
	focusMode:bind(rCmd, "F", x_mode)

	-- 6. MOVE FOCUS BETWEEN WINDOWS (Vim Style)
	focusMode:bind({}, "L", function()
		hs.window.filter.focusEast()
		focusMode:exit()
	end)

	focusMode:bind({}, "H", function()
		hs.window.filter.focusWest()
		focusMode:exit()
	end)
	focusMode:bind({}, "J", function()
		hs.window.filter.focusSouth()
		focusMode:exit()
	end)

	focusMode:bind({}, "K", function()
		hs.window.filter.focusNorth()
		focusMode:exit()
	end)

	-- 2. MOVE FOCUS BETWEEN DISPLAYS
	focusMode:bind({}, "f", function()
		-- Get the next screen
		local screen = hs.screen.mainScreen():next()

		-- Find the first window on that screen
		local win = hs.window.filter.new(nil):setScreens(screen:id()):getWindows()[1]

		if win then
			win:focus()
			-- Optional: Move mouse to the center of the newly focused window
			local f = win:frame()
			hs.mouse.setAbsolutePosition({ x = f.x + f.w / 2, y = f.y + f.h / 2 })
		else
			-- If no window exists on that screen, just move the mouse to the screen's center
			local rect = screen:fullFrame()
			hs.mouse.setAbsolutePosition({ x = rect.x + rect.w / 2, y = rect.y + rect.h / 2 })
		end

		focusMode:exit()
	end)

	-- Extra config for Window
	hs.hotkey.bind({}, "f14", function()
		hs.eventtap.keyStroke(hyper, "F", 0)
	end)
end

return FocusWindow
