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
        "https://github.com/vague-theme/vague.nvim",
        config = true
    }
}