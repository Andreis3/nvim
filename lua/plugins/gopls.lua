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

      return opts
    end,
  },
}