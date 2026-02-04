return {
    {
        "folke/lazydev.nvim",
        ft = "lua", -- only load on lua files
        opts = {
            library = {
                -- See the configuration section for more details
                -- Load luvit types when the `vim.uv` word is found
                { path = "${3rd}/luv/library", words = { "vim%.uv" } },
            },
        },
    },
    { "mason-org/mason.nvim", opts = {} },
    {
        "neovim/nvim-lspconfig",
        lazy = false,
        dependencies = {
            { "mason-org/mason-lspconfig.nvim", opts = {} }
        },
        opts = {},
        config = function()
            vim.diagnostic.config({
                float = { border = "rounded" },
            })

            -- Set documentation border to be rounded
            local handlers = {
                ['textDocument/hover'] = vim.lsp.with(vim.lsp.handlers.hover, { border = "rounded" }),
                ['textDocument/signatureHelp'] = vim.lsp.with(vim.lsp.handlers.signature_help, { border = "rounded" }),
            }

            -- local capabilities = require("blink.cmp").get_lsp_capabilities()
            require("mason").setup()
            require("mason-lspconfig").setup {
                automatic_installation = false,
                automatic_setup = false,
                -- automatic_enable = {
                -- 	exclude = { 'ts_ls' }
                -- },
                -- capabilities = capabilities,
                handlers = nil,
                ensure_installed = {
                    "lua_ls",
                },
            }

            vim.lsp.config('eslint', {
                -- capabilities = capabilities,
                handlers = handlers,
                filetypes = { 'javascript', 'javascriptreact', 'javascript.jsx', 'typescript', 'typescriptreact', 'typescript.tsx', 'vue' }
            })

            vim.lsp.config('vue_ls', {
                -- capabilities = capabilities,
                handlers = handlers,
            })

            local vue_language_server_path = vim.fn.expand '$MASON/packages' ..
                '/vue-language-server' .. '/node_modules/@vue/language-server'

            -- Vue support
            vim.lsp.config('ts_ls', {
                -- capabilities = capabilities,
                handlers = handlers,
                init_options = {
                    plugins = {
                        {
                            name = '@vue/typescript-plugin',
                            location = vue_language_server_path,
                            languages = { 'vue' },
                            configNamespace = 'typescript',
                        }
                    },
                },
                filetypes = { 'typescript', 'javascript', 'javascriptreact', 'typescriptreact', 'vue' }
            })

            vim.lsp.config('rust_analyzer', {
                settings = {
                    ['rust-analyzer'] = {
                        check = {
                            command = "clippy",
                        },
                        diagnostics = {
                            enable = true,
                        }
                    }
                }
            })

            vim.api.nvim_create_autocmd('LspAttach', {
                callback = function(args)
                    local client = vim.lsp.get_client_by_id(args.data.client_id)
                    if not client then return end

                    -- if client.supports_method("textDocument/formatting") then
                    -- 	vim.api.nvim_create_autocmd("BufWritePre", {
                    -- 		buffer = args.buf,
                    -- 		callback = function()
                    -- 			vim.lsp.buf.format({
                    -- 				bufnr = args.buf,
                    -- 				id = client.id,
                    -- 				filter = function()
                    -- 					return client.name ~= "vue_ls"
                    -- 				end
                    -- 			})
                    -- 		end,
                    -- 	})
                    -- end
                end
            })
        end
    },
}
