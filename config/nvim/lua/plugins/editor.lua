return {
  {
    "nvim-telescope/telescope.nvim",
    cmd = "Telescope",
    dependencies = {
      "nvim-lua/plenary.nvim",
      { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
    },
    keys = {
      { "<leader>ff", "<cmd>Telescope find_files<cr>", desc = "File" },
      { "<leader>fg", "<cmd>Telescope live_grep<cr>", desc = "Testo nel progetto" },
      { "<leader>fb", "<cmd>Telescope buffers<cr>", desc = "Buffer aperti" },
      { "<leader>fr", "<cmd>Telescope oldfiles<cr>", desc = "File recenti" },
      { "<leader>fd", "<cmd>Telescope diagnostics<cr>", desc = "Errori" },
      { "<leader>fs", "<cmd>Telescope lsp_document_symbols<cr>", desc = "Simboli del file" },
      { "<leader>fh", "<cmd>Telescope help_tags<cr>", desc = "Help" },
    },
    config = function()
      require("telescope").setup({})
      require("telescope").load_extension("fzf")
    end,
  },
  {
    "stevearc/oil.nvim",
    lazy = false,
    keys = { { "-", "<cmd>Oil<cr>", desc = "Apri cartella" } },
    opts = { columns = {}, view_options = { show_hidden = true } },
  },
  {
    "lewis6991/gitsigns.nvim",
    event = { "BufReadPre", "BufNewFile" },
    opts = {},
  },
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    opts = {},
  },
}
