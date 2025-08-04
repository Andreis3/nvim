if true then return {} end -- WARN: REMOVE THIS LINE TO ACTIVATE THIS FILE


return {
  {
    "Exafunction/codeium.vim",
    event = "InsertEnter",
    config = function()
      -- Desativa as bindings padrão do Codeium para usarmos nossas próprias
      vim.g.codeium_disable_bindings = 1

      -- Desativa a sugestão automática e a renderização automática das sugestões
      vim.g.codeium_manual = false
      vim.g.codeium_render = true

      -- Mapeamentos personalizados para as funções do Codeium
      vim.keymap.set('i', '<C-g>', function() return vim.fn['codeium#Accept']() end, { expr = true, silent = true })
      vim.keymap.set('i', '<C-k>', function() return vim.fn['codeium#AcceptNextWord']() end, { expr = true, silent = true })
      vim.keymap.set('i', '<C-l>', function() return vim.fn['codeium#AcceptNextLine']() end, { expr = true, silent = true })
      vim.keymap.set('i', '<A-;>', '<Cmd>call codeium#CycleOrComplete()<CR>', { silent = true })
      vim.keymap.set('i', '<A-,>', function() return vim.fn['codeium#CycleCompletions'](-1) end, { expr = true, silent = true })
      vim.keymap.set('i', '<C-x>', function() return vim.fn['codeium#Clear']() end, { expr = true, silent = true })
      vim.keymap.set('i', '<M-Bslash>', function() return vim.fn['codeium#Complete']() end, { expr = true, silent = true })
      -- Para iniciar a autenticação, execute :CodeiumAuth após a instalação
    end,
  },
  {
    "AstroNvim/astrocore",
    opts = {
      options = {
        g = {
          -- Função global para aceitar sugestão do Codeium
          ai_accept = function()
            return vim.fn['codeium#Accept']()
          end,
        },
      },
      mappings = {
        n = {
          -- Abrir/Fechar o chat do Codeium
          ["<Leader>cc"] = {
            function()
              vim.cmd("CodeiumChat")
            end,
            desc = "Abrir/Fechar chat do Codeium",
          },
          -- Enviar uma pergunta via chat do Codeium
          ["<Leader>cq"] = {
            function()
              local input = vim.fn.input("Pergunte ao Codeium: ")
              if input ~= "" then
                vim.cmd("CodeiumChat " .. input)
              end
            end,
            desc = "Perguntar ao Codeium",
          },
        },
      },
    },
  },
  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      "Exafunction/codeium.vim",  -- Integração com Codeium para completions
      "hrsh7th/cmp-buffer",        -- Fonte: buffer
      "hrsh7th/cmp-path",          -- Fonte: caminhos
      "hrsh7th/cmp-nvim-lsp",      -- Fonte: LSP
      "L3MON4D3/LuaSnip",          -- Integração com LuaSnip
      "saadparwaiz1/cmp_luasnip",   -- Fonte: snippets do LuaSnip
    },
    opts = function()
      local cmp = require("cmp")
      return {
        sources = cmp.config.sources({
          { name = "codeium" },    -- Fonte do Codeium (registrada pelo plugin)
          { name = "nvim_lsp" },
          { name = "luasnip" },
          { name = "buffer" },
          { name = "path" },
        }),
        mapping = {
          -- Confirma a sugestão ou insere quebra de linha
          ["<CR>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.confirm({ select = true })
            else
              fallback()
            end
          end, { "i" }),
          -- Navegação no menu de completamento
          ["<Up>"] = cmp.mapping.select_prev_item(),
          ["<Down>"] = cmp.mapping.select_next_item(),
          -- <Tab> expande snippet ou chama a função ai_accept (Codeium)
          ["<Tab>"] = cmp.mapping(function(fallback)
            local luasnip_avail, luasnip = pcall(require, "luasnip")
            if luasnip_avail and luasnip.expand_or_jumpable() then
              luasnip.expand_or_jump()
              return
            end
            if vim.g.ai_accept and vim.g.ai_accept() then
              return
            end
            fallback()
          end, { "i", "s" }),
          -- <S-Tab> para navegar para trás em snippets
          ["<S-Tab>"] = cmp.mapping(function(fallback)
            local luasnip_avail, luasnip = pcall(require, "luasnip")
            if luasnip_avail and luasnip.jumpable(-1) then
              luasnip.jump(-1)
              return
            end
            fallback()
          end, { "i", "s" }),
          -- Aborta o completamento com Ctrl+e (Ctrl + e)
          ["<C-e>"] = cmp.mapping.abort(),
          -- Abre o menu de completamento manualmente com Ctrl+Space
          ["<C-Space>"] = cmp.mapping.complete(),
        },
      }
    end,
  },
}
