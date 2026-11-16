-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.uv.fs_stat(lazypath) then
  vim.fn.system({
    "git", "clone", "--filter=blob:none", "--branch=stable",
    "https://github.com/folke/lazy.nvim.git", lazypath,
  })
  if vim.v.shell_error ~= 0 then
    error("Impossibile scaricare lazy.nvim")
  end
end
vim.opt.rtp:prepend(lazypath)

-- Setup
require("lazy").setup({
  spec = { { import = "plugins" } },
  install = { colorscheme = { "tokyonight", "habamax" } },
  rocks = { enabled = false },
  change_detection = { notify = false },
  -- Icone testuali
  ui = {
    icons = {
      cmd = "cmd", config = "config", event = "event", favorite = "*", ft = "ft",
      init = "init", import = "import", keys = "keys", lazy = "lazy", loaded = "o",
      not_loaded = "x", plugin = "plugin", runtime = "runtime", require = "require",
      source = "source", start = "start", task = "task",
      list = { "-", "-", "-", "-" },
    },
  },
})
