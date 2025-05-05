return {
	{
		"L3MON4D3/LuaSnip",
		lazy = true,
		dependencies = {
			{
				"rafamadriz/friendly-snippets",
				config = function()
					require("luasnip.loaders.from_vscode").lazy_load()
					require("luasnip.loaders.from_vscode").lazy_load({ paths = { vim.fn.stdpath("config") .. "/snippets" } })
				end,
			},
		},
		opts = {
			history = true,
			delete_check_events = "TextChanged",
		},
	},
	{
		'saghen/blink.cmp',
		version = '*',

		opts = {
			keymap = {
				preset = 'none',

				['<C-space>'] = { 'show', 'show_documentation' },
				['<C-h>'] = { 'hide', 'fallback' },

				['<CR>'] = { 'accept', 'fallback' },

				['<Tab>'] = { 'select_next', 'fallback' },
				['<S-Tab>'] = { 'select_prev', 'fallback' },

				['<M-k>'] = { 'scroll_documentation_up', 'fallback' },
				['<M-j>'] = { 'scroll_documentation_down', 'fallback' },

			},
			cmdline = {
				completion = {
					menu = {
						auto_show = true
					},
					list = {
						selection = {
							preselect = false
						}
					},
				},
				keymap = {
					['<C-space>'] = { 'show', 'show_documentation' },
					['<C-h>'] = { 'hide', 'fallback' },

					['<S-CR>'] = { 'accept', 'fallback' },

					['<Tab>'] = { 'select_next', 'fallback' },
					['<S-Tab>'] = { 'select_prev', 'fallback' },

					['<C-j>'] = { 'scroll_documentation_up', 'fallback' },
					['<C-k>'] = { 'scroll_documentation_down', 'fallback' },
				}
			},

			appearance = {
				use_nvim_cmp_as_default = true,
				nerd_font_variant = 'mono'
			},

			completion = {
				list = {
					selection = {
						preselect = true,
						auto_insert = true,
					}
				},
				menu = { border = 'single' },
				documentation = {
					auto_show = true,
					auto_show_delay_ms = 500,
				},
				trigger = {
					show_on_x_blocked_trigger_characters = function()
						local blocked = { "'", '"', '(' }
						return blocked
					end,
				},
			},

			snippets = {
				preset = "luasnip",
			},

			sources = {
				default = { 'lsp', 'path', 'snippets', 'buffer' },
			},

			signature = { enabled = true }
		},
	}
}
