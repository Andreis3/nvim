return {
  {
    "williamboman/mason-lspconfig.nvim",
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}

      -- troca nome inválido pelo nome correto do lspconfig
      for i, server in ipairs(opts.ensure_installed) do
        if server == "docker-language-server" or server == "docker_language_server" then
          opts.ensure_installed[i] = "dockerls"
        end
      end

      -- (opcional) remove duplicados
      local seen = {}
      opts.ensure_installed = vim.tbl_filter(function(s)
        if seen[s] then return false end
        seen[s] = true
        return true
      end, opts.ensure_installed)
    end,
  },
}
