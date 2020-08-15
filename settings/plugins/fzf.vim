function! DocFzf()
python3 << EOF
DOCS = '''
# Fzf 文档

TODO

'''
print(DOCS)
EOF
endfunction


Plug '~/.fzf'
Plug 'junegunn/fzf.vim'
" 配置 fzf 在 vim 中的背景色, 使用下面这个就行
let g:fzf_colors =
\ { 'fg':      ['fg', 'Normal'],
  \ 'bg':      ['bg', 'Normal'],
  \ 'hl':      ['fg', 'Comment'],
  \ 'fg+':     ['fg', 'CursorLine', 'CursorColumn', 'Normal'],
  \ 'bg+':     ['bg', 'CursorLine', 'CursorColumn'],
  \ 'hl+':     ['fg', 'Statement'],
  \ 'info':    ['fg', 'PreProc'],
  \ 'border':  ['fg', 'Ignore'],
  \ 'prompt':  ['fg', 'Conditional'],
  \ 'pointer': ['fg', 'Exception'],
  \ 'marker':  ['fg', 'Keyword'],
  \ 'spinner': ['fg', 'Label'],
  \ 'header':  ['fg', 'Comment']
\}
" <leader>F => 搜索工作空间下的文件
noremap <leader>F :call FindWorkingDir()<CR> :<C-U><C-R>=printf("Files %s", eval('g:VimRoot'))<CR><CR>
