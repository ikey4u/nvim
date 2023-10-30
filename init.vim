"  1. 开箱即用
"
"       配置当前文件时, 应只配置内置的最基本选项, 不要依赖其他任何文件或者插件,
"       只需将该文件内容直接复制到任何一个环境即可开箱使用.
"
"  2. 扩展配置
"
"       扩展配置位于 xinit.vim 中, 会自动检测该文件是否存在, 如果存在则自动载入,
"       因此如果要使用扩展配置, 则需要自行配置 xinit.vim 中的依赖.

let g:homes = {}
let g:homes['mac'] = expand('$HOME/\.config/nvim')
let g:homes['linux'] = expand('$HOME/\.config/nvim')
let g:homes['win'] = expand('$HOME/AppData/Local/nvim')

if has('unix')
    let g:home = g:homes['linux']
    let g:os = "Linux"
endif
if has('mac')
    let g:home = g:homes['mac']
    let g:os = "Darwin"
endif
if has('win32') || has('win64')
    let g:home = g:homes['win']
    let g:os = "Windows"
endif
if !exists('g:os')
    echomsg 'Platform is not supported!'
    finish
endif
if !exists('g:home')
    echomsg 'nvim configuration directory is not exist: ' . g:home
    finish
endif

" default cache direcotry
let g:tmpbuf = g:home . '/.cache'

" 基础选项
filetype on
filetype plugin on
filetype plugin indent on
set smartindent
set smarttab

" 编辑时将所有 Tab 替换为空格, 该选项只在编辑时将 Tab 替换为空格,
" 如果打开一个已经存在的文件,并不会将已有的 Tab 替换为空格.
" 如果希望进行这样的替换的话,可以使用命令 :retab
set expandtab

" 自动缩进时所使用的缩进长度
set shiftwidth=4

" 定义与一个 tab 等长的空格长度
set tabstop=4

" softtabstop 主要是和 tabastop 配合使用, 这个一般在 set expandtab 时用处不大, 否则在启用 tab 时, 表
" 示混合输入. 加入 tabstop 的值是 8, 如果 softtabstop 是 16,那么一个 tab 键就会输入两个 tab, 如果
" softtabstop 是 17,那么就会输入两个 tab 加上一个空格.如果 softtabstop 是 4, 那么输入 tab, 会输入 4
" 个空格, 当再按下一个 tab 时, 就会生成一个制表符. 简单来说, softtabstop 根据自身值与 tabstop 的值进
" 行行为控制, 一般和 tabstop 配置一致即可. 当该值为 0 时, 关闭该功能.
set softtabstop=4

let $LANG = 'en'                   " 设置消息语言(比如弹出框什么的)
set langmenu=zh_CN.UTF-8           " 设置菜单语言,解决消息乱码问题
set timeoutlen=1000 ttimeoutlen=0  " 消除 ESC 按键延迟
set virtualedit=all                " 启用虚拟编辑(也就是让光标可以达到没有任何文字的地方)
set nowrap                         " 设置不自动换行
set shortmess=atI                  " 去掉欢迎界面
set showmatch 					   " 显示括号配对
set cindent 					   " 打开C/C++风格自动缩进
set autoindent 					   " 打开普通文件类型的自动缩进.
set mouse=a                        " 启用鼠标
set showcmd                        " 正常模式下状态行显示输入的命令
syntax on                          " 开启代码着色
let html_use_css = 1               " 设置 TOhtml 使用样式表而不是行内样式
let html_number_lines = 0          " 取消 TOhtml 的行号

" 编码设置 {
    " 注: 使用 utf-8 格式后, 软件与程序源码, 文件路径不能有中文, 否则报错

    set encoding=utf-8                                    " 设置 vim 内部编码
    set fileencoding=utf-8                                " 设置当前文件编码
    set fileencodings=ucs-bom,utf-8,gbk,cp936             " 设置支持打开的文件的编码
    set tenc=utf-8                                        " 设置终端编码
    set fileformat=unix                                   " 设置文件的 <EOL> 格式
    set fileformats=unix,dos,mac                          " 设置支持的 <EOL> 类型
" }

" 折叠
set foldlevel=99	   " 默认情况下不折叠
set foldenable         " 启用折叠
set foldmethod=indent  " indent 折叠方式
set foldmethod=marker  " marker 折叠方式, :help marker

" 搜索设置
set ignorecase   " 搜索模式里忽略大小写
set smartcase    " 如果搜索模式包含大写字符, 不使用 ignorecase 选项,
set noincsearch  " 在输入要搜索的文字时, 取消实时匹配

set nowritebackup  " 编辑时不需要备份文件
set nobackup       " 设置无备份文件
set noswapfile     " 设置无临时文件
set noundofile     " 不创建撤销文件

" 设置代码默认配色方案(终端下不需要配置)
set background=dark
" 使用 :colorscheme <C-d> 可以查看所有可用的主题
" 使用 :colorscheme <tab> 可以自动补全可用的主题
if filereadable(printf("%s/%s/%s", g:home, 'colors', 'diokai.vim'))
    colorscheme diokai
endif

set formatoptions+=mM  " formatoptions, 设置自动换行的条件, m 表示允许对 multi_byte 字符换行
augroup extrahighlight
    " 设置文本行宽度, 使用 gq 格式文本时会用到这个长度
    set textwidth=80
    " 在宽度边界处显示一条彩色边界线
    set colorcolumn=80
    " set transparent colorcolumn, note that this line must appear after
    " colorscheme command
    highlight colorcolumn ctermbg=238
augroup END

" 不要存储会话的全局和局部变量值以及折叠(因为 Utilsnippet 无法正常恢复这些选项)
set ssop-=options
set ssop-=folds

" 根据文件类型自动设置缩进宽度
augroup cusindent
    autocmd!
    " 以下文件类型缩进为 2
    autocmd FileType javascriptreact,svelte,javascript,vue,html,css,yaml,dart,typescript setlocal ts=2 sw=2 sts=0 et
    " txt 缩进为 0
    autocmd FileType text setlocal nocindent
    " 设置 c++ 和 c 的 switch case 缩进
    " 参考自: https://stackoverflow.com/questions/3444696/how-to-disable-vims-indentation-of-switch-case
    autocmd FileType cpp,c set cinoptions=l1
    " 设置 json5 格式
    autocmd BufNewFile,BufRead *.json5 set ft=json5
augroup END

" treat js file as javascriptreact to enable jsx feature
augroup filetype_jsx
    autocmd!
    autocmd FileType javascript set filetype=javascriptreact
augroup END

" nvim yank 时复制到系统剪贴板中
set clipboard+=unnamedplus

" 自动加载修改后的文件
set autoread

" 设置不可见字符显示时的文本
set listchars=tab:→\ ,nbsp:␣,trail:∙,extends:▶,precedes:◀,eol:¬

" Do not use `autocmd BufEnter lcd %:p:h` which may cause coc buffer messy such as
" command `:CocList services`
set autochdir

" make 文件的缩进要求必须是 tab 而不是空格
autocmd FileType make setlocal noexpandtab
" set shebang indent for shell file
autocmd FileType sh setlocal cinoptions=#1

" 水平垂直线显示
set cursorline
set cursorcolumn

" realtive line number (useful for quick jump around)
set number
set relativenumber

" 自动补全选项 (
"     menu: 以浮窗的形式显示待选列表
"     menuone: 只有一个选项时仍然以浮窗显示
"     noselect: 浮窗显示后默认不选择
"     preview: 显示当前选择项的额外信息
" )
set completeopt=menu,menuone,preview

" 使状态栏显示光标位置
set ruler
" 启用状态栏信息
set laststatus=2
" 设置命令行的高度为2, 默认为1
set cmdheight=2
" 设置状态栏
set statusline=[%n]
set statusline+=\ %y
set statusline+=\ [%{&fileformat},%{&fenc?&enc:&fenc}%{(&bomb?',[BOM]':'')}]
set statusline+=\ %F
set statusline+=\ %m%r
set statusline+=\ %=
set statusline+=\|R%05l,C%05c,%03p%%\|

" Map `j` and `k` to visual mode which is useful when you want to move up or down around very long
" wrapped line
"
" If you want to make it work only with some filetypes, you can set it like the following
"
"     au FileType html,tex noremap <buffer> j gj
"
noremap j gj
noremap k gk

" disable auto wrap
set formatoptions-=t

" highlight trailing whitespace
highlight ExtraWhitespace ctermbg=red guibg=red
au ColorScheme * highlight ExtraWhitespace guibg=red
au BufEnter * match ExtraWhitespace /\s\+$/
au InsertEnter * match ExtraWhitespace /\s\+\%#\@<!$/
au InsertLeave * match ExtraWhiteSpace /\s\+$/

" 个性化配置
let envfile = printf('%s/%s', expand('$HOME'), 'Sync/normal/conf/env.vim')
if filereadable(envfile)
    exec printf('source %s', envfile)
endif

" extensive configuration (vim plugins, lua plugins, functions, shortcuts)
" set neovim python3 path: https://neovim.io/doc/user/provider.html
if exists('$NVIM_PYTHON_EXE_PATH')
    let g:python3_host_prog = expand("$NVIM_PYTHON_EXE_PATH")
else
    if g:os == 'Linux' || g:os == 'Darwin'
        let g:python3_host_prog = expand("$HOME/.pyenv/shims/python3")
        if !filereadable(g:python3_host_prog)
            let g:python3_host_prog = "python3"
        endif
    else
        let g:python3_host_prog = expand("py")
    endif
endif
if !executable(g:python3_host_prog)
    echomsg 'python3 is not installed, the extensive configurations will not be included'
else
    let xinit=printf('%s/%s', g:home, 'xinit.vim')
    if filereadable(xinit)
        exec printf("source %s", xinit)
    endif
endif
