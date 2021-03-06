" <leader>ev => 打开配置 neovim 文件
" <leader>sv => 刷新 neovim 文件
nnoremap <leader>ev :split $MYVIMRC<cr>
nnoremap <leader>sv :source $MYVIMRC<cr>

" <space>p => 快速打开插件目录
nnoremap <space>p :exec "vsplit " . expand(g:home) . "/settings/plugins/"<cr>
" <space>M => 快速打开手册
nnoremap <space>M :exec "vsplit " . expand(g:home) . "/man/manual.txt"<cr>
" <space>j => 下一个 tab
nnoremap <space>j :tabnext<cr>
" <space>k => 上一个 tab
nnoremap <space>k :tabprevious<cr>
" <leader>man => 显示本帮助文档
nnoremap <silent> <leader>man :call Help() <cr> | redraw!

" jk => 插入模式中按下 jk 进入 normal 模式
inoremap jk <esc>

" \P => 拷贝文件路径到剪切板
nnoremap <silent> <leader>P :let @+ = expand("%:p")<cr>

" <ESC><ESC> => 终端下快速按下两个 ESC 进入 Normal 模式
tnoremap <ESC><ESC> <C-\><C-n>

" <leader>t => 水平打开终端
" <leader>T => 垂直打开终端
noremap <Leader>t :split term://zsh<CR><Insert>
noremap <Leader>T :vsplit term://zsh<CR><Insert>

" Cm => normal 模式下清除 ^M 符号
" normal 模式下输入 Cm 清除行尾 ^M 符号并保证为 unix 文件格式
" g 表示全局, e 表示如果出错则不显示错误信息, 如果文件没有 ^M,
" 但是按下这个快捷键就会报错, 因此这里使用 e 来屏蔽错误
nnoremap <silent> Cm :%s/\r$//ge<CR>:set fileformat=unix<CR>

" <C-h>, <C-l>, <C-j>, <C-k> => normal 模式下 resize 窗口
noremap <silent> <C-h> :vertical resize +3<CR>
noremap <silent> <C-l> :vertical resize -3<CR>
noremap <silent> <C-j> :resize +3<CR>
noremap <silent> <C-k> :resize -3<CR>
