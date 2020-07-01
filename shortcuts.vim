" [快速编辑和重载配置文件]
nnoremap <leader>ev :split $MYVIMRC<cr>
nnoremap <leader>sv :source $MYVIMRC<cr>

" [快速打开自定义手册]
nnoremap <leader>man :exec "vsplit " . expand(g:home) . "/man/manual.txt"<cr>

" [打开字体设置窗口]
nnoremap <leader>font :exec "set guifont=*"<cr>

" [给当前单词加上双引号]
nnoremap <leader>' viw<esc>a'<esc>bi'<esc>lel
nnoremap <leader>'' viw<esc>a"<esc>bi"<esc>lel

" [插入模式中 jk 进入 normal 模式]
inoremap jk <esc>

" [\P 拷贝文件路径到剪切板]
nnoremap <silent> <leader>P :let @+ = expand("%:p")<cr>
