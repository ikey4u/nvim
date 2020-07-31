call plug#begin(g:home . '/plugged')

Plug 'scrooloose/nerdcommenter'
let g:NERDSpaceDelims=1

Plug 'scrooloose/nerdtree'
" <leader>r 自动刷新 nerdtree 目录到当前工作目录
noremap <leader>r :NERDTreeFind<cr>
" 忽略的文件列表
let NERDTreeIgnore = ['\.pyc$', '__pycache__', '\.db$']

" 大文件
Plug 'vim-scripts/LargeFile'
let g:LargeFile=10

" 自动补全系列
Plug 'SirVer/ultisnips'
let g:UltiSnipsExpandTrigger="<leader>i"
let g:UltiSnipsJumpForwardTrigger="<c-j>"
let g:UltiSnipsJumpBackwardTrigger="<c-k>"
let g:UltiSnipsEditSplit="horizontal"
let g:UltiSnipsSnippetDirectories=[expand(g:home).'/UltiSnips']
Plug 'honza/vim-snippets'
Plug 'jiangmiao/auto-pairs'
Plug 'mattn/emmet-vim', { 'commit': 'dcf8f6efd8323f11e93aa1fb1349c8a1dcaa1e15' }
Plug 'majutsushi/tagbar'
Plug 'neoclide/coc.nvim', {'branch': 'release'}
" <C-z> 触发 coc 补全
inoremap <silent><expr> <C-z> coc#refresh()

" 开屏美化
Plug 'mhinz/vim-startify'

" 快速光标移动
Plug 'easymotion/vim-easymotion'

" 括号匹配管理器
Plug 'tpope/vim-surround'

" 多余的空格高亮
Plug 'ntpeters/vim-better-whitespace'
" 高亮显示多余的空格
let g:better_whitespace_enabled=1
" 保存时自动删除多余的空格
let g:strip_whitespace_on_save=1

" Markdown
function! BuildComposer(info)
  if a:info.status != 'unchanged' || a:info.force
    if has('nvim')
      !cargo build --release --locked
    else
      !cargo build --release --locked --no-default-features --features json-rpc
    endif
  endif
endfunction
Plug 'euclio/vim-markdown-composer', { 'do': function('BuildComposer') }

Plug 'Yggdroot/LeaderF', { 'do': './install.sh' }
" 不再使用 leaderf 的文件搜索功能了, 挺鸡肋的, 有时候会出现文件搜索不到的情况,
" 而且很莫名其妙找不到原因, 这里禁用 leaderf 默认的 <leader>f 快捷键.
" 搜索文件
let g:Lf_ShortcutF = ""
" 搜索 buffer 中的文件
noremap <leader>Fb :<C-U><C-R>=printf("Leaderf buffer %s", "")<CR><CR>
" 禁止使用缓存(不要使用缓存, 否则新加入的文件搜索不到)
let g:Lf_UseCache = 0
let g:Lf_Ctags = "exctags"
let g:Lf_RootMarkers = ['.vimroot']
let g:Lf_WorkingDirectoryMode = 'Ac'
" 搜索正则文本
" 限制结果行的最大长度为 1000, 然而由于 leaderf 自定义的 rg 命令并非直接的
" rg, 而是一个 wrapper, 这个 wrapper 只提供了过滤最大长度, 没有提供显示过滤的行的一部分,
" rg 本身提供了 --max-columns-preview 这个选项, 先将就这用吧
noremap <leader>fe :<C-U><C-R>=printf("Leaderf rg -M 1000 -e ")<CR>
" 搜索文本
noremap <leader>ff :<C-U><C-R>=printf("Leaderf rg -M 1000 ")<CR>
" 搜索光标下的文本
noremap <leader>fc :<C-U><C-R>=printf("Leaderf rg -M 1000 -e %s ", expand("<cword>"))<CR><CR>

Plug '~/.fzf'
Plug 'junegunn/fzf.vim'
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
" 好吧, vim 用着很舒服, 但是 vimscript 真他妈的操蛋, 真他妈的操蛋!
noremap <leader>F :call FindWorkingDir()<CR> :<C-U><C-R>=printf("Files %s", eval('g:VimRoot'))<CR><CR>

call plug#end()
