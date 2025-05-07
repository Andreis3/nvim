---@param scale_factor number
---@return number
local function clamp_scale_factor(scale_factor)
  return math.max(
    math.min(scale_factor, vim.g.neovide_max_scale_factor),
    vim.g.neovide_min_scale_factor
  )
end

---@param scale_factor number
---@param clamp? boolean
local function set_scale_factor(scale_factor, clamp)
  vim.g.neovide_scale_factor = clamp and clamp_scale_factor(scale_factor)
    or scale_factor
end

local function reset_scale_factor()
  vim.g.neovide_scale_factor = vim.g.neovide_initial_scale_factor
end

---@param increment number
---@param clamp? boolean
local function change_scale_factor(increment, clamp)
  set_scale_factor(vim.g.neovide_scale_factor + increment, clamp)
end

---@type LazySpec
return {
  "AstroNvim/astrocore",
  ---@type AstroCoreOpts
  opts = {
    options = {
      g = {
        neovide_increment_scale_factor = vim.g.neovide_increment_scale_factor
          or 0.1,
        neovide_min_scale_factor = vim.g.neovide_min_scale_factor or 0.7,
        neovide_max_scale_factor = vim.g.neovide_max_scale_factor or 2.0,
        neovide_initial_scale_factor = vim.g.neovide_scale_factor or 1,
        neovide_scale_factor = 0.8 or vim.g.neovide_scale_factor,

        neovide_cursor_vfx_mode = "torpedo",
      },
    },
    commands = {
      NeovideSetScaleFactor = {
        function(event)
          local scale_factor, option = tonumber(event.fargs[1]), event.fargs[2]

          if not scale_factor then
            vim.notify(
              "Error: scale factor argument is nil or not a valid number.",
              vim.log.levels.ERROR,
              { title = "Recipe: neovide" }
            )
            return
          end

          set_scale_factor(scale_factor, option ~= "force")
        end,
        nargs = "+",
        desc = "Set Neovide scale factor",
      },
      NeovideResetScaleFactor = {
        reset_scale_factor,
        desc = "Reset Neovide scale factor",
      },
    },
    mappings = {
      n = {
        ["<C-=>"] = {
          function()
            change_scale_factor(
              vim.g.neovide_increment_scale_factor * vim.v.count1,
              true
            )
          end,
          desc = "Increase Neovide scale factor",
        },
        ["<C-->"] = {
          function()
            change_scale_factor(
              -vim.g.neovide_increment_scale_factor * vim.v.count1,
              true
            )
          end,
          desc = "Decrease Neovide scale factor",
        },
        ["<C-0>"] = { reset_scale_factor, desc = "Reset Neovide scale factor" },

        ["gr"] = { "<cmd>Telescope lsp_references<cr>", desc = "Listar referências do LSP" },
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
          ["gi"] = { "<cmd>lua vim.lsp.buf.implementation()<CR>", desc = "Ir para a implementação" },
      },
      -- Modo de inserção
      i = {
        -- Mapear Ctrl + c para copiar no modo de inserção
        ["<C-c>"] = { "<Esc>\"+y", desc = "Copiar" },
        -- Mapear Ctrl + v para colar no modo de inserção
        ["<C-v>"] = { "<C-r>+", desc = "Colar" },
        -- Mapear Ctrl + x para recortar no modo de inserção
        ["<C-x>"] = { "<Esc>\"+d", desc = "Recortar" },
        -- Mapear Ctrl + a para selecionar tudo no modo de inserção
        ["<C-a>"] = { "<C-o>ggVG", desc = "Selecionar tudo" },
        -- Mapear Ctrl + f para abrir o Finder no modo de inserção
        ["<C-f>"] = { "<cmd>lua require('telescope.builtin').find_files()<CR>", desc = "Abrir Finder" },
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