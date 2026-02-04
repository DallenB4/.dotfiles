return {
    "mfussenegger/nvim-dap",
    dependencies = {
        "rcarriga/nvim-dap-ui",
        "nvim-neotest/nvim-nio",
        "williamboman/mason.nvim",
        "jay-babu/mason-nvim-dap.nvim",
    },
    config = function()
        local dap = require("dap")
        local dapui = require("dapui")

        require('mason-nvim-dap').setup({
            automatic_setup = true,
            automatic_installation = false,
            ensure_installed = { },
            handlers = {
                function(config)
                    require('mason-nvim-dap').default_setup(config)
                end
            }
        })

        dapui.setup()

        dap.listeners.before.attach.dapui_config = function()
            dapui.open()
        end
        dap.listeners.before.launch.dapui_config = function()
            dapui.open()
        end
        -- dap.listeners.before.event_terminated.dapui_config = function()
        --     dapui.close()
        -- end
        -- dap.listeners.before.event_exited.dapui_config = function()
        --     dapui.close()
        -- end

        -- Keymaps
        vim.keymap.set('n', '<leader>du', dapui.toggle, { desc = 'Debug: Toggle UI' })
    end
}
