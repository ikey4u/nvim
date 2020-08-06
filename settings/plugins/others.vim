" 括号自动补全另一半
Plug 'jiangmiao/auto-pairs'

" 注释插件
Plug 'scrooloose/nerdcommenter'
let g:NERDSpaceDelims=1

" 大文件
Plug 'vim-scripts/LargeFile'
let g:LargeFile=10

" html 标签补全
Plug 'mattn/emmet-vim', { 'commit': 'dcf8f6efd8323f11e93aa1fb1349c8a1dcaa1e15' }

" Tagbar
Plug 'majutsushi/tagbar'

" 开屏美化
Plug 'mhinz/vim-startify'
let g:startify_files_number = 100

" 快速光标移动
Plug 'easymotion/vim-easymotion'

" 括号匹配管理器
Plug 'tpope/vim-surround'

" 多余的空格高亮
Plug 'ntpeters/vim-better-whitespace'

" 高亮显示多余的空格
let g:better_whitespace_enabled=1
nnoremap Cs :StripWhitespace<CR>

" markdown
" 开启调试日志的方法
" let $NVIM_MKDP_LOG_FILE = expand('~/mkdp-log.log')
" let $NVIM_MKDP_LOG_LEVEL = 'debug'
" 当前问题: https://github.com/iamcco/markdown-preview.nvim/issues/219
Plug 'iamcco/markdown-preview.nvim', { 'do': 'cd app & npm install'  }
let g:mkdp_echo_preview_url = 1

" 各种图标显示
Plug 'ryanoasis/vim-devicons'
