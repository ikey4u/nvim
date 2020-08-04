" 快速编辑和重载配置文件
nnoremap <leader>ev :split $MYVIMRC<cr>
nnoremap <leader>sv :source $MYVIMRC<cr>

" 快速打开自定义手册
nnoremap <leader>man :exec "vsplit " . expand(g:home) . "/man/manual.txt"<cr>

" 插入模式中 jk 进入 normal 模式
inoremap jk <esc>

" \P 拷贝文件路径到剪切板
nnoremap <silent> <leader>P :let @+ = expand("%:p")<cr>

" 终端快速按下两个 ESC 进入 Normal 模式
tnoremap <ESC><ESC> <C-\><C-n>

" 水平或垂直打开终端
noremap <Leader>t :split term://zsh<CR><Insert>
noremap <Leader>T :vsplit term://zsh<CR><Insert>

" 清除 ^M 符号
" 常规模式下输入 Cm 清除行尾 ^M 符号并保证为 unix 文件格式
" g 表示全局, e 表示如果出错则不显示错误信息, 如果文件没有 ^M,
" 但是按下这个快捷键就会报错, 因此这里使用 e 来屏蔽错误
nnoremap <silent> Cm :%s/\r$//ge<CR>:set fileformat=unix<CR>
