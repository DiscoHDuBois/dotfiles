local M = {}

-- Interprete Python del progetto: $VIRTUAL_ENV → .venv/venv → python3
-- Un venv del progetto viene usato solo dopo averlo approvato (vim.secure): pyright
-- esegue l'interprete all'avvio, quindi un .venv/bin/python di un repo non fidato
-- sarebbe codice eseguito solo aprendo un file. L'approvazione (:trust su pyvenv.cfg)
-- resta salvata per percorso e decade se pyvenv.cfg cambia.
function M.python(root)
  root = root or vim.fs.root(0, { ".venv", "venv" }) or vim.fn.getcwd()
  local active = os.getenv("VIRTUAL_ENV")
  if active and vim.fn.executable(active .. "/bin/python") == 1 then
    return active .. "/bin/python"
  end
  for _, dir in ipairs({ ".venv", "venv" }) do
    local venv = root .. "/" .. dir
    local path = venv .. "/bin/python"
    local cfg = venv .. "/pyvenv.cfg"
    if vim.fn.executable(path) == 1 and vim.uv.fs_stat(cfg) then
      if vim.secure.read(cfg) then
        return path
      end
      vim.notify(
        "venv non approvato, uso python3 di sistema: " .. venv
          .. "\nPer approvarlo: :edit " .. cfg .. " → :trust → :LspRestart",
        vim.log.levels.WARN
      )
    end
  end
  return vim.fn.exepath("python3")
end

return M
