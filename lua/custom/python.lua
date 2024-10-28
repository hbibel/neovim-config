local M = {
  tools_checked = false,
}

---@return boolean
M.venv_in_project = function()
  return M.get_venv_dir() ~= nil
end

---@return string | nil
M.get_venv_dir = function()
  if vim.fn.isdirectory(".venv") ~= 0 then
    return ".venv"
  else
    return nil
  end
end

---@return string[] | nil
M.get_mypy_command = function()
  local venv_dir = M.get_venv_dir()
  if venv_dir ~= nil then
    local mypy_path = venv_dir .. "/bin/mypy"
    if vim.fn.filereadable(mypy_path) == 1 then
      -- args copied from
      -- https://github.com/mfussenegger/nvim-lint/blob/master/lua/lint/linters/mypy.lua
      -- but with the Python executable path fixed. If mypy breaks, check if
      -- something has changed with respect to the arguments
      return {
        mypy_path,
        "--show-column-numbers",
        "--show-error-end",
        "--hide-error-context",
        "--no-color-output",
        "--no-error-summary",
        "--no-pretty",
        "--python-executable",
        venv_dir .. "/bin/python",
      }
    end
  end

  return nil
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

M.attach_lsp = function()
  if M.tools_checked == false then
    local tools = "Python setup"
    if M.get_mypy_command() ~= nil then
      tools = tools .. " ✅ type checking"
    else
      tools = tools .. " ❌ type checking"
    end
    vim.print(tools)

    M.tools_checked = true
  end

  -- TODO also print whether linting and formatting are set up
end

return M
