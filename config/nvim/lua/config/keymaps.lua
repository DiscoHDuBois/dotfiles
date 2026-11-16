local map = vim.keymap.set

-- Generali
map("n", "<Esc>", "<cmd>nohlsearch<cr>")
map("n", "<leader>w", "<cmd>write<cr>", { desc = "Salva" })
map("n", "<leader>q", "<cmd>quit<cr>", { desc = "Chiudi finestra" })

-- Spostamento tra le finestre
map("n", "<C-h>", "<C-w>h", { desc = "Finestra a sinistra" })
map("n", "<C-j>", "<C-w>j", { desc = "Finestra sotto" })
map("n", "<C-k>", "<C-w>k", { desc = "Finestra sopra" })
map("n", "<C-l>", "<C-w>l", { desc = "Finestra a destra" })

-- Terminale
map("t", "<Esc><Esc>", "<C-\\><C-n>", { desc = "Esci dal terminale" })

-- Diagnostica
map("n", "<leader>e", vim.diagnostic.open_float, { desc = "Mostra errore" })
map("n", "<leader>xx", vim.diagnostic.setloclist, { desc = "Lista errori" })

-- Esegui file corrente
local function run_file()
  local ft = vim.bo.filetype
  local file = vim.fn.expand("%:p")
  local esc = vim.fn.shellescape
  local cmd

  if ft == "python" then
    cmd = esc(require("config.util").python()) .. " " .. esc(file)
  elseif ft == "c" then
    local out = esc(vim.fn.expand("%:p:r"))
    cmd = ("gcc -g -Wall -Wextra -o %s %s -lm && %s"):format(out, esc(file), out)
  else
    vim.notify("Nessun comando di esecuzione per: " .. ft, vim.log.levels.WARN)
    return
  end

  vim.cmd.write()
  vim.cmd("botright 12new")
  vim.fn.jobstart({ "sh", "-c", cmd }, { term = true })
  vim.cmd.startinsert()
end

map("n", "<leader>r", run_file, { desc = "Esegui file (Python/C)" })
