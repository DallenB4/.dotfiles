
return {
    "https://github.com/nvim-mini/mini.pick",
    config = function()
        local pick = require("mini.pick")
        pick.setup({
            options = {
                content_from = true
            }
        })
        vim.keymap.set('n', "<leader>fd", function() pick.builtin.files() end)
        vim.keymap.set('n', "<leader>en", function()
            pick.builtin.files({}, { source = { cwd = vim.fn.stdpath("config") }})
        end)
        vim.keymap.set('n', "<leader>mg", function() pick.builtin.grep_live() end)
    end
}
