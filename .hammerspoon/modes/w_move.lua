function MoveWindow(hs, rCmd, hyper, lrh)
	local winMode = hs.hotkey.modal.new()
	local function a_mode()
		winMode:enter()
	end

	local function x_mode()
		winMode:exit()
	end

	lrh:bind(rCmd, "W", a_mode)
	hs.hotkey.bind(hyper, "W", a_mode)

	-- This runs when you enter the mode
	function winMode:entered()
		hs.alert.show("Window Mode Active", 0.25)
	end

	-- This runs when you exit (Press Escape or the trigger again)
	function winMode:exited()
		hs.alert.show("Window Mode Exited", 0.25)
	end

	winMode:bind({}, "escape", x_mode)

	winMode:bind(rCmd, "W", x_mode)
	winMode:bind(hyper, "W", x_mode)

	winMode:bind({}, "n", function()
		local win = hs.window.focusedWindow()
		local screen = win:screen()
		win:moveToScreen(screen:next())
		winMode:exit() -- if I want to exit mode after one move
	end)

	-- SWap window positions
	winMode:bind({}, "x", function()
		local winA = hs.window.focusedWindow()
		if not winA then
			hs.alert.show("No window A", 0.5)
			winMode:exit() -- if I want to exit mode after one move
			return
		end

		local currentScreen = winA:screen()
		local wf = hs.window.filter.new():setScreens(currentScreen:id())

		print(currentScreen)
		print(wf)

		local winB = winA:windowsToEast(wf, true, true)[1] or winA:windowsToWest(wf, true, true)[1]

		if winB then
			local frameA = winA:frame()
			local frameB = winB:frame()
			winA:setFrame(frameB)
			winB:setFrame(frameA)
		end
		hs.alert.show("No window B", 0.5)
		winMode:exit() -- if I want to exit mode after one move
	end)

	-- 5. QUARTER SCREEN (Top-Left, Top-Right, etc.)
	local quarters = {
		["q"] = "0,0 2x2", -- Top-Left
		["w"] = "2,0 2x2", -- Top-Right
		["a"] = "0,2 2x2", -- Bottom-Left
		["s"] = "2,2 2x2", -- Bottom-Right
	}

	for key, rect in pairs(quarters) do
		winMode:bind({}, key, function()
			local win = hs.window.focusedWindow()
			if win then
				hs.grid.set(win, rect)
				winMode:exit() -- if I want to exit mode after one move
			end
		end)
	end

	-- 4. FULL SCREEN / HALF SCREEN
	local layouts = {
		m = "0,0 4x4", -- full
		h = "0,0 2x4", -- left
		l = "2,0 2x4", -- right
		k = "0,0 4x2", -- top
		j = "0,2 4x2", -- bottom
		c = "1,1 2x2", -- Center
	}

	for key, rect in pairs(layouts) do
		winMode:bind({}, key, function()
			local win = hs.window.focusedWindow()
			if win then
				hs.grid.set(win, rect)
				winMode:exit() -- if I want to exit mode after one move
			end
		end)
	end

	-- EXTRA CONFIG FOR WINDOW
	hs.hotkey.bind({}, "f13", function()
		hs.eventtap.keyStroke(hyper, "W", 0)
	end)
end
return MoveWindow
