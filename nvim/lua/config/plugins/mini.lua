return {
    {
        "nvim-mini/mini.starter",
        config = function()
            local MiniStarter = require("mini.starter")
            MiniStarter.setup({
                items = {
                    MiniStarter.sections.builtin_actions()
                }
            })
        end
    },
    {
        "nvim-mini/mini.icons",
        config = function()
            local MiniIcons = require("mini.icons")
            MiniIcons.setup()
            MiniIcons.tweak_lsp_kind()
            MiniIcons.mock_nvim_web_devicons()
        end
    },
    {
        "nvim-mini/mini.misc",
        config = function()
            local MiniMisc = require("mini.misc")
            MiniMisc.setup()
            MiniMisc.setup_auto_root()
        end
    },
    {
        "nvim-mini/mini.cmdline",
        config = true
    },
    {
        "nvim-mini/mini.indentscope",
        config = function()
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
        end
    },
    {
        "nvim-mini/mini.map",
        config = function ()
            local MiniMap = require("mini.map")
            vim.keymap.set('n', "<leader>mm", MiniMap.toggle, { silent = true })
            MiniMap.setup({
                symbols = {
                    encode = MiniMap.gen_encode_symbols.dot('4x2')
                }
            })
            MiniMap.open()
        end
    },
    {
        "nvim-mini/mini.move",
        opts = {
            mappings = {
                left = "<CS-h>",
                right = "<CS-l>",
                down = "<CS-j>",
                up = "<CS-k>",
                line_left = "<CS-h>",
                line_right = "<CS-l>",
                line_down = "<CS-j>",
                line_up = "<CS-k>",
            }
        }
    },
    {
        "nvim-mini/mini.pairs",
        event = "InsertEnter",
        config = true
    },
    {
        "nvim-mini/mini.splitjoin",
        config = true
    },
    {
        "nvim-mini/mini.extra",
        config = function ()
            local MiniExtra = require("mini.extra")
            MiniExtra.setup()
            vim.keymap.set('n', "<leader>cs", function()
                local colorscheme = MiniExtra.pickers.colorschemes()
            end, { silent = true })
        end
    },
    {
        "nvim-mini/mini.animate",
        config = function()
            local MiniAnimate = require("mini.animate")
            MiniAnimate.setup({
                cursor = {
                    enable = true,
                    path = vim.g.neovide and MiniAnimate.gen_path.spiral() or MiniAnimate.gen_path.angle()
                },

            })
        end
    }
}
