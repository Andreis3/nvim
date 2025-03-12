return {
  {
    "AstroNvim/astrocore",
    ---@type AstroCoreOpts
    opts = {
      -- Definir a barra de espaço como Leader
      -- mapleader = ",",
      mappings = {
        -- Modo normal
        n = {
          -- Mapear Ctrl + Z para desfazer
          ["<C-z>"] = { "u", desc = "Desfazer (Undo)" },
          -- Mapear Ctrl + Y para refazer
          ["<C-y>"] = { "<C-r>", desc = "Refazer (Redo)" },
          -- Mapear Ctrl + / para comentar a linha atual
          ["<C-_>"] = {
            function()
              require("Comment.api").toggle.linewise.current()
            end,
            desc = "Comentar/Descomentar linha",
          },
          -- Dividir horizontalmente e abrir um arquivo
          ["<Leader>sh"] = { ":split<CR>", desc = "Dividir horizontalmente" },
          -- Dividir verticalmente e abrir um arquivo
          ["<Leader>sv"] = { ":vsplit<CR>", desc = "Dividir verticalmente" },
          -- Abrir arquivo com divisão horizontal usando Telescope
          ["<Leader>fh"] = {
            function()
              require("telescope.builtin").find_files({ previewer = false, layout_config = { horizontal = { width = 0.5 } } })
            end,
            desc = "Abrir arquivo com divisão horizontal",
          },
          -- Abrir arquivo com divisão vertical usando Telescope
          ["<Leader>fv"] = {
            function()
              require("telescope.builtin").find_files({ previewer = false, layout_config = { vertical = { width = 0.5 } } })
            end,
            desc = "Abrir arquivo com divisão vertical",
          },
          -- Fechar a janela atual
          ["<Leader>wc"] = { ":close<CR>", desc = "Fechar janela atual" },
          -- Fechar todas as outras janelas, exceto a atual
          ["<Leader>wo"] = { ":only<CR>", desc = "Fechar outras janelas" },
        },
        -- Modo de inserção
        i = {
          -- Mapear Ctrl + Z para desfazer no modo de inserção
          ["<C-z>"] = { "<C-o>u", desc = "Desfazer (Undo)" },
          -- Mapear Ctrl + Y para refazer no modo de inserção
          ["<C-y>"] = { "<C-o><C-r>", desc = "Refazer (Redo)" },
          -- Mapear Ctrl + / para comentar a linha atual
          ["<C-_>"] = {
            function()
              require("Comment.api").toggle.linewise.current()
            end,
            desc = "Comentar/Descomentar linha",
          },
          -- Fechar a caixa de sugestão e manter o modo de inserção
          -- ["<Esc>"] = {
          --   function()
          --     -- Verifica se a caixa de sugestão está aberta
          --     if vim.fn.pumvisible() == 1 then
          --       -- Fecha a caixa de sugestão
          --       vim.fn.complete_info({ "close" })
          --       -- Retorna ao modo normal e imediatamente ao modo de inserção
          --       return vim.api.nvim_replace_termcodes("<C-e><Esc>", true, false, true)
          --     else
          --       -- Se não houver caixa de sugestão, apenas sai do modo de inserção
          --       return vim.api.nvim_replace_termcodes("<Esc>", true, false, true)
          --     end
          --   end,
          --   desc = "Fechar caixa de sugestão e manter modo de inserção",
          --   expr = true, -- Permite que a função retorne uma string de teclas
          -- },
        }, 
      },
    },
  }
  -- {
  --   "AstroNvim/astrolsp",
  --   ---@type AstroLSPOpts
  --   opts = {
  --     mappings = {
  --       -- Aqui você pode adicionar mapeamentos específicos do LSP, se necessário
  --     },
  --   },
  -- },
}