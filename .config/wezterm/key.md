# WezTerm Keymaps

This document tracks the custom keybindings defined in `keys.lua`.

## Modifiers
- `LEADER`: The leader key (usually configured in `wezterm.lua`)
- `CTRL|SHIFT`: Control + Shift

## Panes

| Keybinding | Action |
| :--- | :--- |
| `LEADER + 0` | Select Pane |
| `LEADER + }` | Swap pane with active pane |
| `LEADER + {` | Swap pane with active pane (Keep Focus) |
| `LEADER + x` | Close current pane (with confirmation) |
| `LEADER + \` | Split Horizontal |
| `LEADER + -` | Split Vertical |
| `LEADER + m` | Toggle Pane Zoom State |

### Pane Navigation
| Keybinding | Action |
| :--- | :--- |
| `LEADER + h` | Move Focus Left |
| `LEADER + l` | Move Focus Right |
| `LEADER + j` | Move Focus Down |
| `LEADER + k` | Move Focus Up |

### Pane Resizing
| Keybinding | Action |
| :--- | :--- |
| `CTRL\|SHIFT + h` | Adjust Pane Size Left (5) |
| `CTRL\|SHIFT + l` | Adjust Pane Size Right (6) |
| `CTRL\|SHIFT + j` | Adjust Pane Size Down (5) |
| `CTRL\|SHIFT + k` | Adjust Pane Size Up (5) |

## Tabs
| Keybinding | Action |
| :--- | :--- |
| `LEADER + ,` | Prompt to rename current tab |

## Workspaces
| Keybinding | Action |
| :--- | :--- |
| `LEADER + <` | Prompt to rename current workspace |
| `LEADER + p` | Switch to previous workspace |
| `LEADER + n` | Switch to next workspace |
| `LEADER + w` | Fuzzy find workspace (Launcher) |
| `LEADER + W` | Prompt for new workspace name and switch to it |
| `LEADER + y` | Switch to `default` workspace |
| `LEADER + u` | Switch to `monitoring` workspace (launches `btop`) |

## Sessions (wezterm-sessions plugin)
| Keybinding | Action |
| :--- | :--- |
| `LEADER + s` | Save session |
| `LEADER + S` | Load session |
| `LEADER + r` | Restore session |
| `LEADER + d` | Delete session |
| `LEADER + e` | Edit session |
| `LEADER + a` | Toggle autosave |
| `LEADER + f` | Fork session |

## Miscellaneous
| Keybinding | Action |
| :--- | :--- |
| `LEADER + c` | Activate Copy Mode |
