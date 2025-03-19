return {
  {
    "Yu-Leo/gosigns.nvim",
    ft = "go",
    cmd = { "GosignsEnable", "GosignsDisable", "GosignsToggle" },
    opts = {
      interface_implementations = {
        enable = true,
        icon = "󰙅",  -- Ícone de implementação da interface
        hl = "DiagnosticHint",
      },
      struct_implementations = {
        enable = true,
        icon = "",  -- Ícone de implementação da struct
        hl = "DiagnosticWarn",
      },
      struct_methods = {
        enable = true,
        icon = "",  -- Ícone de método de struct
        hl = "DiagnosticError",
      },
      go_comments = {
        enable = true,
        icon = "󰆘",
        hl = "Comment",
      },
    },
    config = function(_, opts)
      require("gosigns").setup(opts)

      -- Ativa o gosigns automaticamente para arquivos Go
      vim.api.nvim_create_autocmd("FileType", {
        pattern = "go",
        callback = function()
          require("gosigns").enable()
        end,
      })
    end,
  }
}
