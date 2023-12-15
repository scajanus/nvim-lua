local mason = require("mason")
local mason_lspconfig = require("mason-lspconfig")

-- Use LspAttach autocommand to only map the following keys after the language
-- server attaches to the current buffer
vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(ev)
    -- Buffer local mappings.
    -- See `:help vim.lsp.*` for documentation on any of the below functions
    local opts = { buffer = ev.buf }
    vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
    vim.keymap.set("n", "gd", function()
      vim.lsp.buf.definition({ reuse_win = true })
    end, opts)
    vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
    vim.keymap.set("n", "<leader>gi", vim.lsp.buf.implementation, opts)
    vim.keymap.set("n", "<C-k>", vim.lsp.buf.signature_help, opts)
    vim.keymap.set("n", "<space>wa", vim.lsp.buf.add_workspace_folder, opts)
    vim.keymap.set("n", "<space>wr", vim.lsp.buf.remove_workspace_folder, opts)
    vim.keymap.set("n", "<space>wl", function()
      print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
    end, opts)
    vim.keymap.set("n", "<space>D", vim.lsp.buf.type_definition, opts)
    vim.keymap.set("n", "<space>rn", vim.lsp.buf.rename, opts)
    vim.keymap.set({ "n", "v" }, "<space>ca", vim.lsp.buf.code_action, opts)
    vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
    vim.keymap.set("n", "<space>fo", function()
      local val = vim.lsp.buf.format({ async = true })
      print(val)
    end, opts)
  end,
  group = vim.api.nvim_create_augroup("UserLspConfig", {}),
})

mason.setup({
  ui = {
    border = "none",
    icons = {
      package_installed = "✔",
      package_pending = "▰",
      package_uninstalled = "",
    },
  },
  log_level = vim.log.levels.INFO,
  max_concurrent_installers = 4,
  pip = { upgrade_pip = true },
})

mason_lspconfig.setup({
  ensure_installed = {
    "lua_ls",
    "jsonls",
    "pyright",
    "ruff_lsp",
    "jsonls",
    -- "bashls",
    -- "yamlls",
    -- "cssls",
    -- "html",
    -- "tsserver",
  },
  automatic_installation = false,
})

local lspconfig = require("lspconfig")
lspconfig.pyright.setup({
  on_attach = function(client, bufnr)
    client.server_capabilities.completionProvider = true
    client.server_capabilities.hoverProvider = false
  end,
  capabilities = (function()
    local capabilities = vim.lsp.protocol.make_client_capabilities()
    capabilities.textDocument.publishDiagnostics.tagSupport.valueSet = { 2 }
    return capabilities
  end)(),
  settings = {
    python = {
      analysis = {
        autoImportCompletions = true,
      },
    },
  },
})
lspconfig.jedi_language_server.setup({
  --capabilities = capabilities,
  --on_attach = on_attach,
  --handlers = handlers,
  on_attach = function(client, bufnr)
    client.server_capabilities.workspaceSymbolProvider = false
    client.server_capabilities.hoverProvider = false
  end,
  init_options = {
    completion = {
      disableSnippets = true,
    },
  }
})
lspconfig.ruff_lsp.setup({
  on_attach = function(client, bufnr)
    --client.server_capabilities.completionProvider = false
    client.server_capabilities.hoverProvider = false
  end,
  init_options = {
    settings = {
      args = {
        "--extend-select=W,COM,ICN",
        "--ignore=COM812",
      },
    },
  },
})
-- vim.diagnostic.config({virtual_text = { severity = { min = vim.diagnostic.severity.INFO } }, severity_sort = true, })

lspconfig.lua_ls.setup({
  on_attach = function(client, bufnr)
    client.server_capabilities.semanticTokensProvider = nil
    --client.server_capabilities.hoverProvider = false
  end,
  settings = {
    Lua = {
      -- LuaJIT used in NVIM is Lua 5.1
      runtime = { version = 'Lua 5.1' },
      diagnostics = {
        globals = { "vim" },
      },
      workspace = {
        library = {
          [vim.fn.expand("$VIMRUNTIME/lua")] = true,
          [vim.fn.stdpath("config") .. "/lua"] = true,
        },
      },
    },
  },
})

require("lspconfig").tsserver.setup({
  on_attach = function(client, bufnr)
    -- client.server_capabilities.semanticTokensProvider = false
  end,
})

local lsp_import_on_completion = function()
  local completed_item = vim.v.completed_item

  print(vim.inspect(completed_item))
  if
    not (
    completed_item
    and completed_item.user_data
    and completed_item.user_data.nvim
    and completed_item.user_data.nvim.lsp
    and completed_item.user_data.nvim.lsp.completion_item
    and completed_item.user_data.nvim.lsp.completion_item.additionalTextEdits
  )
  then
    return
  end

  local item = completed_item.user_data.nvim.lsp.completion_item
  local offset_encoding = "utf-8"
  --local offset_encoding = vim.lsp.get_client_by_id(client_id).offset_encoding

  vim.lsp.util.apply_text_edits(item.additionalTextEdits, 0, offset_encoding)
  --TODO: does the function below and using the completionItem/resolve make more sense/is more compatible?
  --print(vim.inspect(item))
  --vim.lsp.buf_request_all(bufnr, "completionItem/resolve", item, function(result)
  --print(vim.inspect(result))
  --if result and result.params.additionalTextEdits then
  --vim.lsp.util.apply_text_edits(result.params.additionalTextEdits, bufnr, offset_encoding)
  --end
  --end)
end

vim.api.nvim_create_autocmd({ "CompleteDone" }, {
  pattern = "*",
  callback = lsp_import_on_completion,
  group = vim.api.nvim_create_augroup("LspImportOnCompletion", { clear = true }),
})
