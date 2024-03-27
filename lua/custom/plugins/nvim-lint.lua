return {
  setup = function()
    local nvim_lint = require("lint")

    if require("custom.python").venv_in_project() then
      nvim_lint.linters.mypy.cmd = "py"
      nvim_lint.linters.mypy.args = {
        "-m",
        "mypy",
        "--show-column-numbers",
        "--show-error-end",
        "--hide-error-codes",
        "--hide-error-context",
        "--no-color-output",
        "--no-error-summary",
        "--no-pretty",
      }
    end

    nvim_lint.linters_by_ft = {
      python = { "mypy", }
    }
    vim.api.nvim_create_autocmd({ "BufWritePost" }, {
      callback = function()
        require("lint").try_lint()
      end,
    })
  end
}
