# README

[hammerspoon](https://www.hammerspoon.org/docs/index.html)
Configure hammerspoon to replace Aerospace
## Window Actions
- Move between displays
- Move windows to non visible displays
- Swap Window positions (same display)
- Make window full screen
- Make window half screen (top, bottom, left, right)
- Make window quarter screen(top-left,top-right,bottom-left,bottom-right)
- Move focus between windows
- Move focus between displays

Full-Fledged Tiling Window Manager with Hammerspoon
Building on the existing 
init.lua
 configuration (hyperkey, window mode, grid layouts, vim-style focus), this plan adds app focusing, desktop/space switching, window hints, window-to-space movement, resize mode, and a menubar status indicator — all organized into a modular file structure.

User Review Required
IMPORTANT

App Launcher Keybindings: The plan maps Hyper + 1-9 to favorite apps and Hyper + F1-F9 to switch desktops. If you'd prefer a different key scheme (e.g. a separate "App Mode" or "Space Mode" modal), let me know.

WARNING

hs.spaces is experimental: macOS space switching uses private APIs that may break on macOS updates. The gotoSpace() and moveWindowToSpace() functions require "Reduce motion" in Accessibility settings for smooth transitions.

Proposed Changes
Module Structure
The single 
init.lua
 will be split into focused modules under ~/.hammerspoon/modules/. Each module is self-contained and receives shared config via require.

~/.hammerspoon/
├── init.lua              (entry point — requires all modules)
└── modules/
    ├── config.lua        (shared constants: hyperKey, grid settings)
    ├── reload.lua        (auto-reload + manual reload)
    ├── window_mode.lua   (modal window mode: layouts, quarters, center, throw, resize)
    ├── focus.lua         (vim-style directional focus + screen focus)
    ├── app_launcher.lua  (Hyper+number → launch/focus specific apps)
    ├── spaces.lua        (Hyper+F1–F9 → go to desktop, move window to desktop)
    ├── hints.lua         (Hyper+Tab → window hints overlay)
    └── status.lua        (menubar icon showing current mode)
Shared Config
[NEW] 
config.lua
Returns a table with:

hyperKey = {"ctrl", "alt", "shift", "cmd"}
Grid settings: 4x4, margins {0,0}
Animation duration: 0
Auto-Reload
[NEW] 
reload.lua
Extracted from current 
init.lua
:

Hyper+R manual reload
hs.pathwatcher auto-reload on 
.lua
 changes
"Config Reloaded" alert
Window Mode (Enhanced)
[NEW] 
window_mode.lua
Modal activated by Hyper+W, exited by Escape. All bindings stay in mode (no auto-exit).

Key	Action	Grid Cell
m	Maximize (full screen)	0,0 4x4
h	Left half	0,0 2x4
l	Right half	2,0 2x4
k	Top half	0,0 4x2
j	Bottom half	0,2 4x2
q	Top-left quarter	0,0 2x2
w	Top-right quarter	2,0 2x2
a	Bottom-left quarter	0,2 2x2
s	Bottom-right quarter	2,2 2x2
c	Center (50%)	1,1 2x2
n	Throw to next screen	moveOneScreenNext()
p	Throw to prev screen	moveOneScreenEast()/West()
x	Swap with neighbor	existing swap logic
=	Grow window (wider)	increase grid width
-	Shrink window (narrower)	decrease grid width
[	Left third	0,0 1x4 (on 3-col grid)
]	Right third	2,0 1x4 (on 3-col grid)
\	Middle third	1,0 1x4 (on 3-col grid)
1–9	Move window to Space 1–9	hs.spaces.moveWindowToSpace
Escape	Exit mode	—
Resize sub-behavior: = and - grow/shrink the current window frame by 10% of screen width, clamped to screen bounds.

Directional Focus
[NEW] 
focus.lua
Extracted from current config:

Hyper+H/J/K/L → focus window West/South/North/East
Hyper+S → focus next screen's window
Hyper+N → move focused window to next screen
Hyper+X → swap window positions
App Launcher
[NEW] 
app_launcher.lua
Hyper + number instantly launches or focuses a specific app:

Key	App
Hyper+1	Terminal (or your preferred terminal)
Hyper+2	Browser (Safari / Chrome / Arc)
Hyper+3	VS Code / Cursor
Hyper+4	Slack
Hyper+5	Finder
Hyper+6	Notes
Hyper+7	Spotify
Hyper+8	Messages
Hyper+9	System Settings
Uses hs.application.launchOrFocus(appName). The app list will be easily configurable as a Lua table at the top of the file.

Space / Desktop Switching
[NEW] 
spaces.lua
Hyper+F1 through Hyper+F9 → switch to Desktop 1–9 via hs.spaces.gotoSpace()
Inside Window Mode, 1–9 → move focused window to that Space via hs.spaces.moveWindowToSpace()
Helper function to map space index to spaceID using hs.spaces.spacesForScreen()
Window Hints
[NEW] 
hints.lua
Hyper+Tab → show hs.hints.windowHints() overlay
Configures hs.hints.hintChars to use home-row keys (ASDFGHJKL)
Sets hint style, font size, and icon opacity for readability
Menubar Status
[NEW] 
status.lua
Shows a small ⊞ icon in the menubar
Dropdown shows current mode (Normal / Window Mode)
Provides quick access to reload config and toggle features
Updates icon/color when entering/exiting Window Mode
Entry Point
[MODIFY] 
init.lua
Replace all existing content with:

lua
require("modules.config")
require("modules.reload")
require("modules.window_mode")
require("modules.focus")
require("modules.app_launcher")
require("modules.spaces")
require("modules.hints")
require("modules.status")
Keybinding Summary
Global (Hyper + key)
Key	Action
R	Reload config
W	Enter Window Mode
H/J/K/L	Focus window West/South/East/North
S	Focus next screen
N	Move window to next screen
X	Swap window positions
Q	"Why are you doing this?" notification
Tab	Window hints overlay
1–9	Launch/focus app
F1–F9	Switch to Desktop 1–9
Window Mode (after Hyper+W)
Key	Action
m	Maximize
h/l/k/j	Left/Right/Top/Bottom half
q/w/a/s	Quarters
c	Center 50%
n/p	Throw to next/prev screen
x	Swap with neighbor
=/-	Grow/Shrink window
[/]/\	Left/Middle/Right third
1–9	Move window to Space N
Escape	Exit Window Mode
Verification Plan
Manual Verification
Since Hammerspoon configs don't support automated unit tests, verification is manual:

Auto-reload: Save any 
.lua
 file → confirm "Config Reloaded" alert appears
Manual reload: Press Hyper+R → confirm "Config Reloaded" alert
Window Mode entry/exit: Hyper+W → see "Window Mode Active" → Escape → see "Window Mode Exited"
Window tiling: In Window Mode, press h, l, m, q, c — window should snap to left half, right half, maximize, top-left quarter, center
Thirds: Press [, ], \ — window snaps to left/right/middle third
Grow/Shrink: Press = / - — window grows/shrinks horizontally
Throw to screen: Press n — window moves to next monitor (multi-monitor needed)
App launcher: Hyper+1 through Hyper+9 — each launches or focuses the mapped app
Space switching: Hyper+F1 through Hyper+F3 — switches to Desktop 1, 2, 3 (requires multiple desktops)
Move to space: In Window Mode, press 2 — window moves to Desktop 2
Window hints: Hyper+Tab — overlay appears with letter hints on each window
Menubar: Verify ⊞ icon appears; entering Window Mode changes its appearance
Vim focus: Hyper+H/J/K/L focuses windows in the expected direction



-- wezterm.on("gui-startup", function(cmd)
-- 	local projects = {
-- 		{ name = "Work", path = "~/Desktop/Ajian/ajianlabs.com" },
-- 		{ name = "Side-Project", path = "~/Desktop/Basket/tranparent.nvim" },
-- 		{ name = "Config", path = "~/dotfiles" },
-- 	}
-- 	local _, pane, window = wezterm.mux.spawn_window(cmd or {})
-- 	-- Create tabs for each project
-- 	for i, project in ipairs(projects) do
-- 		local tab, tab_pane, _ = window:spawn_tab({ cwd = project.path })
-- 		tab:set_title(project.name)
-- 	end
-- 	-- Close the inital default tab
-- 	pane:activate()
-- 	pane:split({ size = 0.5 })
-- 	window:gui_window():perform_action(wezterm.action.CloseCurrentTab({ confirm = false }), pane)
-- end)

	{ key = "s", mods = "LEADER", action = action.ShowLauncherArgs({ flags = "WORKSPACES" }) },
	{
		key = "w",
		mods = "LEADER",
		action = action.PromptInputLine({
			description = wezterm.format({
				{ Attribute = { Italic = true } },
				{ Text = "Enter name for new workspace" },
			}),
			action = action_callback(function(window, pane, line)
				if line then
					window:perform_action(action.SwitchToWorkspace({ name = line }), pane)
				end
			end),
		}),
	},
	{
		key = "r",
		mods = "LEADER",

		action = action.PromptInputLine({
			description = wezterm.format({
				{ Attribute = { Italic = true } },
				{ Text = "Rename current workspace:" },
			}),
			action = action_callback(function(window, pane, line)
				if line then
					wezterm.mux.rename_workspace(wezterm.mux.get_active_workspace(), pane)
				end
			end),
		}),
	},
