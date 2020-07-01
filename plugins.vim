call plug#begin(g:home . '/plugged')
" 注释插件
Plug 'scrooloose/nerdcommenter'
" 文件树插件
Plug 'scrooloose/nerdtree'

" 大文件
Plug 'vim-scripts/LargeFile'

" 自动补全系列 {
    Plug 'SirVer/ultisnips'
    Plug 'honza/vim-snippets'
    Plug 'jiangmiao/auto-pairs'
    Plug 'mattn/emmet-vim', { 'commit': 'dcf8f6efd8323f11e93aa1fb1349c8a1dcaa1e15' }
    Plug 'marijnh/tern_for_vim'
    Plug 'majutsushi/tagbar'
    " 使用 frozen 选项禁止更新 YCM, 这个需要手动编译
    " Plug 'Valloric/YouCompleteMe',  { 'frozen': 1 }
" }
call plug#end()
source ~/.config/nvim/pluginscfg.vim
