return {
	'nvim-lualine/lualine.nvim',
	opts = function(_, opts)
		return {
			options = {
				icons_enabled = true,
				component_separators = { left = '', right = '' },
				section_separators = { left = '', right = '' },
			}
		}
	end,
}
