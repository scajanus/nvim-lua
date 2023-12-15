vim.cmd([[
  augroup _general_settings
    autocmd!
    autocmd FileType help,man,lspinfo nnoremap <silent> <buffer> q :close<CR> 
    autocmd CmdwinEnter * nnoremap <silent> <buffer> q :close<CR> 
    autocmd TextYankPost * silent!lua require('vim.highlight').on_yank({higroup = 'Visual', timeout = 200}) 
    autocmd BufReadPost * if &ft !~# 'commit\|rebase' && line("'\"") > 0 && line("'\"") <= line("$") | silent! exe "normal! g`\"zO" | endif
    autocmd BufEnter,BufWinEnter * exe "normal zv"
  augroup end

  augroup _quickfix
    autocmd!
    autocmd FileType qf set nobuflisted
    autocmd FileType qf nnoremap <buffer> <C-o> <cmd>:colder<CR>
    autocmd FileType qf nnoremap <buffer> <C-i> <cmd>:cnewer<CR>
    " Keep <Tab> original map to change tabs:
    autocmd FileType qf nunmap <buffer> <Tab>
    autocmd FileType qf if (getwininfo(win_getid())[0].loclist != 1) | wincmd J | endif
  augroup end

  augroup _git
    autocmd!
    autocmd FileType gitcommit setlocal wrap
    autocmd FileType gitcommit setlocal spell
  augroup end

  augroup _markdown
    autocmd!
    autocmd FileType markdown setlocal wrap
    autocmd FileType markdown setlocal spell
  augroup end

  augroup CursorLine
    au!
    au VimEnter * setlocal cursorline
    au WinEnter * setlocal cursorline
    au BufWinEnter * setlocal cursorline
    au WinLeave * setlocal nocursorline
  augroup END
]])

local blink = function()
    local hl = vim.api.nvim_get_hl(0, {name="CursorLine"})

    -- Don't update CursorLineBackup if the highlight is currently active
    if hl.bg ~= vim.api.nvim_get_color_by_name("#333333") then
        vim.api.nvim_set_hl(0, "CursorLineBackup", hl)
    end

    vim.cmd('hi CursorLine guibg=#333333')

    vim.defer_fn(function()
        vim.api.nvim_set_hl(0, "CursorLine", vim.api.nvim_get_hl(0, {name="CursorLineBackup"}))
    end, 800)
end

vim.api.nvim_create_augroup("Blink", {
    clear = true
})
vim.api.nvim_create_autocmd({"WinEnter"}, {
    callback = blink,
    group = "Blink"
})

vim.api.nvim_create_augroup("zz", {
    clear = true
})
vim.api.nvim_create_autocmd({"CmdlineLeave"}, {
    callback = function()
        local cmd = vim.fn.getcmdline()
        if string.sub(cmd, 1, 2) == 'cn' or string.sub(cmd, 1, 2) == 'cp' then
            print(cmd)
            --vim.fn.setcmdline(cmd .. '| norm zz')
        end
    end,
    group = "zz"
})
vim.keymap.set('n', '<leader>cb', blink)


local scroll = function(dir, nu)
    if dir == 'up' then
        vim.cmd([[exec "normal! ]] .. nu .. [[\<C-y>"]])
        --vim.api.nvim_input(nu .. "<C-y>")
    end
    if dir == 'down' then
        vim.cmd([[exec "normal! ]] .. nu .. [[\<C-e>"]])
        --vim.api.nvim_input(nu .. "<C-e>")
    end
end

local gff = function()
  local ok, result = pcall(vim.cmd, [[normal! gf]])
  if not ok then
    vim.api.nvim_err_writeln('File not found in path, press f to try with path=**/*')
    vim.keymap.set('n', 'f', ':let path=&path | try | set path=**/* | exe "normal! gf" | finally | let &path=path | mode | endtry<CR>', {silent = true})
    vim.cmd([[au CursorMoved * ++once silent! nunmap f]])
  end
end
vim.keymap.set('n', 'gf', function() gff() end)

-- local speed = function(dir)
--     local d
--     if dir == 'down' then
--         d = math.abs(vim.fn.line('w$')-vim.fn.line('w0'))
--     else
--         d = vim.fn.winheight(0)
--     end
--     local v_end = 0.001
-- 
--     local t = 300 -- time in ms for the whole scroll
--     local v = 2*d/t - v_end
--     --local v = 0.18 -- viewports/second
--     --local t = 2*d/(v-v_end)
-- 
--     local a = (v-v_end)/t
--     local times = {}
--     local min_ms = 20
-- 
--     local tot = 0
--     for i=1,d do
--         local dvsq=v^2-2*1*a
--         if dvsq < 0 then
--             dvsq = 0
--         end
--         t = -((-v + math.sqrt(dvsq))/a)
--         tot = tot + t
--         v = v - a*t
--         times[i] = t
--     end
--     print(tot)
-- 
--     local total = 0
--     local i = 0
--     local j = 1
--     local final = {}
--     for _, val in ipairs(times) do
--         total = total + val
--         i = i+1
--         if total > min_ms then
--             final[j] = {n = i, ms = total}
--             j = j + 1
--             i = 0
--             total = 0
--         end
--     end
--     return final
-- end
-- 
-- local timer = vim.uv.new_timer()
-- local time_scroll = function(dir)
--     local times = speed(dir)
--     local i = 1
--     local nscroll = function()
--         if i <= #times then
--             timer:set_repeat(times[i].ms)
--             scroll(dir, times[i].n)
--             i = i+1
--         end
--     end
--     timer:start(times[1].ms, times[2].ms,
--         vim.schedule_wrap(nscroll)
--     )
-- end


-- vim.keymap.set('n', '<C-u>', function() time_scroll('up') end)
-- --vim.keymap.set('n', '<leader>f', function() time_scroll('up') end)
-- vim.keymap.set('n', '<C-d>', function() time_scroll('down') end)
-- --vim.keymap.set('n', '<leader>b', function() time_scroll('down') end)
-- vim.keymap.set('n', '<leader>s', function() timer:stop() end)
-- vim.keymap.set('n', '<leader>s', function() print(vim.inspect(speed())) end)
-- Autoformat
-- augroup _lsp
--   autocmd!
--   autocmd BufWritePre * lua vim.lsp.buf.formatting()
-- augroup end
