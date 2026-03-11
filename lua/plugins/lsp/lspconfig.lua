return {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
        { "mason-org/mason.nvim", opts = {} },
        "WhoIsSethDaniel/mason-tool-installer.nvim",
        "hrsh7th/cmp-nvim-lsp",
        { "antosha417/nvim-lsp-file-operations", config = true },
        { "folke/lazydev.nvim", ft = "lua", opts = {} },
    },
    config = function()
        require("mason-tool-installer").setup({
            ensure_installed = {
                "lua-language-server",
                "clangd",
                "cmake",
                "stylua",
                "isort",
                "black",
                "pylint",
                "clang-format",
                "cmake-language-server",
            },
        })

        local cmp_nvim_lsp = require("cmp_nvim_lsp")

        vim.api.nvim_create_autocmd("LspAttach", {
            group = vim.api.nvim_create_augroup("UserLspConfig", {}),
            callback = function(ev)
                local map = function(keys, func, desc, mode)
                    mode = mode or "n"
                    vim.keymap.set(mode, keys, func, { buffer = ev.buf, desc = "LSP: " .. desc })
                end

                -- Telescope-powered LSP navigation (overrides 0.11 defaults with Telescope UI)
                map("gD", vim.lsp.buf.declaration, "Go to declaration")
                map("gd", "<cmd>Telescope lsp_definitions<CR>", "Show definitions")
                map("grr", "<cmd>Telescope lsp_references<CR>", "Show references")
                map("gri", "<cmd>Telescope lsp_implementations<CR>", "Show implementations")
                map("grt", "<cmd>Telescope lsp_type_definitions<CR>", "Show type definitions")
                map("gO", "<cmd>Telescope lsp_document_symbols<CR>", "Document symbols")
                map("gW", "<cmd>Telescope lsp_dynamic_workspace_symbols<CR>", "Workspace symbols")

                -- Rename the variable under your cursor.
                --  Most Language Servers support renaming across files, etc.
                map('grn', vim.lsp.buf.rename, '[R]e[n]ame')

                -- Execute a code action, usually your cursor needs to be on top of an error
                -- or a suggestion from your LSP for this to activate.
                map('gra', vim.lsp.buf.code_action, '[G]oto Code [A]ction', { 'n', 'x' })

                -- Diagnostics
                map("<leader>D", "<cmd>Telescope diagnostics bufnr=0<CR>", "Buffer diagnostics")
                map("<leader>d", vim.diagnostic.open_float, "Line diagnostics")
                map("[d", function() vim.diagnostic.jump({ count = -1 }) end, "Previous diagnostic")
                map("]d", function() vim.diagnostic.jump({ count = 1 }) end, "Next diagnostic")

                map("<leader>rs", ":LspRestart<CR>", "Restart LSP")
            end,
        })
        
        vim.diagnostic.config({
            signs = {
                text = {
                    [vim.diagnostic.severity.ERROR] = " ",
                    [vim.diagnostic.severity.WARN] = " ",
                    [vim.diagnostic.severity.HINT] = "󰠠 ",
                    [vim.diagnostic.severity.INFO] = " ",
                },
            },
        })

        -- Autocompletion capabilities
        local capabilities = cmp_nvim_lsp.default_capabilities()

        -- Server configurations
        vim.lsp.config('lua_ls', {
            capabilities = capabilities,
            settings = {
                Lua = {
                    diagnostics = { globals = { "vim" } },
                    completion = { callSnippet = "Replace" },
                },
            },
        })

        vim.lsp.config('basedpyright', {
            capabilities = capabilities,
            settings = {
                basedpyright = {
                    analysis = {
                        typeCheckingMode = "standard",
                        diagnosticMode = "openFilesOnly",
                        inlayHints = { callArgumentNames = true },
                    },
                },
            },
        })

        -- Enable configured servers
        vim.lsp.enable({ 'lua_ls', 'basedpyright' })
    end,
}
