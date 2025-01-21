return {
	'saghen/blink.cmp',
	dependencies = 'rafamadriz/friendly-snippets',

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

			cmdline = {
				preset = 'none',
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
			-- { preselect, manual, auto_insert }
			list = {
				selection = {
					auto_insert = function(ctx)
						return ctx.mode == "cmdline" and "auto_insert" or "preselect"
					end,
				}
			},
			menu = { border = 'single' },
			documentation = {
				auto_show = true,
				auto_show_delay_ms = 500,
			},
		},

		signature = { enabled = true }
	},
}
