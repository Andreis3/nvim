if true then return {} end -- WARN: REMOVE THIS LINE TO ACTIVATE THIS FILE

return {
  {
    "github/copilot.vim",
    cmd = "Copilot",
    event = "InsertEnter",
    init = function()
      -- IMPORTANTÍSSIMO: não roubar o <Tab> (pra não conflitar com cmp/luasnip)
      vim.g.copilot_no_tab_map = true

      -- desativar em alguns filetypes (opcional)
      vim.g.copilot_filetypes = {
        markdown = false,
        help = false,
        gitcommit = false,
        ["*"] = true,
      }
    end,
    config = function()
      -- aceitar sugestão (troque a tecla se quiser)
      vim.keymap.set("i", "<C-l>", 'copilot#Accept("\\<CR>")', {
        expr = true,
        replace_keycodes = false,
      })

      -- navegar sugestões (opcional)
      vim.keymap.set("i", "<M-]>", "<Plug>(copilot-next)", {})
      vim.keymap.set("i", "<M-[>", "<Plug>(copilot-previous)", {})
      vim.keymap.set("i", "<C-]>", "<Plug>(copilot-dismiss)", {})
    end,
  },
}
