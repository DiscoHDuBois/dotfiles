return {
  "mfussenegger/nvim-dap",
  dependencies = {
    "rcarriga/nvim-dap-ui",
    "nvim-neotest/nvim-nio",
    "mfussenegger/nvim-dap-python",
  },
  keys = {
    { "<F5>", function() require("dap").continue() end, desc = "Debug: avvia/continua" },
    { "<F10>", function() require("dap").step_over() end, desc = "Debug: step over" },
    { "<F11>", function() require("dap").step_into() end, desc = "Debug: step into" },
    { "<F12>", function() require("dap").step_out() end, desc = "Debug: step out" },
    { "<leader>db", function() require("dap").toggle_breakpoint() end, desc = "Breakpoint" },
    { "<leader>dt", function() require("dap").terminate() end, desc = "Termina" },
    { "<leader>du", function() require("dapui").toggle() end, desc = "Interfaccia debug" },
  },
  config = function()
    local dap, dapui = require("dap"), require("dapui")

    dapui.setup({ controls = { enabled = false } })
    dap.listeners.after.event_initialized["dapui"] = function() dapui.open() end
    dap.listeners.before.event_terminated["dapui"] = function() dapui.close() end
    dap.listeners.before.event_exited["dapui"] = function() dapui.close() end

    -- Python (debugpy da Mason, programma col Python del progetto)
    require("dap-python").setup(vim.fn.stdpath("data") .. "/mason/packages/debugpy/venv/bin/python")
    require("dap-python").resolve_python = function()
      return require("config.util").python()
    end

    -- C (gdb, DAP nativo)
    dap.adapters.gdb = {
      type = "executable",
      command = "gdb",
      args = { "--interpreter=dap", "--eval-command", "set print pretty on" },
    }
    dap.configurations.c = {
      {
        name = "Avvia eseguibile (gdb)",
        type = "gdb",
        request = "launch",
        program = function()
          return vim.fn.input("Eseguibile: ", vim.fn.expand("%:p:r"), "file")
        end,
        cwd = "${workspaceFolder}",
      },
    }
    dap.configurations.cpp = dap.configurations.c
  end,
}
