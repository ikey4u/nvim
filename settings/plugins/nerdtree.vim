function! DocNerdtree()
python3 << EOF
DOCS = '''
# Nerdtree 文档

首先定位工作目录 (.git 所在目录或者 .vimroot 所在目录), 然后读取 .vimignore 文件,
忽略其中指定的项.

原本读取的是 .gitignore 文件, 但是 .gitignore 的正则语法比较负责, 在 nerdtree 中难以处理,
因此变换为通过 .vimignore 手动指定要忽略的文件.

.vimignore 的空行将会被忽略, 若某行的第一个非空白字符为 #, 则该行为注释行.

.vimignore 中的每一行表示要忽略的项, 项的名称有如下约束:

- 不能包含 ~ 字符, 因为 ~ 会导致nerdtree NFA could not pop the stack 错误

- 不支持直接路径匹配

    即类似于 src/3rd 的写法是不起作用的.

- 模式匹配

    比如你要忽略一个叫做 core 的文件, 可以在 .vimignore 里面写一行内容为 core,
    如果把 core 读取传递给 nerdtree, 那么 nerdtree 会把任何以 core 结尾的文件或者目录忽略掉,
    如果要精确匹配 core 文件, 需要写作 ^core$.

    nerdtree 支持额外的 flag: [[dir]], [[file]], [[path]]. 分别用于指定目录, 文件, 路径, 比如

        ^build$[[dir]]
        .d$[[dir]]
        .o$[[file]]
        tmp/cache$[[path]]

    模式匹配中不需要用 * 进行通配符匹配, 即 .o 就对应于任何后缀为 .o 的文件, 不需要写作 *.o.

'''
print(DOCS)
EOF
endfunction

Plug 'scrooloose/nerdtree'

function! GetIgnores()

" 获取 g:VimRoot 变量
call FindWorkingDir()

" 读取 .vimignore 文件, 并设置 g:GetIgnores 变量
python3 <<====EOF
import vim
import os
from pathlib import Path

def get_ignores(pth):
    ''' 读取项目根目录下的 .vimignore 文件, 返回一个列表

    忽略 .vimignore 文件中以 # 号开头的行,
    如果某行以 '*.' 开头, 则将 '*.' 替换为 '.'

    '''

    ignores = []
    if not pth.exists():
        return ignores

    with open(pth, 'r') as _:
        for line in _:
            line = line.strip()
            if len(line) == 0 or line.startswith('#'):
                continue
            ignores.append(line)
    ignores = sorted(list(set(ignores)))
    return ignores

ignores = get_ignores(Path(vim.eval("g:VimRoot"), '.vimignore'))
vim.command("let g:VimIgnoresRaw = %s" % ignores)
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

let g:VimIgnores = []
for item in g:VimIgnoresRaw
    if item[0] == '.'
        let item = '\' . item
    endif
    if index(g:VimIgnores, item) < 0
        let g:VimIgnores += [item]
    endif
endfor
endfunction

call GetIgnores()
let NERDTreeIgnore = g:VimIgnores

" 让 nerdtree 忽略常见的临时文件
set wildignore+=*.pyc,*.o,*.obj,*.svn,*.swp,*.class,*.hg,*.DS_Store,*.min.*,*__pycache__*,*.db,*.xcodeproj
let NERDTreeRespectWildIgnore=1

" :IgnoreUpdate => 从 .vimignore 更新 Nerdtree 忽略的文件
command! -nargs=0 IgnoreUpdate call GetIgnores() | let NERDTreeIgnore = g:VimIgnores

" <leader>r => 刷新 nerdtree 目录到当前工作目录
noremap <leader>r :IgnoreUpdate<cr> <bar> :NERDTreeFind<cr>
