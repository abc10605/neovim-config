local chezmoi_source = vim.fn.expand "~/.local/share/chezmoi"

return {
  "AstroNvim/astrolsp",
  ---@param opts AstroLSPOpts
  opts = function(_, opts)
    opts.config.yamlls = require("astrocore").extend_tbl(opts.config.yamlls or {}, {
      on_attach = function(client, bufnr)
        opts.config.yamlls.on_attach(client, bufnr)

        local bufname = vim.api.nvim_buf_get_name(bufnr)
        local is_tmpl = bufname:match(vim.pesc(chezmoi_source)) and bufname:match "%.tmpl$"

        if is_tmpl then vim.diagnostic.enable(false, { bufnr = bufnr }) end
      end,
    })
  end,
}
