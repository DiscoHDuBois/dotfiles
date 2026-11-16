return {
  {
    "folke/tokyonight.nvim",
    lazy = false,
    priority = 1000,
    config = function()
      require("tokyonight").setup({ style = "night" })
      vim.cmd.colorscheme("tokyonight")
    end,
  },
  {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    opts = {
      options = {
        icons_enabled = false,
        section_separators = "",
        component_separators = "|",
      },
    },
  },
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = {
      icons = {
        mappings = false,
        keys = {
          Up = "Up ", Down = "Down ", Left = "Left ", Right = "Right ",
          C = "C-", M = "M-", S = "S-", CR = "CR ", Esc = "Esc ",
          BS = "BS ", Space = "SPC ", Tab = "Tab ",
          F5 = "F5", F10 = "F10", F11 = "F11", F12 = "F12",
        },
      },
      spec = {
        { "<leader>f", group = "Cerca" },
        { "<leader>d", group = "Debug" },
        { "<leader>c", group = "Codice" },
        { "<leader>x", group = "Errori" },
      },
    },
  },
}
