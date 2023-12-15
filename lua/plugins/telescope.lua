local keymapper = function(arg)
  return function() require('telescope.builtin')[arg]() end
end

local get_git_root = function()
  local cwd = vim.fn.expand('%:p:h')
  local root = vim.fn.systemlist("git -C " .. cwd .." rev-parse --show-toplevel")[1]
  return root
end

local find_local = function()
  local opts = {}
  opts.cwd = get_git_root()
  require('telescope.builtin').find_files(opts)
end

return {
  "nvim-telescope/telescope.nvim",
  tag = "0.1.4",
  dependencies = { "nvim-lua/plenary.nvim",
    {"nvim-telescope/telescope-fzf-native.nvim",
      build = "make",
      config = function()
        require("telescope").load_extension("fzf")
      end,
    }
  },
  keys = {
    { "<leader>ff", keymapper("find_files"), mode = { "n" } },
    { "<leader>fg", keymapper("live_grep"), mode = { "n" } },
    { "<leader>fb", keymapper("buffers"), mode = { "n" } },
    { "<leader>fr", keymapper("resume"), mode = { "n" } },
    { "<leader>fs", "<CMD>Telescope <CR>", mode = { "n" } },
    { "<leader>fl", find_local, mode = { "n" } },
    { "<leader>fq", function()
      require("telescope.builtin").quickfix()
    end, mode = { "n" } },

  },
  config = function()
    local actions = require("telescope.actions")
    local opts = {
      defaults = {
        vimgrep_arguments = {
          "rg",
          "--color=never",
          "--no-heading",
          "--with-filename",
          "--line-number",
          "--column",
          "--smart-case",
          "--hidden",
          "--glob=!.git/"
        },
        mappings = {
          i = {
            ["<C-u>"] = false,
            ["<Tab>"] = "move_selection_worse",
            ["<S-Tab>"] = "move_selection_better",
            ["<Up>"]   = actions.toggle_selection + actions.move_selection_worse,
            ["<Down>"] = actions.toggle_selection + actions.move_selection_better,
          },
          n = {
            ["<Tab>"] = "move_selection_worse", --require("telescope.actions").cycle_history_prev,
            ["<S-Tab>"] = "move_selection_better", --require("telescope.actions").cycle_history_prev,
            ["<C-i>"] = "cycle_history_next", --require("telescope.actions").cycle_history_next,
            ["<C-o>"] = "cycle_history_prev" --require("telescope.actions").cycle_history_prev,
          },
        }
      }
    }
    require("telescope").setup(opts)
  end
}
