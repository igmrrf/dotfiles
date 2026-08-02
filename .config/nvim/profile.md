# Neovim Profiling & Debugging Guide

A comprehensive guide for measuring startup performance, profiling CPU/memory bottlenecks in Lua and Vimscript, and step-debugging Neovim configurations and plugins.

---

## Quick Reference / Decision Matrix

| Problem | Recommended Tool / Method |
| :--- | :--- |
| Quick Lua profiling / UI scratch breakdown | `Snacks.profiler` (`<leader>dps`, `<leader>dpS`, `<leader>dpp`, `<leader>dpt`) |
| Slow Neovim startup | `nvim --startuptime profile.log` or `Snacks.profiler` |
| Slow keymap / command / Lua function | `vim.uv.hrtime()` or `Snacks.profiler` |
| Deep Lua CPU flamegraph / tracing | `stevearc/profile.nvim` or LuaJIT `jit.p` |
| LSP lag or missing completions | `:LspInfo`, `vim.lsp.set_log_level("debug")` |
| Plugin crash / isolation testing | `nvim --clean` or `nvim -u NONE` |
| Interactive Lua step-debugging | `jbyuki/one-small-step-for-vimkind` (OSV) + `nvim-dap` |
| Neovim crash / segfault | `lldb nvim` or `gdb nvim` with core dump |

---

## 1. Snacks.nvim Profiler (`Snacks.profiler`)

Your configuration has `folke/snacks.nvim` installed with built-in profiler keybindings configured in [`lua/plugins/snacks.lua`](file:///Users/igmrrf/dotfiles/.config/nvim/lua/plugins/snacks.lua).

### Configured Keymaps

| Keymap | Action | Description |
| :--- | :--- | :--- |
| `<leader>dps` | `Snacks.profiler.start()` | Start recording Lua execution & traces |
| `<leader>dpS` | `Snacks.profiler.stop()` | Stop recording active profiling session |
| `<leader>dpp` | `Snacks.profiler.scratch()` | Open interactive Profiler Scratch Buffer / Results |
| `<leader>dpt` | `Snacks.profiler.toggle()` | Toggle profiler recording state |

### Usage Workflow

1. **Start Profiling**: Press `<leader>dps` (or run `:lua Snacks.profiler.start()`).
2. **Execute Slow Action**: Trigger the keymap, command, or action you want to profile.
3. **Stop Profiling**: Press `<leader>dpS` (or run `:lua Snacks.profiler.stop()`).
4. **Inspect Results**: Press `<leader>dpp` to open the profiler scratch buffer showing function call trees, durations, and execution counts.

### Profiling Startup with `Snacks.profiler`

To capture startup timing using Snacks' profiler:

```lua
-- Add at the very top of init.lua (or toggle via environment variable)
if vim.env.NVIM_PROFILER then
  require("snacks.profiler").startup({
    startup = {
      event = "VimEnter", -- Stop profiling automatically on VimEnter
    },
  })
end
```

Then start Neovim from terminal:
```bash
NVIM_PROFILER=1 nvim
```

> [!NOTE]
> **Neovim 0.12+ Runtime Path Resolution Fix**:
> In Neovim 0.12+, internal runtime modules (such as `vim/_core/shared`) do not include `.lua` in debug callstacks. A defensive wrapper has been added in [`lua/plugins/snacks.lua`](file:///Users/igmrrf/dotfiles/.config/nvim/lua/plugins/snacks.lua) to automatically append `.lua` and catch unreadable file attempts to prevent `Vim:E484` errors when stopping profiling sessions.

---

## 2. Startup Time Profiling

### Built-in Startup Log
Generate a detailed startup breakdown down to the millisecond:

```bash
nvim --startuptime startup.log
```

Analyze `startup.log`:
- Column 1: Elapsed time since start (ms)
- Column 2: Time spent on the current item (ms)
- Column 3: Item / script being sourced

**Key things to look for:**
- `sourcing ...`: Slow `.lua` or `.vim` config files.
- `infolist / rtp`: Excessive runtime path scanning.
- Plugin initialization: Deferred loading targets.

### Automated Startup Benchmarking
Use [`dstein64/vim-startuptime`](https://github.com/dstein64/vim-startuptime) to take multiple samples and calculate statistical averages:

```bash
# If installed as CLI or plugin:
nvim +StartupTime
```

### Inspecting `vim.loader` (Bytecode Cache)
Ensure Neovim's byte-compilation cache is active at the top of your `init.lua`:

```lua
vim.loader.enable()
```

Verify status in Neovim:
```vim
:lua print(vim.inspect(vim.loader.status()))
```

---

## 2. Lua CPU & Function Profiling

### Built-in Neovim Profiler (`:profile`)
Neovim includes Vim's native profiler for Vimscript and Lua functions exposed to Vimscript commands:

```vim
" Start profiling and dump to file
:profile start profile.log
:profile func *
:profile file *

" Perform the actions that feel slow...

" Stop profiling and review profile.log
:profile pause
```

### Advanced Lua CPU Profiling with `stevearc/profile.nvim`
For flamegraphs and deep call-stack visualization (Speedscope / Chrome DevTools format):

1. **Setup (`profile.nvim`)**:
```lua
-- Add near the top of your init.lua (or toggle via keymap)
local should_profile = os.getenv("NVIM_PROFILE")
if should_profile then
  local profile = require("profile")
  profile.instrument_autocmds()
  profile.instrument_imports()
  profile.start("*")
end
```

2. **Toggle profiling on the fly**:
```lua
vim.keymap.set("n", "<f1>", function()
  local profile = require("profile")
  if profile.is_recording() then
    profile.stop()
    profile.export("profile.json")
    vim.notify("Profile saved to profile.json")
  else
    profile.start("*")
    vim.notify("Profiling started")
  end
end, { desc = "Toggle Lua Profiler" })
```

3. **Visualize**:
Upload `profile.json` to [speedscope.app](https://www.speedscope.app/) or open in Chrome (`chrome://tracing`).

### Native LuaJIT Profiler (`jit.p`)
LuaJIT includes a sampling profiler built into the engine:

```lua
-- Start LuaJIT profiler (G = graphical call tree, i1 = 1ms sampling)
require("jit.p").start("F1", "luajit_profile.txt")

-- Run your slow Lua code...

-- Stop profiler
require("jit.p").stop()
```

---

## 3. High-Precision Micro-Benchmarking

To measure precise execution time of specific code blocks or functions, use `vim.uv.hrtime()` (high-resolution nanosecond timer):

```lua
local function benchmark(name, fn)
  local start = vim.uv.hrtime()
  fn()
  local elapsed_ms = (vim.uv.hrtime() - start) / 1e6
  vim.notify(string.format("[Benchmark] %s took %.3f ms", name, elapsed_ms), vim.log.levels.INFO)
end

-- Usage:
benchmark("Treesitter parse", function()
  vim.treesitter.get_parser():parse()
end)
```

---

## 4. Memory & Garbage Collection Profiling

### Tracking Memory Usage
Inspect current Lua memory usage before and after operations:

```lua
local function print_mem(label)
  collectgarbage("collect") -- Force full GC cycle
  local kbytes = collectgarbage("count")
  print(string.format("[%s] Lua Memory: %.2f MB", label or "Check", kbytes / 1024))
end

print_mem("Before heavy load")
-- ... run operations ...
print_mem("After heavy load")
```

### Detecting Autocmd & Listener Leaks
Avoid duplicate autocommands by checking active groups:

```vim
:autocmd User
:autocmd CursorHold
```

In Lua, always supply a explicit `group`:
```lua
local group = vim.api.nvim_create_augroup("MyGroup", { clear = true })
vim.api.nvim_create_autocmd("BufEnter", {
  group = group,
  callback = function() end,
})
```

---

## 5. Debugging Neovim Configurations

### Isolation Flags
Isolate whether an issue comes from core Neovim, your config, or plugins:

```bash
# Start Neovim without any config or plugins
nvim --clean

# Start without user config (init.lua / init.vim)
nvim -u NONE

# Start with a minimal test config file
nvim -u ~/minimal_init.lua
```

### Health & Log Inspection
- **Health Check**: Run `:checkhealth` to detect missing dependencies, broken LSP setups, or provider issues.
- **Messages**: View recent warning/error output via `:messages`.
- **System Logs**: Inspect Neovim log directory (`stdpath("log")`):
  ```bash
  cat ~/.local/state/nvim/lsp.log
  ```

### LSP Debugging
Enable detailed log output for LSP requests/responses:

```lua
vim.lsp.set_log_level("debug") -- Options: "OFF", "ERROR", "WARN", "INFO", "DEBUG", "TRACE"
```

Open the log file:
```vim
:LspLog
```

---

## 6. Interactive Lua Step-Debugging (DAP)

To set breakpoints, step through lines, and evaluate variables inside your running Neovim instance:

### Using `one-small-step-for-vimkind` (OSV) + `nvim-dap`

1. **Install Plugins**: Add `jbyuki/one-small-step-for-vimkind` and `mfussenegger/nvim-dap`.
2. **Configure Adapter**:
```lua
local dap = require("dap")
dap.adapters.nlua = function(callback, config)
  callback({ type = "server", host = config.host or "127.0.0.1", port = config.port or 8086 })
end

dap.configurations.lua = {
  {
    type = "nlua",
    request = "attach",
    name = "Attach to running Neovim instance",
    host = "127.0.0.1",
    port = 8086,
  },
}
```

3. **Launch Server & Attach**:
- Run `:lua require('osv').launch({ port = 8086 })` in the Neovim instance to debug.
- Set breakpoints using `:lua require('dap').toggle_breakpoint()`.
- Trigger the Lua code to hit the breakpoint.

---

## 7. Core Neovim Debugging (C / GDB / LLDB)

For crashes, segmentation faults, or C-level debugging:

### Attaching LLDB/GDB
```bash
# Launch under LLDB
lldb -- nvim --clean

# Set breakpoint in C source
(lldb) b nv_open
(lldb) run
```

### Capturing Core Dumps on Segfault (macOS)
```bash
# Enable core dumps
ulimit -c unlimited

# Run Neovim until crash
nvim

# Load crash dump in lldb
lldb -c /cores/core.<pid> nvim
```

---

## 8. Summary Checklist Workflow

When troubleshooting Neovim performance or bugs, follow this sequence:

1. **Clean reproduce**: `nvim --clean` (rules out Neovim core bugs).
2. **Benchmark startup**: `nvim --startuptime log.txt` (identifies slow plugins/config files).
3. **Inspect health**: `:checkhealth` & `:messages`.
4. **Profile CPU**: Use `profile.nvim` or `vim.uv.hrtime()` for lagging UI or commands.
5. **Trace logs**: Turn on `DEBUG` logs for LSP or DAP as needed.
