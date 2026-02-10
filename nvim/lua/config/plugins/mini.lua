return {
    {
        "echasnovski/mini.nvim",
        priority = 1000,
        version = false,
        dependencies = {
            "rafamadriz/friendly-snippets",
        },
        config = function()
            -- mini.starter
            local MiniStarter = require("mini.starter")
            MiniStarter.setup({
                items = {
                    MiniStarter.sections.builtin_actions()
                }
            })

            -- mini.icons
            local MiniIcons = require("mini.icons")
            MiniIcons.setup()
            MiniIcons.tweak_lsp_kind()
            MiniIcons.mock_nvim_web_devicons()

            -- mini.misc
            local MiniMisc = require("mini.misc")
            MiniMisc.setup()
            MiniMisc.setup_auto_root()

            -- mini.cmdline
            require("mini.cmdline").setup()

            -- mini.indentscope
            local MiniIndentscope = require("mini.indentscope")
            MiniIndentscope.setup {
                draw = {
                    animation = MiniIndentscope.gen_animation.quadratic({
                        easing = "out",
                        duration = 20,
                        unit = "step"
                    })
                }
            }

            -- mini.map
            local MiniMap = require("mini.map")
            vim.keymap.set('n', "<leader>mm", MiniMap.toggle, { silent = true })
            MiniMap.setup({
                symbols = {
                    encode = MiniMap.gen_encode_symbols.dot('4x2')
                }
            })
            MiniMap.open()

            -- mini.move
            require("mini.move").setup({
                mappings = {
                    left = "H",
                    right = "L",
                    down = "J",
                    up = "K",
                    line_left = "H",
                    line_right = "L",
                    line_down = "J",
                    line_up = "K",
                }
            })

            -- mini.pairs
            require("mini.pairs").setup()

            -- mini.splitjoin
            require("mini.splitjoin").setup({
                mappings = {
                    toggle = "<leader>j"
                }
            })

            -- mini.extra
            local MiniExtra = require("mini.extra")
            MiniExtra.setup()
            vim.keymap.set('n', "<leader>cs", function()
                MiniExtra.pickers.colorschemes()
            end, { silent = true })

            -- mini.animate
            local MiniAnimate = require("mini.animate")
            MiniAnimate.setup({
                cursor = {
                    path = MiniAnimate.gen_path.angle()
                },
                open = { enable = false },
                close = { enable = false }
            })
            vim.g.minianimate_disable = vim.g.neovide or vim.g.remote
            vim.keymap.set('n', "<leader>an", function()
                vim.g.minianimate_disable = not vim.g.minianimate_disable
                print("minianimate: " .. (vim.g.minianimate_disable and "disabled" or "enabled"))
            end, { silent = true })

            -- mini.notify
            require("mini.notify").setup()

            -- mini.completion
            require("mini.completion").setup()

            -- mini.snippets
            local MiniSnippets = require("mini.snippets")
            MiniSnippets.setup({
                snippets = {
                    MiniSnippets.gen_loader.from_lang()
                }
            })
            MiniSnippets.start_lsp_server()

            -- mini.hues
            -- require("mini.hues").setup()
            vim.keymap.set('n', "<leader><CR>", function()
                vim.cmd("colorscheme randomhue")
            end)

            -- mini.pick
            local MiniPick = require("mini.pick")
            MiniPick.setup({
                mappings = {
                    choose_marked = "<C-q>"
                },
                options = {
                    content_from_bottom = true
                }
            })
            vim.keymap.set('n', "<leader>fd", function() MiniPick.builtin.files() end)
            vim.keymap.set('n', "<leader>en", function()
                MiniPick.builtin.files({}, { source = { cwd = vim.fn.stdpath("config") } })
            end)
            vim.keymap.set('n', "<leader>mg", function() MiniPick.builtin.grep_live() end)

            -- mini.diff
            local MiniDiff = require("mini.diff")
            MiniDiff.setup()

            -- mini.git
            local MiniGit = require("mini.git")
            MiniGit.setup()
        end
    }
}
