vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.clipboard = "unnamedplus"
vim.wo.number = true
vim.wo.relativenumber = true
vim.opt.scrolloff = 10
vim.opt.undofile = true
vim.opt.termguicolors = true
-- vim.opt.expandtab = true

vim.diagnostic.config {
	float = true,
}

-- Fix for :Inspect command in this version
vim.hl = vim.highlight

-- Add border to lsp stuff
local _border = "single"
vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(
	vim.lsp.handlers.hover, {
		border = _border
	}
)
vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(
	vim.lsp.handlers.signature_help, {
		border = _border
	}
)

require("config.lazy")
require("config.keybinds")
