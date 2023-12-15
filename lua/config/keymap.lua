local map = function(lhs, rhs, mode, opts)
  local options = vim.tbl_extend("force", { noremap = true, silent = true }, opts or {})
  vim.keymap.set(mode or "n", lhs, rhs, options)
end

map("<leader>l", ":set nomore <Bar> :ls <Bar> :set more <CR>:b<Space>")
map("<leader>gf", ":let path=&path <Bar> :set path=**/* <Bar> exe 'normal! gf' <Bar> let &path=path<CR>")

vim.cmd[[nnoremap <silent> <expr> * v:hlsearch && @/=='\<'.expand('<cword>').'\>' ? '*' : ":let @/='\\<'.expand('<cword>').'\\>'\|let v:hlsearch=1<CR>"]]
vim.cmd[[nnoremap <silent> <expr> # v:hlsearch && @/=='\<'.expand('<cword>').'\>' ? '#' : ":let @/='\\<'.expand('<cword>').'\\>'\|let v:hlsearch=1<CR>"]]

map("<leader>ve", ":e! $MYVIMRC<CR>")
map("<leader>we", ":e! $HOME/.config/wezterm/wezterm.lua<CR>")

map("cn", ":cn<CR>")
map("cp", ":cp<CR>")
map("co", ":copen<CR>")
vim.cmd[[nnoremap <expr> <Leader>o empty(filter(getwininfo(), 'v:val.tabnr==tabpagenr() && v:val.quickfix && !v:val.loclist')) ? ':copen<CR>' : '<c-w>p:cclose<CR>']]

map("<Tab>", "<Cmd>tabnext<CR>")
map("<S-Tab>", "<Cmd>tabprev<CR>")
map("<C-i>", "<C-i>")

map("<C-4>", "<C-\\>")
map("<C-4>", "<C-\\>", "t")

map("<leader>u", ":UndotreeToggle<CR>")
map("<leader>t", ":NvimTreeToggle<CR>")

map("<space>e", vim.diagnostic.open_float)
map("[d", vim.diagnostic.goto_prev)
map("]d", vim.diagnostic.goto_next)
map("<space>q", vim.diagnostic.setloclist)

local get_git_root = function()
  local cwd = vim.fn.expand('%:p:h')
  local root = vim.fn.systemlist("git -C " .. cwd .." rev-parse --show-toplevel")[1]
  print(root)
end
map("<leader>a", get_git_root)
map('<space>h', '<cmd>lua print(vim.inspect(vim.lsp.get_active_clients()))<CR>')
