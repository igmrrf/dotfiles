vim.g.exclude_finds = {
	-- Node.js & JavaScript/TypeScript
	"node_modules/*",

	-- Python
	"__pycache__/*",
	"%.pyc",
	".venv/*",
	"venv/*",

	-- Rust
	"target/*",

	-- Go
	"bin/*",
	"pkg/*",

	-- C, C++, Rust, Zig, Go build artifacts
	"build/*",
	"dist/*",
	"*.o",
	"*.obj",
	"*.exe",
	"*.dll",
	"*.so",
	"*.dylib",
	"*.out",

	-- Lua
	".luarc.json",
	".luarc/*",

	-- C#
	"bin/*",
	"obj/*",

	-- Zig
	"zig-cache/*",
	"zig-out/*",

	-- Version control
	-- ".git/*",
	".svn/*",

	-- Common IDE/Editor folders
	".idea/*",
	".vscode/*",

	-- System files
	".DS_Store",
	"Thumbs.db",
}
