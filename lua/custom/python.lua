local M = {}

M.venv_in_project = function()
  return vim.fn.isdirectory(".venv")
end


M.init = function(on_attach)
  table.insert(require("dap").configurations.python,
    {
      name = "Pytest current file",
      type = "python",
      request = "launch",
      module = "pytest",
      args = { "${file}" },
      justMyCode = "false",
      -- ... more options, see https://github.com/microsoft/debugpy/wiki/Debug-configuration-settings
    }
  )

  local ruff_cmd
  if M.venv_in_project() then
    ruff_cmd = { "py", "-m", "ruff_lsp" }
  else
    ruff_cmd = { "ruff-lsp" }
  end
  require("lspconfig").ruff_lsp.setup {
    cmd = ruff_cmd,
    on_attach = on_attach,
  }
end

return M
