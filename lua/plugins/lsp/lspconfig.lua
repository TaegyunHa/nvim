return {
	"neovim/nvim-lspconfig",
	dependencies = {
		{ "mason-org/mason.nvim", opts = {} },
		"WhoIsSethDaniel/mason-tool-installer.nvim",
		{ "j-hui/fidget.nvim", opts = {} },
		"saghen/blink.cmp",
		{ "antosha417/nvim-lsp-file-operations", config = true },
		{ "folke/lazydev.nvim", ft = "lua", opts = {} },
	},
	config = function()
		vim.api.nvim_create_autocmd("LspAttach", {
			group = vim.api.nvim_create_augroup("kickstart-lsp-attach", { clear = true }),
			callback = function(event)
				local map = function(keys, func, desc, mode)
					mode = mode or "n"
					vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = "LSP: " .. desc })
				end

				-- Rename the variable under your cursor.
				map("grn", vim.lsp.buf.rename, "[R]e[n]ame")

				-- Execute a code action
				map("gra", vim.lsp.buf.code_action, "[G]oto Code [A]ction", { "n", "x" })

				-- Go to declaration (e.g. header in C)
				map("grD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")

				-- Restart LSP
				map("grs", ":LspRestart<CR>", "Restart LSP")

				local client = vim.lsp.get_client_by_id(event.data.client_id)

				-- Switch between header and source (clangd)
				if client and client.name == "clangd" then
					map("gro", function()
						local params = { uri = vim.uri_from_bufnr(0) }
						client:request("textDocument/switchSourceHeader", params, function(err, uri)
							if not err and uri then
								vim.cmd.edit(vim.uri_to_fname(uri))
							end
						end)
					end, "Switch Header/Source")
				end

				-- Document highlight on CursorHold
				if client and client:supports_method("textDocument/documentHighlight", event.buf) then
					local highlight_augroup =
						vim.api.nvim_create_augroup("kickstart-lsp-highlight", { clear = false })
					vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
						buffer = event.buf,
						group = highlight_augroup,
						callback = vim.lsp.buf.document_highlight,
					})

					vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
						buffer = event.buf,
						group = highlight_augroup,
						callback = vim.lsp.buf.clear_references,
					})

					vim.api.nvim_create_autocmd("LspDetach", {
						group = vim.api.nvim_create_augroup("kickstart-lsp-detach", { clear = true }),
						callback = function(event2)
							vim.lsp.buf.clear_references()
							vim.api.nvim_clear_autocmds({ group = "kickstart-lsp-highlight", buffer = event2.buf })
						end,
					})
				end

				-- Toggle inlay hints
				if client and client:supports_method("textDocument/inlayHint", event.buf) then
					map("<leader>th", function()
						vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = event.buf }))
					end, "[T]oggle Inlay [H]ints")
				end
			end,
		})

		-- Diagnostic configuration
		vim.diagnostic.config({
			signs = {
				text = {
					[vim.diagnostic.severity.ERROR] = " ",
					[vim.diagnostic.severity.WARN] = " ",
					[vim.diagnostic.severity.HINT] = "󰠠 ",
					[vim.diagnostic.severity.INFO] = " ",
				},
			},
			update_in_insert = false,
			severity_sort = true,
			float = { border = "rounded", source = "if_many" },
			underline = { severity = vim.diagnostic.severity.ERROR },
			virtual_text = true,
			virtual_lines = false,
			jump = { float = true },
		})

		-- LSP capabilities from blink.cmp
		local capabilities = require("blink.cmp").get_lsp_capabilities()

		-- Server configurations
		local servers = {
			basedpyright = {
				settings = {
					basedpyright = {
						analysis = {
							typeCheckingMode = "standard",
							diagnosticMode = "openFilesOnly",
							inlayHints = { callArgumentNames = true },
						},
					},
				},
			},
				clangd = {
				cmd = {
					"clangd",
					"--background-index",
					"--background-index-priority=low",
					"--j=4",
					"--pch-storage=memory",
					"--header-insertion=never",
					"--completion-style=detailed",
					"--fallback-style=Microsoft",
					"--limit-results=50",
					"--log=error",
				},
			},
		}

		-- Mason: ensure tools are installed
		local ensure_installed = vim.tbl_keys(servers or {})
		vim.list_extend(ensure_installed, {
			"lua-language-server",
			"stylua",
			"isort",
			"black",
			"pylint",
			"clang-format",
		})
		require("mason-tool-installer").setup({ ensure_installed = ensure_installed })

		-- Configure and enable servers
		for name, server in pairs(servers) do
			server.capabilities = vim.tbl_deep_extend("force", {}, capabilities, server.capabilities or {})
			vim.lsp.config(name, server)
			vim.lsp.enable(name)
		end

		-- Lua LS: special config as recommended by Neovim docs
		vim.lsp.config("lua_ls", {
			capabilities = capabilities,
			settings = {
				Lua = {
					runtime = {
						version = "LuaJIT",
					},
					workspace = {
						checkThirdParty = false,
						library = vim.api.nvim_get_runtime_file("", true),
					},
				},
			},
		})
		vim.lsp.enable("lua_ls")
	end,
}
