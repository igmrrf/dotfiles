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

config.window_background_opacity = 0.90
config.macos_window_background_blur = 20
config.window_decorations = "RESIZE"
config.window_padding = {
	-- left = 0,
	-- right = 0,
	-- top = 0,
	bottom = 0,
}
config.color_scheme = "Catppuccin Mocha"
config.use_fancy_tab_bar = true
config.tab_bar_at_bottom = true
config.scrollback_lines = 5000
config.enable_scroll_bar = false
config.enable_tab_bar = false
config.hide_tab_bar_if_only_one_tab = true

config.send_composed_key_when_left_alt_is_pressed = false
config.send_composed_key_when_right_alt_is_pressed = false
config.show_new_tab_button_in_tab_bar = false
config.tab_max_width = 32
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

-- Catppuccin palettes (mainly base/bg + text colors)
local catppuccin = {
	latte = { bg = "#e6e9ef", fg = "#4c4f69", edge = "#dce0e8" },
	frappe = { bg = "#303446", fg = "#c6d0f5", edge = "#292c3c" },
	macchiato = { bg = "#24273a", fg = "#cad3f5", edge = "#1e2030" },
	mocha = { bg = "#1e1e2e", fg = "#cdd6f4", edge = "#181825" },
}

local function random_catppuccin()
	local options = { "latte", "frappe", "macchiato", "mocha" }
	return catppuccin[options[math.random(#options)]]
end

local active_colors = random_catppuccin()
wezterm.on("format-tab-title", function(tab, tabs, panes, cfg, hover, max_width)
	-- background colors
	local edge_bg = active_colors.edge
	local bg = tab.is_active and active_colors.bg or "#1e1e2e"
	local fg = tab.is_active and active_colors.fg or "#cdd6f4"

	-- Prefer custom tab title if set, else fall back to pane title
	local title = tab.tab_title and #tab.tab_title > 0 and tab.tab_title or tab.active_pane.title

	if tab.is_active then
		title = " 💻 " .. title
	else
		title = " " .. title .. " "
	end

	return {
		{ Background = { Color = edge_bg } },
		{ Foreground = { Color = bg } },
		{ Text = " " },

		{ Background = { Color = bg } },
		{ Foreground = { Color = fg } },
		{ Text = title },

		{ Background = { Color = edge_bg } },
		{ Foreground = { Color = bg } },
		{ Text = " " },
	}
end)

config.colors = {
	cursor_bg = "#7aa2f7",
	cursor_border = "#7aa2f7",
	tab_bar = {
		background = active_colors.edge,
	},
}
config.keys = keys

return config
