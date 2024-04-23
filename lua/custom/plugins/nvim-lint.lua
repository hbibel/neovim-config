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

    if vim.fn.filereadable("./node_modules/.bin/xo") then
      -- Note: nvim-lint defines a function for cmd which determines whether
      -- eslint is installed globally or in node_modules, but I don't install
      -- it globally, so I don't need that.
      nvim_lint.linters.eslint.cmd = vim.fn.fnamemodify('./node_modules/.bin/xo', ':p')
      nvim_lint.linters.eslint.args = {
        '--reporter',
        'json',
        '--stdin',
        '--stdin-filename',
        function() return vim.api.nvim_buf_get_name(0) end,
      }
    end

    nvim_lint.linters_by_ft = {
      python = { "mypy", },
      typescript = { "eslint", }
    }

    vim.api.nvim_create_autocmd({ "BufWritePost" }, {
      callback = function()
        require("lint").try_lint()
      end,
    })
  end
}
