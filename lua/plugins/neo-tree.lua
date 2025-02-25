-- if true then return {} end -- WARN: REMOVE THIS LINE TO ACTIVATE THIS FILE-

--@type LazySpec
local components = require('neo-tree.sources.common.components')
return {
"nvim-neo-tree/neo-tree.nvim",
  opts = {
    filesystem = {
      components = {
        name = function(config, node, state)
            local name = components.name(config, node, state)
            if node:get_depth() == 1 then
                name.text = vim.fs.basename(vim.loop.cwd() or '')
            end
            return name
        end,
      },
      filtered_items = {
        visible = false, -- hide filtered items on open
        hide_gitignored = false,
        hide_dotfiles = false,
        hide_by_name = {},
        never_show = { ".git", ".idea" },
      },
    },
  },
}

