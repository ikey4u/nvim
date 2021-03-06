" 基础选项
filetype on                                           "启用文件类型侦测
filetype plugin on                                    "针对不同的文件类型加载对应的插件
filetype plugin indent on                             "启用缩进
set smartindent                                       "启用智能对齐方式
set smarttab                                          "指定按一次backspace就删除shiftwidth宽度
set expandtab       "(et)编辑时将所有 Tab 替换为空格
                    "该选项只在编辑时将 Tab 替换为空格,
                    "如果打开一个已经存在的文件,并不会将已有的 Tab替换为空格.
                    "如果希望进行这样的替换的话,可以使用这条命令":retab".
set shiftwidth=4    "(sw)自动缩进时所使用的缩进长度
set tabstop=4       "(ts)定义与一个 tab 等长的空格长度
set softtabstop=4   "(sts)这个主要是和 tabastop 配合使用,
                    "这个一般在 set expandtab 时用处不大, 否则在启用 tab 时,
                    "表示混合输入. 加入 tabstop 的值是 8, 如果 softtabstop 是 16,
                    "那么一个 tab 键就会输入两个 tab, 如果 softtabstop 是 17,
                    "那么就会输入两个 tab 加上一个空格.
                    "如果 softtabstop 是 4, 那么输入 tab, 会输入 4 个空格,
                    "当再按下一个 tab 时, 就会生成一个制表符.
                    "简单来说, softtabstop 根据自身值与 tabstop 的值进行行为控制,
                    "一般和 tabstop 配置一致即可. 当该值为 0 时, 关闭该功能
" make 文件的缩进要求必须是 tab 而不是空格
autocmd FileType make setlocal noexpandtab
let $LANG = 'en'                                      " 设置消息语言(比如弹出框什么的)
set langmenu=zh_CN.UTF-8                              "设置菜单语言,解决消息乱码问题
set timeoutlen=1000 ttimeoutlen=0                     "消除 ESC 按键延迟
set number                                            "显示行号
set virtualedit=all                                   "启用虚拟编辑(也就是让光标可以达到没有任何文字的地方)
set nowrap                                            "设置不自动换行
set shortmess=atI                                     "去掉欢迎界面
set showmatch 										  "显示括号配对
set cindent 										  "打开C/C++风格自动缩进
set autoindent 										  "打开普通文件类型的自动缩进.
set mouse=a                                     "启用鼠标
set showcmd                                     "正常模式下状态行显示输入的命令
syntax on                                       "开启代码着色
let html_use_css = 1                            "设置 TOhtml 使用样式表而不是行内样式
let html_number_lines = 0                       "取消 TOhtml 的行号
"set mouse-=a									"禁用鼠标

" 编码设置 {

    " 注:使用utf-8格式后,软件与程序源码,文件路径不能有中文,否则报错

    set encoding=utf-8                                    "设置gvim内部编码
    set fileencoding=utf-8                                " 设置当前文件编码,可以更改,如:gbk(同cp936)
    set fileencodings=ucs-bom,utf-8,gbk,cp936             " 设置支持打开的文件的编码,这一行搞不好就会乱码
    set tenc=utf-8                                        " 设置终端编码
    set fileformat=unix                                   " 设置新(当前)文件的<EOL>格式,可以更改,
                                                          " 如:dos(windows系统最好设置为dos否则容易出现^M等字符)
    set fileformats=unix,dos,mac                          " 给出文件的<EOL>格式类型
" }

" 折叠
set foldlevel=99									  "默认情况下不折叠
set foldenable                                        "启用折叠
set foldmethod=indent                                 "indent 折叠方式
set foldmethod=marker                                 "marker 折叠方式, :help marker

" 搜索设置
set ignorecase                                        "搜索模式里忽略大小写
set smartcase                                         "如果搜索模式包含大写字符,不使用 ignorecase 选项,
set noincsearch                                       "在输入要搜索的文字时,取消实时匹配

" 水平垂直线显示
set cursorline
set cursorcolumn

set textwidth=100      " 设置文本行宽度, 使用 gq 格式文本时会用到这个长度
set formatoptions+=mM  " formatoptions,设置自动换行的条件, m 表示允许对 multi_byte 字符换行
set colorcolumn=100    " 在宽度边界处显示一条彩色边界线
augroup extrahighlight
  " guibg 设置为全值, 比如要写为 #FFFFFF 而不要写为简写形式 #FFF
  autocmd BufEnter * highlight OverLength ctermbg=red ctermfg=white guibg=#6666FF
  " 超过指定字符个数时设置高亮, 当有 unicode 字符时, 一个 unicode 字符的长度可能占据一个或者多个单元长度,
  " 这会导致在含有 unicode 的行上列索引显示不正确, 但是实际上高亮的行宽显示是正确的
  autocmd BufEnter * match OverLength /\%100v.\+/
augroup END


" 文件备份设置
set nowritebackup                                     "编辑时不需要备份文件
set nobackup                                          "设置无备份文件
set noswapfile                                        "设置无临时文件
set noundofile                                        "不创建撤销文件

" 设置代码默认配色方案(终端下不需要配置)
set background=dark
" 使用 :colorscheme <C-d> 可以查看所有可用的主题
" 使用 :colorscheme <tab> 可以自动补全可用的主题
colorscheme diokai

" vim 中终端配色默认使用系统中终端的配色, 因此在 vim 配置中修改终端配色作用不大,
" 下面的选项是 vim 对其自带终端颜色的配置
"hi Terminal ctermbg=2 ctermfg=3 guibg=#827472 guifg=black

"弹出菜单的着色
"highlight Pmenu ctermfg=2 ctermbg=3 guifg=#2A2A2A guibg=#E8E8E8

"自动切换目录为当前编辑文件所在目录
set autochdir

" 不要存储会话的全局和局部变量值以及折叠(因为 Utilsnippet 无法正常恢复这些选项)
set ssop-=options
set ssop-=folds

" 根据文件类型自动设置缩进宽度
augroup cusindent
    autocmd!
    " html, css 缩进为 2
    autocmd FileType javascript,vue,html,css,yaml,dart,typescript setlocal ts=2 sw=2 sts=0 et
    " txt 缩进为 0
    autocmd FileType text setlocal nocindent
    " vim 异步高亮, 在多语言文件比如 vue 中, 会导致语言高亮失效
    " 在 vue 中我们禁用这个特性
    autocmd FileType vue syntax sync fromstart
    " 设置 vue 文件类型为 html, 这样能够良好的自动缩进
    autocmd BufNewFile,BufRead *.vue set filetype=html
    " 设置 c++ 和 c 的 switch case 缩进
    " 参考自: https://stackoverflow.com/questions/3444696/how-to-disable-vims-indentation-of-switch-case
    autocmd FileType cpp,c set cinoptions=l1
augroup END

" nvim yank 时复制到系统剪贴板中
set clipboard+=unnamedplus

" 自动加载修改后的文件
set autoread
