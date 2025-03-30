vim.keymap.set('n', "<leader>d", ":lua require('neogen').generate()<CR>", { silent = true })
return {
	"danymat/neogen",
	config = true
}
