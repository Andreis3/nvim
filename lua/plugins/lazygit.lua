return {
  "kdheepak/lazygit.nvim",
  lazy = false,
  cmd = {
    "LazyGit",
    "LazyGitConfig",
    "LazyGitCurrentFile",
    "LazyGitFilter",
    "LazyGitFilterCurrentFile",
  },
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-telescope/telescope.nvim",
  },
  keys = {
    { "<leader>lg", "<cmd>LazyGit<cr>", desc = "LazyGit" },
    { "<leader>lG", function() require("telescope").extensions.lazygit.lazygit() end, desc = "LazyGit Telescope" },
  },
  config = function()
    require("telescope").load_extension("lazygit")

    vim.g.lazygit_floating_window_winblend = 0
    vim.g.lazygit_floating_window_scaling_factor = 0.9
    vim.g.lazygit_floating_window_border_chars = { '╭','─', '╮', '│', '╯','─', '╰', '│' }
    vim.g.lazygit_floating_window_use_plenary = 0
    vim.g.lazygit_use_neovim_remote = 1
    vim.g.lazygit_use_custom_config_file_path = 0
    vim.g.lazygit_config_file_path = {}
    vim.g.lazygit_on_exit_callback = nil
  end,
}
