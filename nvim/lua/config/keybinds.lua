vim.g.mapleader = " "
vim.keymap.set('n', '-', "<cmd>Oil<CR>")

vim.keymap.set('n', "<leader>a", "G$vgg0")
vim.keymap.set('t', "<Esc>", "<C-\\><C-n>")

-- Quickfix
vim.keymap.set('', "<M-j>", "<cmd>cnext<CR>")
vim.keymap.set('', "<M-k>", "<cmd>cprev<CR>")

-- LSP bindings
vim.keymap.set('', "<leader><leader>", vim.lsp.buf.hover)
vim.keymap.set('', "<leader>ca", vim.lsp.buf.code_action)
vim.keymap.set('', "<leader>e", vim.diagnostic.open_float)
vim.keymap.set('', "<leader>n", vim.diagnostic.goto_next)
vim.keymap.set('', "<leader>p", vim.diagnostic.goto_prev)
vim.keymap.set('', "gd", vim.lsp.buf.definition)
vim.keymap.set('', "<leader>gd", vim.lsp.buf.definition)
vim.keymap.set('', "<leader>rn", vim.lsp.buf.rename)

-- Disable arrow keys
vim.keymap.set({ 'n', 'v', 'i' }, "<Left>", "<nop>")
vim.keymap.set({ 'n', 'v', 'i' }, "<Right>", "<nop>")
vim.keymap.set({ 'n', 'v', 'i' }, "<Up>", "<nop>")
vim.keymap.set({ 'n', 'v', 'i' }, "<Down>", "<nop>")

-- Enable hjkl in insert mode
vim.keymap.set('i', "<C-k>", "<C-o>k")
vim.keymap.set('i', "<C-j>", "<C-o>j")
vim.keymap.set('i', "<C-h>", "<Left>")
vim.keymap.set('i', "<C-l>", "<Right>")

vim.keymap.set('', "<leader>u", "<cmd>UndotreeToggle<CR>")
vim.keymap.set('', "<Esc>", "<cmd>nohlsearch<CR>")

-- Exit visual mode with esc
vim.keymap.set('v', "<Esc>", "<C-c>")

vim.api.nvim_create_autocmd('TextYankPost', {
	desc = 'Highlight when yanking (copying) text',
	group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
	callback = function()
		vim.highlight.on_yank()
	end,
})
