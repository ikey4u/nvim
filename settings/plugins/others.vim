" 括号自动补全另一半
Plug 'jiangmiao/auto-pairs'

" 注释插件
Plug 'scrooloose/nerdcommenter'
let g:NERDSpaceDelims=1

" 大文件
Plug 'vim-scripts/LargeFile'
let g:LargeFile=10

" html 标签补全
Plug 'mattn/emmet-vim'

" Tagbar
Plug 'majutsushi/tagbar'

" 开屏美化
Plug 'mhinz/vim-startify'
let g:startify_files_number = 20

" 括号匹配管理器
Plug 'tpope/vim-surround'

" 多余的空格高亮
Plug 'ntpeters/vim-better-whitespace'

" 高亮显示多余的空格
" Cs => 正常模式下, 清除尾部多余空格
let g:better_whitespace_enabled=1
nnoremap Cs :StripWhitespace<CR>

" 各种图标显示
Plug 'ryanoasis/vim-devicons'

" Dart 语言
Plug 'dart-lang/dart-vim-plugin'

" Kotlin 插件
Plug 'udalov/kotlin-vim'

" treesitter 插件
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}

" 在远程主机上拷贝到本地剪切板
Plug 'ojroques/vim-oscyank'
" vim 中执行 y 操作时, 自动拷贝到本地剪贴板
autocmd TextYankPost * if v:event.operator is 'y' && v:event.regname is '' | execute 'OSCYankReg "' | endif
let g:oscyank_max_length = 1000000
" 将终端视作 tmux, 该选项十分重要, 如果不设置, 在 tmux 中无法正确复制,
" 如果不用 tmux 设置此选项页也没有副作用, 因此加上该选项
let g:oscyank_term = 'tmux'
let g:oscyank_silent = v:true

" <C-w>m 切换当前窗口最大化或恢复原来布局
Plug 'dhruvasagar/vim-zoom'

" javascript 高亮与缩进插件, 替换 treesitter 中的 js 插件
Plug 'pangloss/vim-javascript'

" svelte 高亮与缩进插件, 替换 treesitter 中的 svelte 插件
Plug 'othree/html5.vim'
Plug 'pangloss/vim-javascript'
Plug 'evanleck/vim-svelte', { 'branch': 'main' }
