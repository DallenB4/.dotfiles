vim.o.tabstop = 4
vim.o.shiftwidth = 4
vim.o.signcolumn = "yes"
vim.o.wrap = false
vim.o.ignorecase = true
vim.o.smartcase = true
vim.o.number = true
vim.o.relativenumber = true
vim.o.incsearch = true
vim.o.scrolloff = 10
vim.o.undofile = true
vim.o.termguicolors = true
vim.o.expandtab = true
vim.o.winborder = "single"
vim.o.pumborder = "single"
-- vim.opt.expandtab = true

-- Neovide
vim.g.neovide_window_blurred = true
vim.g.neovide_opacity = 0.8

vim.diagnostic.config {
    float = true,
}

-- Fix for :Inspect command in this version
-- vim.hl = vim.highlight

-- Add border to lsp stuff
require("config.lazy")
require("config.keybinds")
