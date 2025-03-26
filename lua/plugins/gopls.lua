return {
  {
    "AstroNvim/astrolsp",
    opts = function(_, opts)
      -- Garante que a estrutura de configuração do gopls existe
      opts.config = opts.config or {}
      opts.config.gopls = opts.config.gopls or {}
      opts.config.gopls.settings = opts.config.gopls.settings or {}
      opts.config.gopls.settings.gopls = opts.config.gopls.settings.gopls or {}

      -- Adiciona ou sobrescreve apenas o buildFlags
      opts.config.gopls.settings.gopls.buildFlags = { "-tags", "integration unit" }

      -- Aqui entra o filtro de diagnósticos
      local orig_publish_diagnostics = vim.lsp.handlers["textDocument/publishDiagnostics"]
      vim.lsp.handlers["textDocument/publishDiagnostics"] = function(err, result, ctx, config)
        if result and result.diagnostics then
          result.diagnostics = vim.tbl_filter(function(diagnostic)
            return not diagnostic.message:match("no go files to analyze")
          end, result.diagnostics)
        end
        orig_publish_diagnostics(err, result, ctx, config)
      end

      return opts
    end,
  },
}