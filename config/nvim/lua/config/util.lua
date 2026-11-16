local M = {}

-- Interprete Python del progetto: $VIRTUAL_ENV → .venv/venv → python3
function M.python(root)
  root = root or vim.fs.root(0, { ".venv", "venv" }) or vim.fn.getcwd()
  local active = os.getenv("VIRTUAL_ENV")
  if active and vim.fn.executable(active .. "/bin/python") == 1 then
    return active .. "/bin/python"
  end
  for _, dir in ipairs({ ".venv", "venv" }) do
    local path = root .. "/" .. dir .. "/bin/python"
    if vim.fn.executable(path) == 1 then
      return path
    end
  end
  return vim.fn.exepath("python3")
end

return M
