return {
  setup = function()
    require("conform").setup({
      format_on_save = {
        timeout_ms = 1500,
        lsp_fallback = true,
      },
      log_level = vim.log.levels.DEBUG,
      formatters_by_ft = {
        lua = { "stylua" },
        python = { "isort", "ruff_format" },
        -- Scalafmt standalone is SLOOOOOOOOW, so we fallback to LSP formatting
        -- scala = { "scalafmt" },
        -- Go LSP formatting is fine for now, so no explicit config here
        html = { { "djlint", "prettier" } },
        javascript = { "prettier" },
        javascriptreact = { "prettier" },
        typescript = { "prettier" },
        typescriptreact = { "prettier" },
        astro = { "prettier" },
      },
    })
  end
}
