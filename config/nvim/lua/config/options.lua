local o = vim.opt

-- Interfaccia
o.number = true
o.relativenumber = true
o.signcolumn = "yes"
o.cursorline = true
o.scrolloff = 8
o.termguicolors = true
o.wrap = false
o.colorcolumn = "88"

-- Indentazione
o.expandtab = true
o.tabstop = 4
o.shiftwidth = 4
o.softtabstop = 4
o.smartindent = true

-- Ricerca
o.ignorecase = true
o.smartcase = true

-- Comportamento
o.mouse = "a"
o.clipboard = "unnamedplus"
o.undofile = true
o.swapfile = false
o.splitright = true
o.splitbelow = true
o.updatetime = 250
o.timeoutlen = 400
o.confirm = true

-- Diagnostica
vim.diagnostic.config({
  severity_sort = true,
  virtual_text = { spacing = 2, source = "if_many" },
  float = { border = "rounded", source = "if_many" },
})

-- Evidenzia testo copiato
vim.api.nvim_create_autocmd("TextYankPost", {
  callback = function() vim.hl.on_yank() end,
})
