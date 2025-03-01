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

-- Function to move the current line or selection up/down, skipping empty lines
local function move_line_or_selection(direction)
	local mode = vim.fn.mode()
	local start_line, end_line

	if mode == "v" or mode == "V" then
		-- Visual mode: get the start and end of the selection
		start_line = vim.fn.line("'<")
		end_line = vim.fn.line("'>")
	else
		-- Normal mode: operate on the current line
		start_line = vim.fn.line(".")
		end_line = start_line
	end

	-- Determine the direction (step) and target swap line
	local step = direction == "up" and -1 or 1
	local swap_line = start_line + step

	-- Find the next non-blank line in the given direction
	while swap_line > 0 and swap_line <= vim.fn.line("$") and vim.fn.getline(swap_line):match("^%s*$") do
		swap_line = swap_line + step
	end

	-- If valid swap line found, swap the text blocks
	if swap_line > 0 and swap_line <= vim.fn.line("$") then
		local lines_to_move = vim.fn.getline(start_line, end_line)
		local swap_lines = vim.fn.getline(swap_line)

		vim.fn.setline(swap_line, lines_to_move)
		vim.fn.setline(start_line, swap_lines)

		-- Reposition the cursor after the swap.
		if mode == "v" or mode == "V" then
			-- Exit visual mode then reselect the block at the new location.
			vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>", true, false, true), "n", false)
			local new_start = swap_line
			local new_end = swap_line + (end_line - start_line)
			vim.cmd("normal! " .. new_start .. "G")
			vim.cmd("normal! V" .. new_end .. "G")
		else
			-- For normal mode, move cursor to the target line (swapped line).
			vim.cmd("normal! " .. swap_line .. "G")
		end
	end
end

-- Key mappings
vim.keymap.set("n", "<A-k>", function() move_line_or_selection("up") end, { noremap = true, silent = true })
vim.keymap.set("n", "<A-j>", function() move_line_or_selection("down") end, { noremap = true, silent = true })
vim.keymap.set("v", "<A-k>", function() move_line_or_selection("up") end, { noremap = true, silent = true })
vim.keymap.set("v", "<A-j>", function() move_line_or_selection("down") end, { noremap = true, silent = true })
