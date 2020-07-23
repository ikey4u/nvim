" LeaderF {
" 配置 ctags 程序
"
"     let g:Lf_Ctags = "exctags"
"
" 用法
"
"     :Leaderf <subcommand>
"
" subcommand 有如下几个
"
" - file                search files
" - tag                 navigate tags using the tags file
" - rg                  grep using rg
" - function            navigate functions or methods in the buffer
" - mru                 search most recently used files
" - searchHistory       execute the search command in the history
" - cmdHistory          execute the command in the history
" - help                navigate the help tags
" - line                search a line in the buffer
" - colorscheme         switch between colorschemes
" - self                execute the commands of itself
" - bufTag              navigate tags in the buffer
" - buffer              search buffers
"
" leaderf 的主要作用还是用来查找文件, 所以我们需要告诉 LeaderF 从哪里开始查找,
" 定义如下变量(元素可以自己随便定义)
"
"     let g:Lf_RootMarkers = ['.git', '.svn', '.vimroot']
"
" 只定义这个是不行的, 还需定义工作目录模式
"
"     let g:Lf_WorkingDirectoryMode = '<mode>'
"
" <mode> 有如下几种
"
"     - c 设置工作目录为当前工作目录(默认)
"     - a [当前工作目录] 的最近的包含了 RootMarkers 的祖先目录
"     - A [  当前文件  ] 的最近的包含了 RootMarkers 的祖先目录
"     - f 当前文件的目录
"
" 我们可以设置 mode 为 'Ac'.
"
"     let g:Lf_WorkingDirectoryMode = 'Ac'
"
" 其常用的快捷键为
"
" - <leader>F 搜索 leaderf 的工作目录中的文件, 这里我用 F 表示文件
" - <leader>Fb 搜索 buffer 中的文件
" - <leader>fc 搜索光标下面的文本
" - <leader>fe 搜索正则表达式文本
" - <leader>ff 搜索文本, f 表示 find 文本
" - <C-j> <C-k> 在搜索结果中向下向上移动
" - <ESC> 或者 <C-C> 退出 LeaderF
" - <C-R> 在 fuzzy 搜索和 regex 搜索模式间切换
" - <Tab> 切换为 vim 的 normal 模式, 可以在结果中移动, 然后回车即可选择文件
" - <C-V> 从剪贴板粘贴
" - <C-X> 水平窗口打开
" - <C-]> 垂直窗口打开
" - <C-T> tab 中打开
" - <C-P> 预览结果
"
" 其他命令
"
" - LeaderfColorschme: 用于查看不同颜色主题, 按 <C-p> 预览

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
