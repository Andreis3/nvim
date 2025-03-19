return {
  {
    "crusj/hierarchy-tree-go.nvim",
    requires = "neovim/nvim-lspconfig",
    ft = "go",
    config = function()
      require("hierarchy-tree-go").setup({
        icon = {
          fold = "",
          unfold = "",
          func = "₣",
          last = "☉",
        },
        hl = {
          current_module = "guifg=Green",
          others_module = "guifg=Black",
          cursorline = "guibg=Gray guifg=White",
        },
        keymap = {
          incoming = "<space>fi",
          outgoing = "<space>fo",
          open = "<space>to",
          close = "<space>tc",
          focus = "<space>fu",
          expand = "o",
          jump = "<CR>",
          move = "<space><space>",
        },
      })
    end,
  },
}
