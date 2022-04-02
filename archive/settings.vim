" 如果要禁止自动在文件末尾添加换行符, 则可以开启如下这几个选项, 如果文件末尾已经有换行符号,
" 可以使用 :set noeol 去掉, 在文件末尾添加换行符是默认行为, 参考如下链接
"
"    https://stackoverflow.com/questions/729692/why-should-text-files-end-with-a-newline
"
" set nofixendofline
" set noendofline
" autocmd FileType * set noeol
"

" vim 异步高亮, 在多语言文件比如 vue 中, 会导致语言高亮失效
" 在 vue 中我们禁用这个特性
" autocmd FileType vue syntax sync fromstart
" 将 svelte 视作 vue 插件实现代码高亮
" au BufRead,BufNewFile *.svelte set filetype=vue
" 设置 vue 文件类型为 html, 这样能够良好的自动缩进
" autocmd BufNewFile,BufRead *.vue set filetype=html
