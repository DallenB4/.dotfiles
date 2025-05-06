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
			local capabilities = require("blink.cmp").get_lsp_capabilities()
			require("lspconfig").nixd.setup {
				capabilities = capabilities,
				settings = {
					nixd = {
						nixpkgs = {
							expr = "import <nixpkgs> { }",
						},
						options = {
							nixos = {
								expr = '(builtins.getFlake "/Users/dallen/Documents/.dotfiles/nix").darwinConfigurations.Tetramini.options',
							},
							darwin = {
								expr = '(builtins.getFlake "/Users/dallen/Documents/.dotfiles/nix").darwinConfigurations.Tetramini.options',
							},
						},
						formatting = {
							command = { "/run/current-system/sw/bin/nixfmt" }, -- or nixfmt or nixpkgs-fmt
						},
					}
				}
			}
			require("mason").setup()
			require("mason-lspconfig").setup {
				automatic_installation = false,
				ensure_installed = {
					"lua_ls",
				},
			}
			require("mason-lspconfig").setup_handlers {
				function(server_name)
					if server_name == "ts_ls" then
						local mason_registry = require('mason-registry')
						local vue_language_server_path = mason_registry.get_package('vue-language-server'):get_install_path() ..
								'/node_modules/@vue/language-server'
						-- Vue support
						require("lspconfig").ts_ls.setup {
							capabilities = capabilities,
							init_options = {
								plugins = {
									{
										name = "@vue/typescript-plugin",
										location = vue_language_server_path,
										languages = { "vue", "typescript", "css" },
									}
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

	}, {
	-- Nuxt goto definition fix
	"rushjs1/nuxt-goto.nvim",
	ft = "vue",
} }
