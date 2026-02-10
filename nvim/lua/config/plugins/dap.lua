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

        dap.adapters.lldb = {
            type = 'executable',
            -- This command forces the use of the system lldb-dap
            command = '/usr/bin/xcrun',
            args = { 'lldb-dap' },
            name = 'lldb'
        }

        -- 2. Define the configuration
        dap.configurations.c = {
            {
                name = 'Launch (Native LLDB)',
                type = 'lldb',
                request = 'launch',
                program = function()
                    return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
                end,
                cwd = '${workspaceFolder}',
                stopOnEntry = false,
                args = {},
            },
        }

        require('mason-nvim-dap').setup({
            automatic_setup = true,
            automatic_installation = false,
            ensure_installed = {},
            handlers = {
                function(config)
                    require('mason-nvim-dap').default_setup(config)
                end,
            }
        })

        dapui.setup()
        vim.cmd("hi DapStopped guifg=#fa4848")
        vim.fn.sign_define("DapBreakpoint", { text = "●", texthl = "DapStopped", linehl = "", numhl = ""})

        dap.listeners.before.attach.dapui_config = function()
            dapui.open()
        end
        dap.listeners.before.launch.dapui_config = function()
            dapui.open()
        end
        dap.listeners.before.event_terminated.dapui_config = function()
            dapui.close()
        end
        dap.listeners.before.event_exited.dapui_config = function()
            dapui.close()
        end

        -- require("dap.ext.vscode").json_decode = require("json5").parse

        -- Keymaps
        vim.keymap.set('n', '<leader>du', dapui.toggle, { desc = 'Debug: Toggle UI' })
        vim.keymap.set('n', '<leader>de', dapui.eval, { desc = 'Debug: Eval' })
        vim.keymap.set('n', '<leader>db', dap.toggle_breakpoint, { desc = 'Debug: Eval' })
    end
}
