function! DocNerdtree()
python3 << EOF
DOCS = '''
# Nerdtree 文档

- 自动读取工作目录下的 .gitignore 文件并忽略显示

'''
print(DOCS)
EOF
endfunction

Plug 'scrooloose/nerdtree'

function! GetIgnores()

" 获取 g:VimRoot 变量
call FindWorkingDir()

" 读取 .gitignore 文件, 并设置 g:GetIgnores 变量
python3 <<====EOF
import vim
import os
from pathlib import Path

def get_ignores(pth):
    ''' 读取 .gitignore 文件, 返回一个列表

    忽略 .gitignore 文件中以 # 号开头的行,
    如果某行以 '*.' 开头, 则将 '*.' 替换为 '.'

    '''

    ignores = ['.pyc$', '__pycache__$', '.db$', '.xcodeproj']
    if not pth.exists():
        return ignores

    with open(pth, 'r') as _:
        for line in _:
            line = line.strip()
            # 处理 .gitignore 中的路径
            if '/' in line:
                items = line.split('/')
                if len(items[1]) == 0:
                    # 单个目录, 比如对于 draft/ 我们将会返回 draft
                    line = items[0]
                else:
                    # 多级目录, 比如对于 src/3rd 我们将返回 3rd
                    line = items[-1]
            if line and (not line.startswith('#')):
                if line.startswith('*.'):
                    line = line.replace('*', '', 1)

                if line[0] == '.':
                    ignores.append(line + '$')
                else:
                    # 这里有一点需要注意, 比如你要忽略一个叫做 core 的文件, 可以在 .gitignore 里面写一行,
                    # 内容为 core, 如果把 core 读取传递给 nerdtree, 那么 nerdtree 会把任何以 core 结尾的文件或者目录忽略掉,
                    # 所以这里添加上 ^ 符号
                    ignores.append('^' + line + '$')

    return ignores

ignores = get_ignores(Path(vim.eval("g:VimRoot"), '.gitignore'))
vim.command("let g:GitIgnoresRaw = %s" % ignores)
====EOF

" Nerdtree 的忽略列表样例如下所示
"
"     let NERDTreeIgnore = [ '\.o$' ]
"
" 但是由于 python 中 get_ignores 返回值中如果包含有反斜线,
" 那么设置到 vim 变量 NERDTreeIgnore 上将会得到
"
"     let NERDTreeIgnore = [ '\\.o$' ]
"
" 这个问题无法得到有效的解决, 因此, 这里需要遍历 python 中返回的列表,
" 如果检测到以 '.' 开始的行, 则手动加上反斜线.
"
" 另外注意以下两种形式的差别
"
"     let NERDTreeIgnore = [ '\.o$' ]
"     let NERDTreeIgnore = [ '.o$' ]
"
" 第一个列表将仅仅忽略文件名后缀为 .o 的文件, 而第二种模式不仅会忽略以 .o 为后缀
" 的文件, 同时也会忽略包含后缀为 .o 的文件的祖先目录

let g:GitIgnores = []
for item in g:GitIgnoresRaw
    if item[0] == '.'
        let item = '\' . item
    endif
    if index(g:GitIgnores, item) < 0
        let g:GitIgnores += [item]
    endif
endfor
endfunction

call GetIgnores()
let NERDTreeIgnore = g:GitIgnores

" :IgnoreUpdate => 从 .gitignore 更新 Nerdtree 忽略的文件
command! -complete=command IgnoreUpdate call GetIgnores() | let NERDTreeIgnore = g:GitIgnores

" <leader>r => 刷新 nerdtree 目录到当前工作目录
noremap <leader>r :IgnoreUpdate<cr> <bar> :NERDTreeFind<cr>
