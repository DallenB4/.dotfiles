return {
	"christoomey/vim-tmux-navigator",
	config = function()
		vim.keymap.set("", "<C-h>", "<cmd>TmuxNavigateLeft<CR>")
		vim.keymap.set("", "<C-j>", "<cmd>TmuxNavigateDown<CR>")
		vim.keymap.set("", "<C-k>", "<cmd>TmuxNavigateUp<CR>")
		vim.keymap.set("", "<C-l>", "<cmd>TmuxNavigateRight<CR>")
		vim.keymap.set("", "<C-\\>", "<cmd>TmuxNavigatePrevious<CR>")
	end,
}
