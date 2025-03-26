if true then return {} end -- WARN: REMOVE THIS LINE TO ACTIVATE THIS FILE

return {
  {
    "zbirenbaum/copilot.lua",
    cmd = "Copilot",
    build = ":Copilot auth",
    event = "InsertEnter",
    config = function()
      require("copilot").setup({
        panel = {
          enabled = true, -- Habilita o painel de sugestões
          auto_refresh = true, -- Atualiza automaticamente as sugestões
          keymap = {
            jump_prev = "[[", -- Navega para a sugestão anterior
            jump_next = "]]", -- Navega para a próxima sugestão
            accept = "<Tab>", -- Aceita a sugestão com Tab
            refresh = "gr", -- Atualiza as sugestões
            open = "<M-CR>", -- Abre o painel de sugestões
          },
        },
        suggestion = {
          enabled = false, -- Desabilita o texto sombreado
          keymap = {
            accept = false, -- Desabilita o mapeamento padrão para aceitar sugestões
          },
        },
      })
    end,
  },
  {
    "CopilotC-Nvim/CopilotChat.nvim",
    dependencies = {
      { "zbirenbaum/copilot.lua" }, -- Dependência do Copilot
      { "nvim-lua/plenary.nvim" },  -- Dependência do Plenary
    },
    opts = {
      show_help = "yes", -- Mostra ajuda na janela de chat
      debug = false,     -- Ative para depuração
    },
    config = function()
      require("CopilotChat").setup({
        -- Configurações adicionais do CopilotChat, se necessário
      })
    end,
  },
  {
    "AstroNvim/astrocore",
    opts = {
      options = {
        g = {
          -- Função para aceitar sugestões do Copilot
          ai_accept = function()
            if require("copilot.suggestion").is_visible() then
              require("copilot.suggestion").accept()
              return true
            end
          end,
        },
      },
      mappings = {
        n = {
          -- Fechar o painel de sugestões com <Leader>cp (ou outro atalho)
          ["<Leader>cp"] = {
            function()
              require("copilot.suggestion").dismiss()
            end,
            desc = "Fechar painel de sugestões do Copilot",
          },
          -- Abrir o chat do Copilot
          ["<Leader>cc"] = {
            function()
              require("CopilotChat").toggle()
            end,
            desc = "Abrir/Fechar chat do Copilot",
          },
          -- Perguntar algo no chat
          ["<Leader>cq"] = {
            function()
              local input = vim.fn.input("Pergunte ao Copilot: ")
              require("CopilotChat").ask(input)
            end,
            desc = "Perguntar ao Copilot",
          },
        },
        i = {
          -- Fechar o painel de sugestões com <Leader>cp (ou outro atalho)
          ["<Leader>cp"] = {
            function()
              require("copilot.suggestion").dismiss()
            end,
            desc = "Fechar painel de sugestões do Copilot",
          },
        },
      },
    },
  },
  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      "zbirenbaum/copilot.lua", -- Integração com o Copilot
      "hrsh7th/cmp-buffer", -- Fonte de sugestões do buffer
      "hrsh7th/cmp-path", -- Fonte de sugestões de caminhos
      "hrsh7th/cmp-nvim-lsp", -- Fonte de sugestões do LSP
      "L3MON4D3/LuaSnip", -- Integração com o luasnip
      "saadparwaiz1/cmp_luasnip", -- Fonte de snippets do luasnip
    },
    opts = function()
      local cmp = require("cmp")
      return {
        sources = cmp.config.sources({
          { name = "copilot" }, -- Fonte do Copilot
          { name = "nvim_lsp" }, -- Fonte do LSP
          { name = "luasnip" }, -- Fonte de snippets do luasnip
          { name = "buffer" }, -- Fonte do buffer
          { name = "path" }, -- Fonte de caminhos
        }),
        mapping = {
          -- Enter para selecionar sugestão sem quebra de linha
          ["<CR>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              -- Se o menu de sugestões estiver visível, seleciona a sugestão
              cmp.confirm({ select = true })
            else
              -- Se não houver sugestão, faz uma quebra de linha
              fallback()
            end
          end, { "i" }),

          -- Navegação padrão com setas e Tab/Shift+Tab
          ["<Up>"] = cmp.mapping.select_prev_item(), -- Seta para cima
          ["<Down>"] = cmp.mapping.select_next_item(), -- Seta para baixo
          ["<Tab>"] = cmp.mapping(function(fallback)
            -- Navegação em snippets
            local luasnip_avail, luasnip = pcall(require, "luasnip")
            if luasnip_avail and luasnip.expand_or_jumpable() then
              luasnip.expand_or_jump()
              return
            end

            -- Aceitar sugestão de IA
            if vim.g.ai_accept and vim.g.ai_accept() then
              return
            end

            -- Comportamento padrão (navegação no completamento)
            fallback()
          end, { "i", "s" }),

          ["<S-Tab>"] = cmp.mapping(function(fallback)
            -- Navegação reversa em snippets
            local luasnip_avail, luasnip = pcall(require, "luasnip")
            if luasnip_avail and luasnip.jumpable(-1) then
              luasnip.jump(-1)
              return
            end

            -- Comportamento padrão
            fallback()
          end, { "i", "s" }),

          -- Fechar o menu de sugestões com Ctrl+e
          ["<C-e>"] = cmp.mapping.abort(), -- Fecha o menu de sugestões

          -- Abrir o menu de sugestões com Ctrl+Space
          ["<C-Space>"] = cmp.mapping.complete(), -- Abre o menu de sugestões
        },
      }
    end,
  },
}