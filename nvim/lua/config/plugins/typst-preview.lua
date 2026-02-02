return {
  'chomosuke/typst-preview.nvim',
  lazy = false, -- or ft = 'typst'
  version = '1.*',
  opts = {
		port = 8040,
		host = '100.71.4.71',
		dependencies_bin = { ['tinymist'] = 'tinymist' }
	}, -- lazy.nvim will implicitly calls `setup {}`
}
