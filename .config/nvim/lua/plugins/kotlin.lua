local function find_upward(name)
	return vim.fs.find(name, { upward = true, path = vim.fn.expand("%:p:h") })[1]
end

local function project_cmd(gradle, maven, fallback)
	local gradlew = find_upward("gradlew")
	if gradlew then
		return gradle(vim.fn.shellescape(gradlew), vim.fn.shellescape(vim.fs.dirname(gradlew)))
	end

	local pom = find_upward("pom.xml")
	if pom then
		return maven(vim.fn.shellescape(pom))
	end

	return fallback and fallback()
end

return {
	"AlexandrosAlexiou/kotlin.nvim",
	ft = { "kotlin" },
	dependencies = {
		"neovim/nvim-lspconfig",
		"mason-org/mason.nvim",
		"mason-org/mason-lspconfig.nvim",
	},
	config = function()
		require("kotlin").setup({})

		local buf = vim.api.nvim_get_current_buf()
		if vim.bo[buf].filetype == "kotlin" then
			vim.api.nvim_exec_autocmds("FileType", { group = "kotlin_lsp", buffer = buf })
		end
	end,
	init = function()
		-- Toolchain bootstrap command to install Kotlin, JDK, and Gradle on macOS via Homebrew.
		vim.api.nvim_create_user_command("KotlinBootstrap", function()
			local script = table.concat({
				"set -e",
				'echo "== Kotlin toolchain bootstrap =="',
				"if ! command -v brew >/dev/null 2>&1; then",
				'  echo "ERROR: Homebrew not found. Install it first: https://brew.sh"',
				"  exit 1",
				"fi",
				'echo "-- installing OpenJDK 21, Kotlin, Gradle, and Ktlint via Homebrew"',
				"brew install openjdk@21 kotlin gradle ktlint",
				"echo",
				-- openjdk@21 is keg-only, so Gradle will not find a JDK on its own.
				'echo "openjdk@21 is keg-only. Add this to your shell config:"',
				'echo "  set -gx JAVA_HOME $(brew --prefix openjdk@21)/libexec/openjdk.jdk/Contents/Home"',
				"echo",
				'echo "Done! kotlin-lsp and ktlint are managed via :Mason."',
			}, "\n")

			vim.cmd("botright 18split | enew")
			vim.bo.bufhidden = "wipe"
			vim.fn.jobstart({ "sh", "-lc", script }, { term = true })
			vim.cmd("startinsert")
		end, { desc = "Bootstrap Kotlin toolchain (JDK, kotlin, gradle, ktlint) via brew" })

		-- Buffer-local keymaps and commands for Kotlin projects
		vim.api.nvim_create_autocmd("FileType", {
			group = vim.api.nvim_create_augroup("kotlin_project_keymaps", { clear = true }),
			pattern = "kotlin",
			callback = function(args)
				local function map(lhs, rhs, desc)
					vim.keymap.set("n", lhs, rhs, { buffer = args.buf, desc = desc })
				end

				-- Gradle / build helpers. `-p` / `-f` point the build tool at the
				local function run(cmd)
					if cmd then
						vim.cmd("OverseerShell " .. cmd)
					end
				end

				map("<leader>cb", function()
					run(project_cmd(function(gradlew, root)
						return gradlew .. " -p " .. root .. " build"
					end, function(pom)
						return "mvn -f " .. pom .. " compile"
					end, function()
						local file = vim.fn.shellescape(vim.fn.expand("%:p"))
						local jar = vim.fn.shellescape(vim.fn.expand("%:p:r") .. ".jar")
						return "kotlinc " .. file .. " -include-runtime -d " .. jar
					end))
				end, "Build Project / Compile Kotlin")

				map("<leader>cr", function()
					run(project_cmd(function(gradlew, root)
						return gradlew .. " -p " .. root .. " run"
					end, function(pom)
						return "mvn -f " .. pom .. " exec:java"
					end, function()
						return "java -jar " .. vim.fn.shellescape(vim.fn.expand("%:p:r") .. ".jar")
					end))
				end, "Run Kotlin Project / Script")

				map("<leader>ct", function()
					run(project_cmd(function(gradlew, root)
						return gradlew .. " -p " .. root .. " test"
					end, function(pom)
						return "mvn -f " .. pom .. " test"
					end, function()
						vim.notify("No gradle or maven project found above this file", vim.log.levels.WARN)
					end))
				end, "Run Kotlin Tests (Gradle/Maven)")
			end,
		})
	end,
}
