-- Albero dei file (stile VS Code)
return {
  {
    "nvim-tree/nvim-tree.lua",
    cmd = { "NvimTreeToggle", "NvimTreeFindFileToggle", "NvimTreeFocus" },
    keys = {
      { "<leader>b", "<cmd>NvimTreeToggle<cr>", desc = "Barra file (apri/chiudi)" },
      { "<leader>B", "<cmd>NvimTreeFindFileToggle<cr>", desc = "Barra file sul file corrente" },
    },
    opts = {
      -- Le cartelle (`nvim .`, `-`) restano a oil.nvim
      disable_netrw = false,
      hijack_netrw = false,
      hijack_directories = { enable = false },

      sync_root_with_cwd = true,
      update_focused_file = { enable = true },
      view = { side = "left", width = 30 },
      filters = { dotfiles = false, custom = { "^\\.git$" } },
      git = { enable = true, ignore = false },
      actions = { open_file = { quit_on_open = false } },

      -- Icone testuali
      renderer = {
        group_empty = true,
        highlight_git = "name",
        indent_markers = { enable = true },
        icons = {
          show = { file = false, folder = false, folder_arrow = true, git = true },
          glyphs = {
            folder = { arrow_closed = "+", arrow_open = "-" },
            git = {
              unstaged = "M", staged = "S", unmerged = "U", renamed = "R",
              untracked = "?", deleted = "D", ignored = "!",
            },
          },
        },
      },
    },
    config = function(_, opts)
      require("nvim-tree").setup(opts)

      -- Chiudi Neovim se resta solo la barra
      vim.api.nvim_create_autocmd("QuitPre", {
        group = vim.api.nvim_create_augroup("nvim_tree_autoclose", { clear = true }),
        callback = function()
          local wins = vim.tbl_filter(function(w)
            return vim.api.nvim_win_get_config(w).relative == ""
          end, vim.api.nvim_tabpage_list_wins(0))
          if #wins == 2 and vim.bo.filetype ~= "NvimTree" then
            local api = require("nvim-tree.api")
            if api.tree.is_visible() then
              api.tree.close()
            end
          end
        end,
      })
    end,
  },
}
