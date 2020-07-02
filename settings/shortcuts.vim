" 快速编辑和重载配置文件
nnoremap <leader>ev :split $MYVIMRC<cr>
nnoremap <leader>sv :source $MYVIMRC<cr>

" 快速打开自定义手册
nnoremap <leader>man :exec "vsplit " . expand(g:home) . "/man/manual.txt"<cr>

" 插入模式中 jk 进入 normal 模式
inoremap jk <esc>

" \P 拷贝文件路径到剪切板
nnoremap <silent> <leader>P :let @+ = expand("%:p")<cr>

" 终端按下 ESC 返回 Normal 模式
tnoremap <Esc> <C-\><C-n>

" 水平或垂直打开终端
noremap <Leader>t :split term://zsh<CR><Insert>
noremap <Leader>T :vsplit term://zsh<CR><Insert>
