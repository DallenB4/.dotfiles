return {
    "xiyaowong/transparent.nvim",
    config = function()
        local extra_groups = {
            "MiniPickNormal",
            "MiniPickBorder",
            "MiniPickPrompt",
            "MiniMapNormal",
            "MiniNotifyNormal",
            "MiniStatuslineFilename",
            "MiniAnimateNormalFloat"
        }
        if vim.g.neovide then
            require("transparent").setup({
                groups = {},
                extra_groups = extra_groups
            })
        else
            require("transparent").setup({
                groups = {
                    'Normal', 'NormalNC', 'Comment', 'Constant', 'Special', 'Identifier',
                    'Statement', 'PreProc', 'Type', 'Underlined', 'Todo', 'String', 'Function',
                    'Conditional', 'Repeat', 'Operator', 'Structure', 'LineNr', 'NonText',
                    'SignColumn', 'CursorLineNr', 'StatusLine', 'StatusLineNC', 'EndOfBuffer'
                },
                exclude_groups = { "MiniPickMatchCurrent", "MiniPickMatchRanges", "MiniPickMatchMarked", "MiniPickPreviewLine" },
                extra_groups = extra_groups
            })
        end
    end,
}
