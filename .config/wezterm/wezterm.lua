local wezterm = require("wezterm")
local keys = require("keys")

local config = {}

if wezterm.config_builder then
	config = wezterm.config_builder()
end

config.unix_domains = { { name = "unix" } } -- Enables the multiplexer
config.default_gui_startup_args = { "connect", "unix" } -- Auto-connect on launch
config.leader = { key = "g", mods = "CTRL", timeout_milliseconds = 1000 }
config.hyperlink_rules = {
	-- Matches: a URL in parens: (URL)
	{
		regex = "\\((\\w+://\\S+)\\)",
		format = "$1",
		highlight = 1,
	},
	-- Matches: a URL in brackets: [URL]
	{
		regex = "\\[(\\w+://\\S+)\\]",
		format = "$1",
		highlight = 3,
	},
	-- Matches: a URL in curly braces: {URL}
	{
		regex = "\\{(\\w+://\\S+)\\}",
		format = "$1",
		highlight = 1,
	},
	-- Matches: a URL in angle brackets: <URL>
	{
		regex = "<(\\w+://\\S+)>",
		format = "$1",
		highlight = 1,
	},
	-- Then handle URLs not wrapped in brackets
	{
		regex = "\\b\\w+://\\S+[)/a-zA-Z0-9-]+",
		format = "$0",
	},
	-- implicit mailto link
	{
		regex = "\\b\\w+@[\\w-]+(\\.[\\w-]+)+\\b",
		format = "mailto:$0",
	},
}

config.window_background_opacity = 0.92
-- config.macos_window_background_blur = 20 -- Enabled for macOS transparent effect
config.max_fps = 120 -- Enable 120Hz for ProMotion displays
config.front_end = "WebGpu"
config.window_decorations = "RESIZE" -- Removes extra buttons
config.window_padding = {
	-- left = 0,
	-- right = 0,
	-- top = 0,
	bottom = 0,
}
config.color_scheme = "Catppuccin Mocha"
config.use_fancy_tab_bar = false
config.tab_bar_at_bottom = false
config.scrollback_lines = 5000
config.enable_scroll_bar = false
config.enable_tab_bar = true
config.hide_tab_bar_if_only_one_tab = false -- Ensure tab bar is always visible so you can see the workspace

config.send_composed_key_when_left_alt_is_pressed = false
config.send_composed_key_when_right_alt_is_pressed = false
config.show_new_tab_button_in_tab_bar = false
config.tab_max_width = 100 -- Significantly increased to allow tabs to stretch
config.font_size = 15
config.font = wezterm.font_with_fallback({
	"RecMonoCasual Nerd Font Mono",
	"RecMonoLinear Nerd Font Mono",
	"RecMonoDuotone Nerd Font Mono",
	{ family = "ZedMono Nerd Font", weight = "Regular", stretch = "Normal" },
	{ family = "JetBrainsMono Nerd Font", weight = "Regular", stretch = "Normal" },
	{ family = "Lilex Nerd Font Mono", weight = "Regular", stretch = "Normal" },
	"DepartureMono Nerd Font",
	"FiraCode Nerd Font Mono",
	"Monaspace Krypto NF",
	"Monaspace Xenon NF",
	"Monaspace Radon NF",
	"Monaspace Argon NF",
	"Monaspace Neon NF",
	{ family = "Symbols Nerd Font Mono", weight = "Regular", stretch = "Normal", style = "Italic" },
})

-- Format the tab title to simulate flex-grow and occupy full width
wezterm.on("format-tab-title", function(tab, tabs, panes, cfg, hover, max_width)
	local pane = tab.active_pane
	local title = tab.tab_title

	-- Extract just the folder name
	if not title or #title == 0 then
		local cwd = pane.current_working_dir
		if cwd and cwd.file_path then
			title = cwd.file_path:match("([^/\\]+)[/\\]*$")
		end
		if not title or #title == 0 then
			title = pane.title
		end
	end

	if tab.is_active then
		title = " 🥷 " .. title
	end

	-- Add inner spacing for the pill
	title = " " .. title .. " "

	local palette = cfg.resolved_palette
	local bg = palette.tab_bar and palette.tab_bar.inactive_tab and palette.tab_bar.inactive_tab.bg_color or "#1e1e2e"
	local fg = palette.tab_bar and palette.tab_bar.inactive_tab and palette.tab_bar.inactive_tab.fg_color or "#cdd6f4"

	if tab.is_active then
		bg = palette.tab_bar and palette.tab_bar.active_tab and palette.tab_bar.active_tab.bg_color or "#cdd6f4"
		fg = palette.tab_bar and palette.tab_bar.active_tab and palette.tab_bar.active_tab.fg_color or "#1e1e2e"
	elseif hover then
		bg = palette.tab_bar and palette.tab_bar.inactive_tab_hover and palette.tab_bar.inactive_tab_hover.bg_color
			or bg
		fg = palette.tab_bar and palette.tab_bar.inactive_tab_hover and palette.tab_bar.inactive_tab_hover.fg_color
			or fg
	end

	local edge_bg = "rgba(0,0,0,0)"

	return {
		{ Background = { Color = edge_bg } },
		{ Foreground = { Color = bg } },
		{ Text = " " },
		{ Background = { Color = bg } },
		{ Foreground = { Color = fg } },
		{ Text = title },
		{ Background = { Color = edge_bg } },
		{ Foreground = { Color = bg } },
		{ Text = " " },
	}
end)

-- Display workspace name in the right status area
wezterm.on("update-status", function(window, pane)
	local workspace = window:active_workspace()
	local palette = window:effective_config().resolved_palette
	local bg = palette.tab_bar and palette.tab_bar.active_tab and palette.tab_bar.active_tab.bg_color
		or palette.background
	local fg = palette.tab_bar and palette.tab_bar.active_tab and palette.tab_bar.active_tab.fg_color
		or palette.foreground

	window:set_right_status(wezterm.format({
		{ Background = { Color = "rgba(0,0,0,0)" } },
		{ Foreground = { Color = bg } },
		{ Text = " " },
		{ Background = { Color = bg } },
		{ Foreground = { Color = fg } },
		{ Text = " 🚀 " .. workspace .. " " },
		{ Background = { Color = "rgba(0,0,0,0)" } },
		{ Foreground = { Color = bg } },
		{ Text = " " },
	}))
end)

config.colors = {
	cursor_bg = "#7aa2f7",
	cursor_border = "#7aa2f7",
	tab_bar = {
		background = "rgba(0,0,0,0)",
	},
}
config.keys = keys

-- Automatically start the wezterm-sessions autosave in the background
local autosave_started = false
wezterm.on("window-config-reloaded", function(window, pane)
	if not autosave_started then
		-- This emits the event handled by the wezterm-sessions plugin
		-- It will quietly save the active workspace in the background on an interval
		wezterm.emit("toggle_autosave", window)
		autosave_started = true
	end
end)

return config
