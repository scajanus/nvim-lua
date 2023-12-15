local status_ok, configs = pcall(require, "nvim-treesitter.configs")
if not status_ok then
  return
end

configs.setup({
  ensure_installed = { "bash", "c", "cpp", "css", "html", "javascript", "json", "lua", "markdown", "markdown_inline", "python", "query", "ruby", "sql", "tsx", "typescript", "yaml", "vim" },
  -- one of "all" or a list of languages
  ignore_install = { "phpdoc" }, -- List of parsers to ignore installing
  highlight = {
    enable = true, -- false will disable the whole extension
    disable = { "css" }, -- list of language that will be disabled
  },
  autopairs = {
    enable = true,
  },
  indent = { enable = true, disable = { "css" } },
  incremental_selection = {
    enable = true,
    additional_vim_regex_highlighting = false,
    keymaps = {
      init_selection = '<space><CR>',
      scope_incremental = '<CR>',
      node_incremental = '<TAB>',
      node_decremental = '<S-TAB>',
    },
  },
})
