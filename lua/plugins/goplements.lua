if true then return {} end -- WARN: REMOVE THIS LINE TO ACTIVATE THIS FILE
return {
  {
    "maxandron/goplements.nvim",
    ft = "go", -- Carrega apenas para arquivos Go
    opts = {
      prefix = {
        interface = "implemented by: ",
        struct = "implements: ",
      },
      display_package = true,
      highlight = "Goplements",
    },
  },
}
