print(string.format("Welcome %s! How are you doing today?", vim.fn.getenv("USER")))

-- Set this here, so if there are errors later this mapping is still available
vim.g.mapleader = " "
vim.keymap.set("n", "<leader>ve", ":e! $MYVIMRC<CR>")

-- Reload configuration on save
vim.api.nvim_create_autocmd({ "BufWritePost" }, {
  pattern = vim.fn.stdpath("config") .. "/*.lua",
  callback = function(ev)
    dofile(ev.file)
    dofile(vim.fn.getenv("MYVIMRC"))
    vim.notify("Reloaded config")
  end,
  group = vim.api.nvim_create_augroup("ReloadConfig", { clear = true }),
})

vim.opt.cmdheight = 1
vim.opt.confirm = true
vim.opt.completeopt = { "menuone", "longest" }
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.mouse = "a"
vim.opt.timeout = false
vim.opt.undofile = true
vim.opt.updatetime = 300
vim.opt.expandtab = true
--vim.opt.shiftwidth = 4
--vim.opt.softtabstop = 4
vim.opt.cursorline = true
vim.opt.number = true
vim.opt.numberwidth = 2
vim.opt.signcolumn = "yes"
vim.opt.wrap = true
vim.opt.wildmode = "list:longest,full"
vim.opt.wildoptions = "fuzzy"
vim.opt.wildignorecase = true
vim.opt.foldmethod = "expr"
vim.opt.foldexpr = "nvim_treesitter#foldexpr()"
vim.opt.foldnestmax = 1
vim.opt.foldopen:append({"jump", "insert"})

require("plugins.lazy")
require("config.keymap")
require("config.lsp")
require("config.autocommands")
vim.cmd.colorscheme("theme")
require("config.treesitter")
require("config.qf")

require('dap-python').setup('~/.virtualenvs/debugpy/bin/python')
table.insert(require('dap').configurations.python, {
      type = 'python';
      request = 'attach';
      name = 'Remote docker';
      connect = function()
        local host = vim.fn.input('Host [127.0.0.1]: ')
        host = host ~= '' and host or '127.0.0.1'
        local port = tonumber(vim.fn.input('Port [5678]: ')) or 5678
        return { host = host, port = port }
      end;
        pathMappings = {
            {
                localRoot = function()
                    return vim.fn.input("Local code folder > ", vim.fn.getcwd(), "file")
                end,
                remoteRoot = function()
                    return vim.fn.input("Container code folder > ", "/", "file")
                end,
            },
        },

})
vim.api.nvim_create_user_command("LspCapabilities", function()
	local curBuf = vim.api.nvim_get_current_buf()
	local clients = vim.lsp.get_active_clients { bufnr = curBuf }

	for _, client in pairs(clients) do
		if client.name ~= "null-ls" then
			local capAsList = {}
			for key, value in pairs(client.server_capabilities) do
				if value and key:find("Provider") then
					local capability = key:gsub("Provider$", "")
					table.insert(capAsList, "- " .. capability)
				end
			end
			table.sort(capAsList) -- sorts alphabetically
			local msg = "# " .. client.name .. "\n" .. table.concat(capAsList, "\n")
			vim.notify(msg, "trace", {
				on_open = function(win)
					local buf = vim.api.nvim_win_get_buf(win)
					vim.api.nvim_buf_set_option(buf, "filetype", "markdown")
				end,
				timeout = 14000,
			})
			vim.fn.setreg("+", "Capabilities = " .. vim.inspect(client.server_capabilities))
		end
	end
end, {})
