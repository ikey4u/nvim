" nerdtree {
    " <leader>r 自动刷新 nerdtree 目录到当前工作目录
    noremap <leader>r :NERDTreeFind<cr>
    " 忽略的文件列表
    let NERDTreeIgnore = ['\.pyc$', '__pycache__', '\.db$']
" }

" ultisnips {
    let g:UltiSnipsExpandTrigger="<leader>i"
    let g:UltiSnipsJumpForwardTrigger="<c-j>"
    let g:UltiSnipsJumpBackwardTrigger="<c-k>"
    let g:UltiSnipsEditSplit="horizontal"
    let g:UltiSnipsSnippetDirectories=[expand(g:home).'/UltiSnips']
" }

 " \cm: /**/ 方式注释行,或者将选中的行紧凑的包起来:comment minimal line
 " \c<space> :切换行的状态(注释->非注释,非注释->注释)
 " \cs:良好格式的块注释 /**/:comment sexy line
 " \cu:取消注释:comment undo
 " \ca:切换可选的注释方式, 如 C/C++ 的块注释和行注释
 " 注释后面自动加空格
 let g:NERDSpaceDelims=1

 " LargeFile
 let g:LargeFile=10                                    "优化大文件编辑
