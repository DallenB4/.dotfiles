return {
	{
		"neovim/nvim-lspconfig",
		dependencies = {
			"williamboman/mason.nvim",
			"williamboman/mason-lspconfig.nvim",
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
		},
		config = function()
			-- Set documentation border to be rounded
			local handlers = {
				['textDocument/hover'] = vim.lsp.with(vim.lsp.handlers.hover, { border = "rounded" }),
				['textDocument/signatureHelp'] = vim.lsp.with(vim.lsp.handlers.signature_help, { border = "rounded" }),
			}

			vim.diagnostic.config({
				float = { border = "rounded" },
			})

			local capabilities = require("blink.cmp").get_lsp_capabilities()
			require("mason").setup()
			require("mason-lspconfig").setup {
				automatic_enable = {
					exclude = { "ts_ls" }
				},
				automatic_installation = false,
				automatic_setup = false,
				capabilities = capabilities,
				handlers = nil,
				ensure_installed = {
					"lua_ls",
				},
			}

			local lspconfig = require("lspconfig")

			lspconfig.vue_ls.setup {
				capabilities = capabilities,
				handlers = handlers
			}

			lspconfig.eslint.setup {
				capabilities = capabilities,
				handlers = handlers,
				filetypes = { 'javascript', 'javascriptreact', 'javascript.jsx', 'typescript', 'typescriptreact', 'typescript.tsx', 'vue' }
			}

			local vue_language_server_path = vim.fn.expand '$MASON/packages' ..
					'/vue-language-server' .. '/node_modules/@vue/language-server'
			-- Vue support
			lspconfig.ts_ls.setup {
				capabilities = capabilities,
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
			}

			lspconfig.rust_analyzer.setup {
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
			}

			vim.api.nvim_create_autocmd('LspAttach', {
				callback = function(args)
					local client = vim.lsp.get_client_by_id(args.data.client_id)
					if not client then return end

					if client.supports_method("textDocument/formatting") then
						vim.api.nvim_create_autocmd("BufWritePre", {
							buffer = args.buf,
							callback = function()
								vim.lsp.buf.format({
									name = 'eslint',
									bufnr = args.buf,
									id = client.id,
									filter = function()
										return client.name ~= "vue_ls"
									end
								})
							end,
						})
					end
				end
			})
		end

	}, {
	-- Nuxt goto definition fix
	"rushjs1/nuxt-goto.nvim",
	ft = { "vue", "ts" },
} }
