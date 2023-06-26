return {
  {
    "mfussenegger/nvim-dap",
    config = function()
      local dap = require('dap')
      dap.adapters.cppdbg = {
        id = 'cppdbg',
        type = 'executable',
        command = '/home/hebaishi/Downloads/cpptools/extension/debugAdapters/bin/OpenDebugAD7',
      }
      dap.adapters.python = function(cb, config)
        if config.request == 'attach' then
          ---@diagnostic disable-next-line: undefined-field
          local port = (config.connect or config).port
          ---@diagnostic disable-next-line: undefined-field
          local host = (config.connect or config).host or '127.0.0.1'
          cb({
            type = 'server',
            port = assert(port, '`connect.port` is required for a python `attach` configuration'),
            host = host,
            options = {
              source_filetype = 'python',
            },
          })
        else
          cb({
            type = 'executable',
            command = vim.fn.expand("~") .. '/.virtualenvs/debugpy/bin/python',
            args = { '-m', 'debugpy.adapter' },
            options = {
              source_filetype = 'python',
            },
          })
        end
      end
      vim.keymap.set('n', '<F5>', function()
        require('dap.ext.vscode').load_launchjs(nil, { cppdbg = {'c', 'cpp'} })
        require('dap').continue()
      end)
      vim.fn.sign_define('DapBreakpoint', {text='', texthl='', linehl='', numhl=''})
      vim.fn.sign_define('DapStopped', {text='󰁔', texthl='', linehl='', numhl=''})
    end
  },
  "sakhnik/nvim-gdb",
  {
    "rcarriga/nvim-dap-ui",
    lazy = false,
    dependencies = {
      "mfussenegger/nvim-dap"
    },
    config = function()
      require("dapui").setup()
      local dap, dapui = require("dap"), require("dapui")
      dap.listeners.after.event_initialized["dapui_config"] = function()
        dapui.open()
      end
      dap.listeners.before.event_terminated["dapui_config"] = function()
        dapui.close()
      end
      dap.listeners.before.event_exited["dapui_config"] = function()
        dapui.close()
      end
    end
  },
}
