-- return {
-- 	"monkoose/neocodeium",
-- 	event = "VeryLazy",
-- 	config = function()
-- 		local neocodeium = require("neocodeium")
-- 		neocodeium.setup()
-- 		vim.keymap.set("i", "<M-CR>", neocodeium.accept)
-- 	end,
-- }
return {
	"Exafunction/codeium.vim",
	event = "BufEnter",
	config = function()
		vim.g.codeium_enabled = 0
		vim.g.codeium_no_map_tab = 0
		vim.g.codeium_disable_bindings = 0

		vim.keymap.set('i', '<M-CR>', function() return vim.fn['codeium#Accept']() end,
			{ expr = true, noremap = true, silent = true })
		vim.keymap.set('i', '<C-;>', function() return vim.fn['codeium#CycleCompletions'](1) end,
			{ expr = true, silent = true })
		vim.keymap.set('i', '<C-,>', function() return vim.fn['codeium#CycleCompletions'](-1) end,
			{ expr = true, silent = true })
		vim.keymap.set('i', '<C-x>', function() return vim.fn['codeium#Clear']() end, { expr = true, silent = true })

		vim.g.codeium_filetypes = {
			nix = true,
		}
	end,
	opts = {
		enable_chat = true,
	}
}
