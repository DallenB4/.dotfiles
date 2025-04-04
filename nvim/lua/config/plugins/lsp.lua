return {
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
		require("mason").setup()
		require("mason-lspconfig").setup {
			ensure_installed = {
				"lua_ls",
			},
		}
		require("mason-lspconfig").setup_handlers {
			function(server_name)
				local capabilities = require("blink.cmp").get_lsp_capabilities()

				if server_name == "ts_ls" then
					local mason_registry = require('mason-registry')
					local vue_language_server_path = mason_registry.get_package('vue-language-server'):get_install_path() ..
							'/node_modules/@vue/language-server'
					require("lspconfig").ts_ls.setup {
						init_options = {
							plugins = {
								{
									name = "@vue/typescript-plugin",
									location = vue_language_server_path,
									languages = { "vue" },
								}
							},
						},
						capabilities = capabilities,
						filetypes = { 'typescript', 'javascript', 'javascriptreact', 'typescriptreact', 'vue' },
						settings = {
							typescript = {
								tsserver = {
									useSyntaxServer = false,
								},
								inlayHints = {
									includeInlayParameterNameHints = 'all',
									includeInlayParameterNameHintsWhenArgumentMatchesName = true,
									includeInlayFunctionParameterTypeHints = true,
									includeInlayVariableTypeHints = true,
									includeInlayVariableTypeHintsWhenTypeMatchesName = true,
									includeInlayPropertyDeclarationTypeHints = true,
									includeInlayFunctionLikeReturnTypeHints = true,
									includeInlayEnumMemberValueHints = true,
								},
							},
						},
					}
				elseif server_name == "volar" then
					require("lspconfig").volar.setup {
						capabilities = capabilities,
						init_options = {
							vue = {
								hybridMode = false,
							},
						},
						settings = {
							typescript = {
								inlayHints = {
									enumMemberValues = {
										enabled = true,
									},
									functionLikeReturnTypes = {
										enabled = true,
									},
									propertyDeclarationTypes = {
										enabled = true,
									},
									parameterTypes = {
										enabled = true,
										suppressWhenArgumentMatchesName = true,
									},
									variableTypes = {
										enabled = true,
									},
								},
							},
						}
					}
				else
					require("lspconfig")[server_name].setup {
						capabilities = capabilities
					}
				end
			end,
		}

		vim.api.nvim_create_autocmd('LspAttach', {
			callback = function(args)
				local client = vim.lsp.get_client_by_id(args.data.client_id)
				if not client then return end

				if client.supports_method("textDocument/formatting") then
					vim.api.nvim_create_autocmd("BufWritePre", {
						buffer = args.buf,
						callback = function()
							vim.lsp.buf.format({ bufnr = args.buf, id = client.id })
						end,
					})
				end
			end
		})
	end
}
