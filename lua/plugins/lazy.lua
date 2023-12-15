local opts = {
  dev = {
    -- directory where you store your local plugin projects
    path = "~/.config/nvim-lua/pack",
    ---@type string[] plugins that match these patterns will use your local versions instead of being fetched from GitHub
    patterns = {}, -- For example {"folke"}
    fallback = false, -- Fallback to git when local plugin doesn't exist
  },
}
if not package.loaded['lazy'] then
  local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
  if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
      "git",
      "clone",
      "--filter=blob:none",
      "https://github.com/folke/lazy.nvim.git",
      "--branch=stable", -- latest stable release
      lazypath,
    })
  end
  vim.opt.rtp:prepend(lazypath)
  require("lazy").setup("plugins", opts)
end

return {
  "folke/neodev.nvim",
  { "jpalardy/vim-slime", config = function()
    vim.g.slime_target = "wezterm"
    vim.g.slime_bracketed_paste = true
    vim.g.slime_default_config = {pane_direction="next"}
  end },
  "tpope/vim-fugitive",
  "williamboman/mason.nvim",
  "williamboman/mason-lspconfig.nvim",
  "neovim/nvim-lspconfig",
  {
    "stevearc/conform.nvim",
    init = function()
      vim.opt.formatexpr = "v:lua.require'conform'.formatexpr()"
    end,
    opts = {
      notify_on_error = true,
      formatters_by_ft = {
        lua = { "stylua" },
        -- Conform will run multiple formatters sequentially
        python = { "black" },
        sql = { "pg_format" },
        -- Use a sub-list to run only the first available formatter
        --javascript = { { "prettierd", "prettier" } },
      },
    },
  },
  { "stevearc/oil.nvim", config = true },
  { "nvim-treesitter/nvim-treesitter", config = false, build = ":TSUpdate" },
  {
    dir = vim.fn.stdpath("config") .. "/pack/theme/start/theme.nvim",
    lazy = false,
    priority = 1000,
    config = function()
      vim.cmd([[colorscheme theme]])
    end,
  },
  --"nvim-tree/nvim-tree.lua",
  --"savq/paq-nvim",
  --"nvim-lua/plenary.nvim",
  "mbbill/undotree",
  --"danymat/neogen", -- depends on treesitter
  --"brenoprata10/nvim-highlight-colors",
  --'stevearc/aerial.nvim'
  "uga-rosa/ccc.nvim",
  "twerth/ir_black"
}
