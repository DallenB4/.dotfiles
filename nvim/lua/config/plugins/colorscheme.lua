return {
    {
        "folke/tokyonight.nvim",
        opts = {
            style = "night",
            on_colors = function(colors)
                colors.comment = "#939cc2"
            end
        }
    },
    {
        "nvim-mini/mini.hues",
        config = function()
            vim.keymap.set('n', "<leader><CR>", function()
                vim.cmd("colorscheme randomhue")
            end)
        end
    },
    {
        "https://github.com/vague-theme/vague.nvim",
        config = true
    }
}
