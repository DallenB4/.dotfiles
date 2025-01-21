return {
	'nvim-telescope/telescope.nvim',
	dependencies = {
		'nvim-lua/plenary.nvim',
		{ 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' }
	},
	config = function()
		require("telescope").setup {
			defaults = {
			},
			pickers = {
			},
			extensions = {
				fzf = {}
			},
		}

		require('telescope').load_extension('fzf')

		vim.keymap.set('n', "<leader>fd", require('telescope.builtin').find_files)
		vim.keymap.set('n', "<leader>gf", require('telescope.builtin').git_files)
		-- Search nvim config dir
		vim.keymap.set('n', "<leader>en", function()
			require("telescope.builtin").find_files {
				cwd = vim.fn.stdpath("config")
			}
		end)
		-- Search lazy data dir
		vim.keymap.set('n', "<leader>ep", function()
			require("telescope.builtin").find_files {
				---@diagnostic disable-next-line: param-type-mismatch
				cwd = vim.fs.joinpath(vim.fn.stdpath("data"), "lazy")
			}
		end)
		require "config.telescope.multigrep".setup()
		vim.api.nvim_create_autocmd("User", {
			pattern = "TelescopePreviewerLoaded",
			callback = function()
				vim.wo.wrap = true
			end,
		})
	end
}
