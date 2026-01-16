-- if true then return {} end -- WARN: REMOVE THIS LINE +TO ACTIVATE THIS FILE

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
        enabled = true, -- Ativa sugestões inline
        auto_trigger = true, -- Sugestão aparece enquanto digita
        debounce = 75, -- (opcional) reduz o delay entre sugestões
        keymap = {
          accept = "<C-l>", -- (exemplo) aceitar sugestão com Ctrl+L
          next = "<M-]>", -- (opcional) sugestão seguinte
          prev = "<M-[>", -- (opcional) sugestão anterior
          dismiss = "<C-]>",
        },
      },
        filetypes = {
          -- Lista de tipos de arquivo onde o Copilot está ativo
          ["*"] = true, -- Ativa para todos os tipos de arquivo
          markdown = false, -- Desativa para markdown
          help = false, -- Desativa para ajuda
          gitcommit = false, -- Desativa para commits do Git
        },
        copilot_node_command = "node", -- Comando do Node.js usado pelo Copilot
      })
    end,
  },
  {
    "CopilotC-Nvim/CopilotChat.nvim",
    dependencies = {
      { "zbirenbaum/copilot.lua" },
      { "nvim-lua/plenary.nvim" },
    },
    cmd = {
      "CopilotChat",
      "CopilotChatOpen",
      "CopilotChatClose",
      "CopilotChatToggle",
      "CopilotChatExplain",
      "CopilotChatReview",
      "CopilotChatFix",
      "CopilotChatOptimize",
      "CopilotChatDocs",
      "CopilotChatTests",
      "CopilotChatCommit",
      "CopilotChatModels",
      "CopilotChatPrompts",
      "CopilotChatRename",
    },
    opts = {
      show_help = "yes",
      debug = false,

      prompts = {
        -- 1) Auditoria Clean Code (seleção)
        CleanCodeAudit = {
          prompt = table.concat({
            "Observação: responda sempre em português brasileiro.",
            "Faça uma auditoria de Clean Code no trecho selecionado.",
            "Aponte:",
            "1) nomes ruins / ambíguos e sugestões melhores",
            "2) funções longas, responsabilidades misturadas (SRP)",
            "3) duplicações, acoplamento e pontos de refatoração",
            "4) melhorias de legibilidade (guard clauses, early returns, etc.)",
            "5) sugestões concretas com exemplos curtos de código",
            "Responda em bullets, com ações priorizadas (P0/P1/P2).",
          }, "\n"),
          selection = function(source)
            local select = require("CopilotChat.select")
            return select.visual(source)
          end,
        },

        -- 2) Caça-bugs / falhas (seleção)
        BugRiskAudit = {
          prompt = table.concat({
            "Observação: responda sempre em português brasileiro.",
            "Analise o trecho selecionado e encontre falhas, bugs prováveis e riscos.",
            "Procure por:",
            "- null/nil e panics",
            "- erros ignorados e tratamento fraco",
            "- concorrência (race, deadlock, leak), uso de goroutines/channels",
            "- validações ausentes, edge cases",
            "- segurança (injeção, vazamento de dados, permissões)",
            "- performance (alocações, loops, IO, N+1, etc.)",
            "Para cada ponto: descreva o problema, impacto e correção sugerida.",
          }, "\n"),
          selection = function(source)
            local select = require("CopilotChat.select")
            return select.visual(source)
          end,
        },

        -- 3) Arquivo inteiro: revisão arquitetural + robustez
        FileReview = {
          prompt = table.concat({
            "#buffer:active",
            "Observação: responda sempre em português brasileiro.",
            "Faça review do arquivo inteiro com foco em robustez e qualidade.",
            "Quero:",
            "1) resumo do que o arquivo faz",
            "2) riscos e falhas (P0/P1/P2)",
            "3) oportunidades de refatoração (SRP, coesão, acoplamento)",
            "4) melhorias de logs/observabilidade",
            "5) sugestões de testes (o que testar e por quê).",
            "Se possível, proponha um refactor incremental em passos.",
          }, "\n"),
          selection = function(source)
            local select = require("CopilotChat.select")
            return select.buffer(source)
          end,
        },

        -- 4) Checklist de código (seleção): “o que eu revisaria num PR”
        PRChecklist = {
          prompt = table.concat({
            "Observação: responda sempre em português brasileiro.",
            "Aja como reviewer de PR extremamente criterioso.",
            "Gere um checklist aplicado ao trecho selecionado, cobrindo:",
            "- clareza de nomes e intenção",
            "- estrutura e complexidade ciclomática",
            "- erros e retornos",
            "- validações e invariantes",
            "- concorrência (se houver)",
            "- segurança e dados sensíveis",
            "- logs/metrics/tracing (quando aplicável)",
            "- testes e casos de borda",
            "Ao final, dê um parecer: APROVAR / PEDIR AJUSTES / BLOQUEAR e por quê.",
          }, "\n"),
          selection = function(source)
            local select = require("CopilotChat.select")
            return select.visual(source)
          end,
        },
      },
    },
    config = function(_, opts)
      require("CopilotChat").setup(opts)
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
          ["<Leader>cp"] = {
            function() require("copilot.suggestion").dismiss() end,
            desc = "Fechar sugestão do Copilot",
          },
          ["<Leader>cc"] = {
            function() require("CopilotChat").toggle() end,
            desc = "Abrir/Fechar chat do Copilot",
          },
          ["<Leader>cq"] = {
            function()
              local input = vim.fn.input("Pergunte ao Copilot: ")
              require("CopilotChat").ask(input)
            end,
            desc = "Perguntar ao Copilot",
          },

          -- ✅ Estilo do vídeo (normal mode)
          ["<Leader>zc"] = { "<Cmd>CopilotChat<CR>", desc = "CopilotChat: abrir" },
          ["<Leader>zm"] = { "<Cmd>CopilotChatModels<CR>", desc = "CopilotChat: modelos" },
          ["<Leader>zp"] = { "<Cmd>CopilotChatPrompts<CR>", desc = "CopilotChat: prompts" },
          ["<Leader>zM"] = { "<Cmd>CopilotChatCommit<CR>", desc = "CopilotChat: commit msg" },
        },
        v = {
          -- ✅ Estilo do vídeo (visual mode - usa a seleção)
          ["<Leader>ze"] = { "<Cmd>CopilotChatExplain<CR>", desc = "CopilotChat: explicar seleção" },
          ["<Leader>zr"] = { "<Cmd>CopilotChatReview<CR>", desc = "CopilotChat: review seleção" },
          ["<Leader>zf"] = { "<Cmd>CopilotChatFix<CR>", desc = "CopilotChat: corrigir seleção" },
          ["<Leader>zo"] = { "<Cmd>CopilotChatOptimize<CR>", desc = "CopilotChat: otimizar seleção" },
          ["<Leader>zd"] = { "<Cmd>CopilotChatDocs<CR>", desc = "CopilotChat: docs seleção" },
          ["<Leader>zt"] = { "<Cmd>CopilotChatTests<CR>", desc = "CopilotChat: testes seleção" },
          ["<Leader>zs"] = { "<Cmd>CopilotChatCommit<CR>", desc = "CopilotChat: commit (seleção)" },

          -- Prompt custom igual ao vídeo
          ["<Leader>zn"] = { "<Cmd>CopilotChatRename<CR>", desc = "CopilotChat: rename (seleção)" },
        },
        i = {
          ["<Leader>cp"] = {
            function() require("copilot.suggestion").dismiss() end,
            desc = "Fechar sugestão do Copilot",
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
          -- { name = "copilot" }, -- Fonte do Copilot
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