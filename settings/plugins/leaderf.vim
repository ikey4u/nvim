Plug 'Yggdroot/LeaderF', { 'do': './install.sh' }
" 不再使用 leaderf 的文件搜索功能了, 挺鸡肋的, 有时候会出现文件搜索不到的情况,
" 而且很莫名其妙找不到原因, 这里禁用 leaderf 默认的 <leader>f 搜索文件快捷键.
let g:Lf_ShortcutF = ""
" 搜索 buffer 中的文件
noremap <leader>Fb :<C-U><C-R>=printf("Leaderf buffer %s", "")<CR><CR>
" 禁止使用缓存(不要使用缓存, 否则新加入的文件搜索不到)
let g:Lf_UseCache = 0
let g:Lf_Ctags = "exctags"
let g:Lf_RootMarkers = ['.vimroot']
let g:Lf_WorkingDirectoryMode = 'Ac'
" :Lf => 搜索文件
command! Lf :LeaderfFile
" :Lfn => 显示所有函数
command! Lfn :LeaderfFunction
" :Lcs => 主题浏览器
command! Lcs :LeaderfColorscheme
" :Lmru => 最近打开的文件列表
command! Lmru :LeaderfMru
" :Lreg => 搜索正则文本
" 限制结果行的最大长度为 1000, 然而由于 leaderf 自定义的 rg 命令并非直接的
" rg, 而是一个 wrapper, 这个 wrapper 只提供了过滤最大长度, 没有提供显示过滤的行的一部分,
" rg 本身提供了 --max-columns-preview 这个选项, 先将就这用吧
" noremap <leader>fe :<C-U><C-R>=printf("Leaderf rg -M 1000 -e ")<CR>
command! -nargs=+ -complete=command Lreg :Leaderf rg -M 1000 -e <q-args><CR>
" :Lword => 搜索文本
" noremap <leader>ff :<C-U><C-R>=printf("Leaderf rg -M 1000 ")<CR>
command! -nargs=+ -complete=command Lword :Leaderf rg -M 1000 <q-args><CR>
" <leader>w => 搜索光标下的文本
noremap <leader>w :<C-U><C-R>=printf("Leaderf rg -M 1000 -e %s ", expand("<cword>"))<CR><CR>
