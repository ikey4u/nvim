" ultisnips
" <c-d> => 触发 ultisnips 的自动补全
" <c-j> => 下一个 ultisnips 占位符
" <c-k> => 上一个 ultisnips 占位符
Plug 'SirVer/ultisnips'
let g:UltiSnipsExpandTrigger="<c-d>"
let g:UltiSnipsJumpForwardTrigger="<c-j>"
let g:UltiSnipsJumpBackwardTrigger="<c-k>"
" 编辑 UltiSnips 的时候水平打开编辑窗口
let g:UltiSnipsEditSplit="horizontal"
" ultisnips 不支持相对于配置根目录的二级目录, 比如 expand(g:home).'/UltiSnips/ext'
let g:UltiSnipsSnippetDirectories=[expand(g:home).'/UltiSnips', expand(g:home).'/self']

" snipmate (依赖于 vim-addon-mw-utils 和 tlib_vim)
Plug 'MarcWeber/vim-addon-mw-utils'
Plug 'tomtom/tlib_vim'
Plug 'garbas/vim-snipmate'

" ultisnips 和 snipmate 代码片段
Plug 'honza/vim-snippets'
