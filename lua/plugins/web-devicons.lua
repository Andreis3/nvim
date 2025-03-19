return {
  -- Outros plugins

  -- Plugin nvim-web-devicons
  {
    "kyazdani42/nvim-web-devicons",
    config = function()
      require'nvim-web-devicons'.setup {
        default = true,  -- Ativa ícones para tipos de arquivos padrão
        override = {
          go = {
            icon = "",
            color = "#519aba",  -- Cor do ícone
            name = "Go",
          },
          -- Personalize outros tipos de arquivos aqui
        },
      }
    end
  }

  -- Outros plugins
}
