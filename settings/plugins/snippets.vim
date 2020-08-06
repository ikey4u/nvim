" ultisnips
Plug 'SirVer/ultisnips'
let g:UltiSnipsExpandTrigger="<c-d>"
let g:UltiSnipsJumpForwardTrigger="<c-j>"
let g:UltiSnipsJumpBackwardTrigger="<c-k>"
" 编辑 UltiSnips 的时候水平打开编辑窗口
let g:UltiSnipsEditSplit="horizontal"
let g:UltiSnipsSnippetDirectories=[expand(g:home).'/UltiSnips']

" snipmate (依赖于 vim-addon-mw-utils 和 tlib_vim)
Plug 'MarcWeber/vim-addon-mw-utils'
Plug 'tomtom/tlib_vim'
Plug 'garbas/vim-snipmate'

" ultisnips 和 snipmate 代码片段
Plug 'honza/vim-snippets'
