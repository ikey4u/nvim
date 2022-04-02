function! DocLeaderf()
python3 << EOF
DOCS = '''
# Leaderf 文档

配置 ctags 程序, 安装方法见本手册的 ctags 节.

    let g:Lf_Ctags = "exctags"

用法

    :Leaderf <subcommand>

leaderf 的主要作用还是用来查找文件, 所以我们需要告诉 LeaderF 从哪里开始查找,
定义如下变量(元素可以自己随便定义)

    let g:Lf_RootMarkers = ['.git', '.svn', '.vimroot']

只定义这个是不行的, 还需定义工作目录模式

    let g:Lf_WorkingDirectoryMode = '<mode>'

<mode> 有如下几种

    - c 设置工作目录为当前工作目录(默认)
    - a [当前工作目录] 的最近的包含了 RootMarkers 的祖先目录
    - A [  当前文件  ] 的最近的包含了 RootMarkers 的祖先目录
    - f 当前文件的目录

本配置中设置 mode 为 'Ac'.

    let g:Lf_WorkingDirectoryMode = 'Ac'

在搜索结果窗口中的移动快捷键如下

- <C-j> <C-k> 在搜索结果中向下向上移动
- <ESC> 或者 <C-C> 退出 LeaderF
- <C-R> 在 fuzzy 搜索和 regex 搜索模式间切换
- <Tab>

    切换为 vim 的 normal 模式, 可以在结果中移动, 然后回车即可选择文件,
    注意 tab 切换成 vim normal 模式时, 当你切换到其他工作窗口时,
    工作路径不会自动切换为被编辑文件所在路径, 需要恢复到 Leaderf
    原来的模式才会自动切换工作路径.

- <C-V> 从剪贴板粘贴
- <C-X> 水平窗口打开
- <C-]> 垂直窗口打开
- <C-T> tab 中打开
- <C-P> 预览结果

Leaderf 在显示窗口中的字体如果无法正常显示, 则需要安装 nerd-fonts,
安装方法见本手册的 nerd-fonts 一节, 安装完 nerd-fonts 需要将终端字体或者含有
nvim 的 GUI 字体设置为含有 nerd 的字体, 注意 source code pro 的 nerd-fonts
字体名称为 SauceCodePro.

'''
print(DOCS)
EOF
endfunction
Plug 'Yggdroot/LeaderF', { 'do': ':LeaderfInstallCExtension' }
" 不再使用 leaderf 的文件搜索功能了, 挺鸡肋的, 有时候会出现文件搜索不到的情况,
" 而且很莫名其妙找不到原因, 这里禁用 leaderf 默认的 <leader>f 搜索文件快捷键.
let g:Lf_ShortcutF = ""
" 搜索 buffer 中的文件
noremap <leader>Fb :<C-U><C-R>=printf("Leaderf buffer %s", "")<CR><CR>
" 禁止使用缓存(不要使用缓存, 否则新加入的文件搜索不到)
let g:Lf_UseCache = 0
let g:Lf_Ctags = "exctags"
let g:Lf_RootMarkers = ['.vimroot', '.git']
let g:Lf_WorkingDirectoryMode = 'Ac'
let g:Lf_UseVersionControlTool = 0
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
" rg 本身提供了 --max-columns-preview 这个选项, 先这么使用.
command! -nargs=+ -complete=command Lreg :Leaderf rg -M 1000 -e <q-args><CR>
" :Lword => 搜索文本
" noremap <leader>ff :<C-U><C-R>=printf("Leaderf rg -M 1000 ")<CR>
command! -nargs=+ -complete=command Lword :Leaderf rg -M 1000 <q-args><CR>
" <leader>w => 搜索光标下的文本
noremap <leader>w :<C-U><C-R>=printf("Leaderf rg -M 1000 -e %s ", expand("<cword>"))<CR><CR>
