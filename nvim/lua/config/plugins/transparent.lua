return {
    "xiyaowong/transparent.nvim",
    config = function()
        local extra_groups = {
            "MiniPickNormal",
            "MiniPickBorder",
            "MiniPickPrompt",
            "MiniMapNormal",
            "MiniNotifyNormal"
        }
        if vim.g.neovide then
            require("transparent").setup({
                groups = {},
                extra_groups = extra_groups
            })
        else
            require("transparent").setup({
                exclude_groups = { "MiniPickMatchCurrent", "MiniPickMatchRanges", "MiniPickMatchMarked", "MiniPickPreviewLine" },
                extra_groups = extra_groups
            })
        end
    end,
}
