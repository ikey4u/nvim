function! DocFzf()
python3 << EOF
DOCS = '''
# Fzf 文档

- 安装

    在系统上安装 fzf

        git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
        ~/.fzf/install

    安装完成后在 Plug 里面配置如下即可

        Plug '~/.fzf'
        Plug 'junegunn/fzf.vim'

    然后执行 :PlugInstall 即可.

- 用法

    - 文件搜索 <leader>F

        配置快捷键 <leader>F 在工作目录搜索, 为此写了一个 FindWorkingDir 函数,

        配置 fzf 搜索文件的快捷为 <leader>F

            noremap <leader>F :call FindWorkingDir()<CR> :<C-U><C-R>=printf("Files %s", eval('g:VimRoot'))<CR><CR>

        这里先调用 FindWorkingDir 设置工作目录, 然后将命令打印到命令行上在执行.

    - 搜索结果中移动

        在搜索结果中, 可以使用 ctrl-j, ctrl-k 上下移动光标,
        使用 ctrl-t, ctrl-x, ctrl-v 分别在 tab, 水平, 垂直划分打开.

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
