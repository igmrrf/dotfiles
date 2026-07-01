local wezterm = require("wezterm")
local merge_tables = require("helpers").merge_tables
local action = wezterm.action
local action_callback = wezterm.action_callback
wezterm.plugin.require("https://github.com/abidibo/wezterm-sessions")

local system_keys = {
	-- Pane keys
	{ key = "0", mods = "LEADER", action = action.PaneSelect },
	-- Swap panes
	{ key = "}", mods = "LEADER", action = action.PaneSelect({ mode = "SwapWithActive" }) },
	{ key = "{", mods = "LEADER", action = action.PaneSelect({ mode = "SwapWithActiveKeepFocus" }) },

	-- Move Panes
	-- { key = "[", mods = "LEADER", action = action.PaneSelect({ mode = "MoveToNewWindow" }) },
	-- { key = "]", mods = "LEADER", action = action.PaneSelect({ mode = "MoveToNewTab" }) },
	--
	-- Close panes & tabs
	{ key = "x", mods = "LEADER", action = action.CloseCurrentPane({ confirm = true }) },
	{ key = "X", mods = "LEADER", action = action.CloseCurrentTab({ confirm = true }) },

	-- Splits
	{ key = "\\", mods = "LEADER", action = action.SplitHorizontal({ domain = "CurrentPaneDomain" }) },
	{ key = "-", mods = "LEADER", action = action.SplitVertical({ domain = "CurrentPaneDomain" }) },

	-- Resize panes
	{ key = "h", mods = "CTRL|SHIFT", action = action.AdjustPaneSize({ "Left", 5 }) },
	{ key = "l", mods = "CTRL|SHIFT", action = action.AdjustPaneSize({ "Right", 6 }) },
	{ key = "j", mods = "CTRL|SHIFT", action = action.AdjustPaneSize({ "Down", 5 }) },
	{ key = "k", mods = "CTRL|SHIFT", action = action.AdjustPaneSize({ "Up", 5 }) },

	-- Zoom toggle
	{ key = "m", mods = "LEADER", action = action.TogglePaneZoomState },

	-- Pane navigation
	{ key = "h", mods = "LEADER", action = action.ActivatePaneDirection("Left") },
	{ key = "l", mods = "LEADER", action = action.ActivatePaneDirection("Right") },
	{ key = "j", mods = "LEADER", action = action.ActivatePaneDirection("Down") },
	{ key = "k", mods = "LEADER", action = action.ActivatePaneDirection("Up") },

	-- Copy mode
	{ key = "c", mods = "LEADER", action = action.ActivateCopyMode },

	{
		key = ",",
		mods = "LEADER",
		action = action.PromptInputLine({
			description = "Enter new name for tab",
			action = action_callback(function(window, pane, line)
				if line then
					window:active_tab():set_title(line)
				end
			end),
		}),
	},

	-- Detach from multiplexer
	{ key = "D", mods = "LEADER", action = action.DetachDomain("CurrentPaneDomain") },

	{
		key = "s",
		mods = "LEADER",
		action = action_callback(function(window, pane)
			local workspaces = wezterm.mux.get_workspace_names()
			local current_workspace = wezterm.mux.get_active_workspace()

			for _, ws in ipairs(workspaces) do
				-- Switch to the workspace temporarily so the plugin can read its layout
				window:perform_action(action.SwitchToWorkspace({ name = ws }), pane)
				wezterm.emit("save_session", window)
			end

			-- Switch back to the original workspace
			window:perform_action(action.SwitchToWorkspace({ name = current_workspace }), pane)
			window:toast_notification("WezTerm Sessions", "Saved all workspaces!", nil, 3000)
		end),
	},
	{
		key = "S",
		mods = "LEADER",
		action = action({ EmitEvent = "load_session" }),
	},
	{
		key = "r",
		mods = "LEADER",
		action = action({ EmitEvent = "restore_session" }),
	},
	{
		key = "d",
		mods = "LEADER",
		action = action({ EmitEvent = "delete_session" }),
	},
	{
		key = "e",
		mods = "LEADER",
		action = action({ EmitEvent = "edit_session" }),
	},
	{
		key = "a",
		mods = "LEADER",
		action = action({ EmitEvent = "toggle_autosave" }),
	},
	{
		key = "f",
		mods = "LEADER",
		action = action({ EmitEvent = "fork_session" }),
	},

	-- Rename current workspace
	{
		key = "<",
		mods = "LEADER",
		action = action.PromptInputLine({
			description = "Enter new workspace name",
			action = wezterm.action_callback(function(window, pane, line)
				if line then
					wezterm.mux.rename_workspace(wezterm.mux.get_active_workspace(), line)
				end
			end),
		}),
	},

	{
		key = "p",
		mods = "LEADER",
		action = wezterm.action.SwitchWorkspaceRelative(-1),
	},

	{
		key = "n",
		mods = "LEADER",
		action = wezterm.action.SwitchWorkspaceRelative(1),
	},

	-- Show Tab Navigator (Workspace/Tab UI overlay)
	{
		key = "t",
		mods = "LEADER",
		action = action.ShowTabNavigator,
	},

	-- Fuzzy find workspace and switch or create random
	{
		key = "w",
		mods = "LEADER",
		action = action.ShowLauncherArgs({
			flags = "FUZZY|WORKSPACES",
		}),
	},
	-- Prompt for a name to use for a new workspace and switch to it.
	{
		key = "W",
		mods = "LEADER",
		action = action.PromptInputLine({
			description = wezterm.format({
				{ Attribute = { Intensity = "Bold" } },
				{ Foreground = { AnsiColor = "Fuchsia" } },
				{ Text = "Enter name for new workspace" },
			}),
			action = wezterm.action_callback(function(window, pane, line)
				-- line will be `nil` if they hit escape without entering anything
				-- An empty string if they just hit enter
				-- Or the actual line of text they wrote
				if line then
					window:perform_action(
						action.SwitchToWorkspace({
							name = line,
						}),
						pane
					)
				end
			end),
		}),
	},

	-- Switch to a monitoring workspace, which will have `btop` launched into it
	{
		key = "y",
		mods = "LEADER",
		action = action.SwitchToWorkspace({
			name = "default",
		}),
	},
	-- Switch to a monitoring workspace, which will have `btop` launched into it
	{
		key = "u",
		mods = "LEADER",
		action = action.SwitchToWorkspace({
			name = "monitoring",
			spawn = {
				args = { "/opt/homebrew/bin/btop" },
			},
		}),
	},
}

-- merge_tables(system_keys, resurrect_keys)

return system_keys
