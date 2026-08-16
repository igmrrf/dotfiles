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
	end,
	init = function()
		-- Toolchain bootstrap command to install Kotlin, JDK, and Gradle on macOS via Homebrew.
		-- LSP (kotlin-lsp), Formatter (ktlint), and DAP (kotlin-debug-adapter)
		-- are automatically managed by Mason.
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
				'echo "Done! kotlin-lsp and kotlin-debug-adapter are managed via :Mason."',
			}, "\n")

			vim.cmd("botright 18split | enew")
			vim.bo.bufhidden = "wipe"
			vim.fn.jobstart({ "sh", "-lc", script }, { term = true })
			vim.cmd("startinsert")
		end, { desc = "Bootstrap Kotlin toolchain (JDK, kotlin, gradle, ktlint) via brew" })

		-- Buffer-local keymaps and commands for Kotlin projects
		vim.api.nvim_create_autocmd("FileType", {
			pattern = "kotlin",
			callback = function(args)
				local function map(lhs, rhs, desc)
					vim.keymap.set("n", lhs, rhs, { buffer = args.buf, desc = desc })
				end

				-- Gradle / build helpers
				map("<leader>cb", function()
					if vim.fn.filereadable("gradlew") == 1 then
						vim.cmd("OverseerRunCmd ./gradlew build")
					elseif vim.fn.filereadable("pom.xml") == 1 then
						vim.cmd("OverseerRunCmd mvn compile")
					else
						vim.cmd(
							"OverseerRunCmd kotlinc "
								.. vim.fn.expand("%")
								.. " -include-runtime -d "
								.. vim.fn.expand("%:r")
								.. ".jar"
						)
					end
				end, "Build Project / Compile Kotlin")

				map("<leader>cr", function()
					if vim.fn.filereadable("gradlew") == 1 then
						vim.cmd("OverseerRunCmd ./gradlew run")
					elseif vim.fn.filereadable("pom.xml") == 1 then
						vim.cmd("OverseerRunCmd mvn exec:java")
					else
						local jar = vim.fn.expand("%:r") .. ".jar"
						vim.cmd("OverseerRunCmd java -jar " .. jar)
					end
				end, "Run Kotlin Project / Script")

				map("<leader>ct", function()
					if vim.fn.filereadable("gradlew") == 1 then
						vim.cmd("OverseerRunCmd ./gradlew test")
					elseif vim.fn.filereadable("pom.xml") == 1 then
						vim.cmd("OverseerRunCmd mvn test")
					else
						vim.notify("No gradle or maven project detected in root", vim.log.levels.WARN)
					end
				end, "Run Kotlin Tests (Gradle/Maven)")
			end,
		})
	end,
}
