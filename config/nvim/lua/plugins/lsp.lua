return {
  {
    "mason-org/mason.nvim",
    lazy = false,
    opts = {
      ui = { icons = { package_installed = "o", package_pending = "~", package_uninstalled = "x" } },
    },
  },
  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    lazy = false,
    dependencies = { "mason-org/mason.nvim" },
    -- clangd e gdb arrivano dal sistema (dnf), non da Mason
    opts = { ensure_installed = { "pyright", "ruff", "debugpy" } },
  },
  {
    "neovim/nvim-lspconfig",
    lazy = false,
    dependencies = { "mason-org/mason.nvim", "saghen/blink.cmp" },
    config = function()
      vim.lsp.config("*", {
        capabilities = require("blink.cmp").get_lsp_capabilities(),
      })

      vim.lsp.config("pyright", {
        root_markers = {
          ".venv", "venv", "pyproject.toml", "setup.py", "setup.cfg",
          "requirements.txt", "Pipfile", "pyrightconfig.json", ".git",
        },
        before_init = function(_, config)
          config.settings = config.settings or {}
          config.settings.python = config.settings.python or {}
          config.settings.python.pythonPath = require("config.util").python(config.root_dir)
        end,
        settings = {
          pyright = { disableOrganizeImports = true },
        },
      })

      vim.lsp.config("clangd", {
        cmd = {
          "clangd", "--background-index", "--clang-tidy",
          "--header-insertion=iwyu", "--completion-style=detailed",
        },
      })

      vim.lsp.enable({ "pyright", "ruff", "clangd" })

      vim.api.nvim_create_autocmd("LspAttach", {
        callback = function(args)
          local client = vim.lsp.get_client_by_id(args.data.client_id)
          local function map(lhs, rhs, desc)
            vim.keymap.set("n", lhs, rhs, { buffer = args.buf, desc = desc })
          end

          map("gd", vim.lsp.buf.definition, "Vai alla definizione")
          map("gD", vim.lsp.buf.declaration, "Vai alla dichiarazione")
          map("<leader>cr", vim.lsp.buf.rename, "Rinomina simbolo")
          map("<leader>ca", vim.lsp.buf.code_action, "Azioni sul codice")

          if client and client.name == "clangd" then
            map("<leader>ch", "<cmd>LspClangdSwitchSourceHeader<cr>", "Passa tra .c e .h")
          end
          -- Hover solo da pyright
          if client and client.name == "ruff" then
            client.server_capabilities.hoverProvider = false
          end
        end,
      })
    end,
  },
  {
    "saghen/blink.cmp",
    version = "1.*",
    event = "InsertEnter",
    opts = {
      keymap = { preset = "default" },
      completion = {
        documentation = { auto_show = true },
        menu = {
          draw = { columns = { { "label", "label_description", gap = 1 }, { "kind" } } },
        },
      },
      signature = { enabled = true },
      sources = { default = { "lsp", "path", "buffer" } },
    },
  },
  {
    "stevearc/conform.nvim",
    event = "BufWritePre",
    cmd = "ConformInfo",
    keys = {
      {
        "<leader>cf",
        function() require("conform").format({ lsp_format = "fallback" }) end,
        desc = "Formatta",
      },
      {
        "<leader>cF",
        function()
          vim.g.disable_autoformat = not vim.g.disable_autoformat
          vim.notify("Formattazione al salvataggio: " .. (vim.g.disable_autoformat and "OFF" or "ON"))
        end,
        desc = "Attiva/disattiva formattazione al salvataggio",
      },
    },
    opts = {
      formatters_by_ft = {
        python = { "ruff_organize_imports", "ruff_format" },
        c = { "clang-format" },
        cpp = { "clang-format" },
      },
      format_on_save = function()
        if vim.g.disable_autoformat then
          return
        end
        return { timeout_ms = 1000, lsp_format = "fallback" }
      end,
    },
  },
}
