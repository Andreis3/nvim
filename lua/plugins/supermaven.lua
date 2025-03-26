if true then return {} end -- WARN: REMOVE THIS LINE TO ACTIVATE THIS FILE


return {
  {
    "supermaven-inc/supermaven-nvim",
    event = "InsertEnter",
    cmd = { "SupermavenUseFree", "SupermavenUsePro" },
    config = function()
      require("supermaven-nvim").setup({
        disable_inline_completion = true, -- desativa a sugestão automática
        keymaps = {
          accept_suggestion = "<Tab>",
          clear_suggestion = "<C-]>",
          accept_word = "<C-j>",
        },
      })
    end,
  },
  {
    "AstroNvim/astrocore",
    opts = {
      options = {
        g = {
          -- Função global para aceitar sugestões do Supermaven
          ai_accept = function()
            local suggestion = require("supermaven-nvim.completion_preview")
            if suggestion.has_suggestion() then
              vim.schedule(function()
                suggestion.on_accept_suggestion()
              end)
              return true
            end
          end,
        },
      },
      mappings = {
        n = {
          -- Fechar o painel de sugestões do Supermaven
          ["<Leader>sp"] = {
            function()
              require("supermaven-nvim.completion_preview").dismiss()
            end,
            desc = "Fechar painel de sugestões do Supermaven",
          },
          -- Caso deseje adicionar outros mapeamentos específicos para o Supermaven, insira aqui
        },
        i = {
          ["<Leader>sp"] = {
            function()
              require("supermaven-nvim.completion_preview").dismiss()
            end,
            desc = "Fechar painel de sugestões do Supermaven",
          },
        },
      },
    },
  },
  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      "supermaven-inc/supermaven-nvim", -- Integração com o Supermaven
      "hrsh7th/cmp-buffer",           -- Fonte de sugestões do buffer
      "hrsh7th/cmp-path",             -- Fonte de sugestões de caminhos
      "hrsh7th/cmp-nvim-lsp",         -- Fonte de sugestões do LSP
      "L3MON4D3/LuaSnip",             -- Integração com o luasnip
      "saadparwaiz1/cmp_luasnip",      -- Fonte de snippets do luasnip
    },
    opts = function()
      local cmp = require("cmp")
      return {
        sources = cmp.config.sources({
          { name = "supermaven" }, -- Fonte do Supermaven
          { name = "nvim_lsp" },   -- Fonte do LSP
          { name = "luasnip" },    -- Fonte de snippets do luasnip
          { name = "buffer" },     -- Fonte do buffer
          { name = "path" },       -- Fonte de caminhos
        }),
        mapping = {
          -- Enter para selecionar sugestão sem quebra de linha
          ["<CR>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.confirm({ select = true })
            else
              fallback()
            end
          end, { "i" }),
          -- Navegação padrão com setas e Tab/Shift+Tab
          ["<Up>"] = cmp.mapping.select_prev_item(),
          ["<Down>"] = cmp.mapping.select_next_item(),
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
          ["<S-Tab>"] = cmp.mapping(function(fallback)
            local luasnip_avail, luasnip = pcall(require, "luasnip")
            if luasnip_avail and luasnip.jumpable(-1) then
              luasnip.jump(-1)
              return
            end
            fallback()
          end, { "i", "s" }),
          -- Fechar o menu de sugestões com Ctrl+e
          ["<C-e>"] = cmp.mapping.abort(),
          -- Abrir o menu de sugestões com Ctrl+Space
          ["<C-Space>"] = cmp.mapping.complete(),
        },
      }
    end,
  },
}
