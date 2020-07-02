call plug#begin(g:home . '/plugged')

" 注释插件 {
    Plug 'scrooloose/nerdcommenter'

    " \cm: /**/ 方式注释行,或者将选中的行紧凑的包起来:comment minimal line
    " \c<space> :切换行的状态(注释->非注释,非注释->注释)
    " \cs:良好格式的块注释 /**/:comment sexy line
    " \cu:取消注释:comment undo
    " \ca:切换可选的注释方式, 如 C/C++ 的块注释和行注释
    " 注释后面自动加空格
    let g:NERDSpaceDelims=1
" }

" 文件浏览器 {
    Plug 'scrooloose/nerdtree'

    " <leader>r 自动刷新 nerdtree 目录到当前工作目录
    noremap <leader>r :NERDTreeFind<cr>
    " 忽略的文件列表
    let NERDTreeIgnore = ['\.pyc$', '__pycache__', '\.db$']
" }

" 大文件 {
    Plug 'vim-scripts/LargeFile'

    let g:LargeFile=10
" }

" 自动补全系列 {
    Plug 'SirVer/ultisnips'
    let g:UltiSnipsExpandTrigger="<leader>i"
    let g:UltiSnipsJumpForwardTrigger="<c-j>"
    let g:UltiSnipsJumpBackwardTrigger="<c-k>"
    let g:UltiSnipsEditSplit="horizontal"
    let g:UltiSnipsSnippetDirectories=[expand(g:home).'/UltiSnips']

    Plug 'honza/vim-snippets'
    Plug 'jiangmiao/auto-pairs'
    Plug 'mattn/emmet-vim', { 'commit': 'dcf8f6efd8323f11e93aa1fb1349c8a1dcaa1e15' }
    Plug 'marijnh/tern_for_vim'
    Plug 'majutsushi/tagbar'

    Plug 'neoclide/coc.nvim', {'branch': 'release'}
    " tab 触发 coc 补全
    inoremap <silent><expr> <C-z> coc#refresh()
    " <C-j> 向下移动补全选择条, <C-k> 向上移动补全选择条
    inoremap <silent><expr> <C-j>
          \ pumvisible() ? "\<C-n>" :
          \ <SID>check_back_space() ? "\<TAB>" :
          \ coc#refresh()
    inoremap <expr><C-k> pumvisible() ? "\<C-p>" : "\<C-h>"
    function! s:check_back_space() abort
      let col = col('.') - 1
      return !col || getline('.')[col - 1]  =~# '\s'
    endfunction
" }

" 开屏美化 {
    Plug 'mhinz/vim-startify'
" }

" 快速光标移动 {
    " 正常情况下使用 w 是向前移动一个单词, 如果单词比较靠后,
    " 那么我们需要按多次 w, 使用该插件可以快速移动.
    "
    " 快速按下 <leader><leader>w 就可以在当前行执行搜索,
    " 每一个单词首字母被高亮, 按下高亮字符即可调整.
    "
    " 类似的 <leader><leader>j 是用于向行下跳转,
    " 配合 k 可以向上跳转, 配合 s 可以在当前行搜索字符.
    Plug 'easymotion/vim-easymotion'
" }

" 括号匹配管理器 {
    Plug 'tpope/vim-surround' 

    " # 修改和删除
    " cs(change surround), ds(delete surround).
    " cs 和 ds 接受两个字符, 第一个为源字符, 第二个为目标字符.
    
    " # 添加
    " ys(you surround): 第一个参数是一个 vim motion 或者文本对象,
    " 第二个参数是一要 wrap 的字符. 比如 ysw' 表示 表示将当前光标所在的单词用单
    " 引号包含起来, 对于空格, 举个例子, ysw) 不会添加空格, 而 ysw( 会添加空格.
    " 特别的 yss 是一个特殊的命令, 用来处理当前行. 
    
    " # 特殊字符
    " 有一些特殊字符, 比如 b, B, r, a 分别可以表示 ), }, ] 和  >
    " 比如 yswb 表示将当前单词用 () 括起来.

" }

call plug#end()
