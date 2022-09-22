function! DocVimtex()
python3 << EOF
DOCS = '''
# vimtex 文档

- 禁用 quickfix 窗口

     let g:vimtex_quickfix_enabled=0

- vimtex 快捷键

    使用 `:help vimtex-default-mappings` 即可查看所有的快捷键.

    - PDF 预览: <leader>ll
    - 编译的配置信息: <leader>li
    - 编译的输出信息: <leader>lo
    - vimtex 的编译日志: <leader>lq

- 自动编译 bibtex 的问题

    对于 bibtex 文件, vimtex 第一次会编译失败, 不要灰心, 再让 vimtex 执行一次即可.

- 自动刷新预览 PDF

    在 macos 下需要下载安装 skim 阅读器, neovim 编辑器安装 nvr.

    之后配置 vimtex 为如下选项

        let g:vimtex_view_method = 'skim'
        let g:vimtex_compiler_progname = 'nvr'
        let g:vimtex_compiler_latexmk = {
              \ 'build_dir': 'out',
              \ 'continuous' : 1,
              \ 'options' : [
              \   '-xelatex',
              \   '-verbose',
              \   '-silent',
              \   '-synctex=1',
              \   '-interaction=nonstopmode',
              \   '-file-line-error',
              \   '-bibtex',
              \ ],
              \}

    g:vimtex_view_method 用于设置使用的 PDF 程序名称,
    g:vimtex_compiler_latexmk 用于设置 latexmk 程序编译 TEX 文件时的选项,
    我们在这里设置输出目录为 out 目录.

    latexmk 的选项通过 options 来指定, latexmk 的编译引擎需要通过 TEX 指令来指定.

    TEX 指令就是在 .tex 文件的最前面几行, 用注释的方式指定一些变量. 如下

        %! TEX program = xelatex
        %! TEX root = main.tex

    program 用于设置编译 TEX 文件时所用的编译引擎, root 用于设置整个 TEX 工程的主文件.

    除此之外, 可以设置文件预览的更新速度, 时间为毫秒, 方法如下

        autocmd Filetype tex setl updatetime=10

- 隐藏符号

    为了隐藏符号, 可以设置如下两行

        set conceallevel=2
        let g:tex_conceal='abdmg'

    conceallevel 用于设置隐藏特定文本的级别.
    0 表示正常显示文本, 1 表示隐藏的文本用一个空格来替换,
    2 表示完全不显示隐藏的文本.

    我们可以设置特定的文件类型中要隐藏的文本, 这里用 g:tex_conceal 来设定,
    每个字符表示一种类型

        a = accents/ligatures
        b = bold and italic
        d = delimiters
        m = math symbols
        g = Greek
        s = superscripts/subscripts

- 错误排查

    如果一切配置正常, 但是使用 \ll 无法预览,
    那么可能是文件写错了, 命令行用 xelatex 编译一下看看具体的错误.

    如果你卡在了 \ll 命令上, 全身不能动弹, 说明你的 tex 文件位于 ~/Downloads
    目录, 这是一个神奇的问题, 至今不得其解, 只要把 tex 文件放在 ~/Downloads 目
    录, \ll 就不能动态.
'''
print(DOCS)
EOF
endfunction

Plug 'lervag/vimtex'

let g:vimtex_quickfix_enabled=0
if has('mac')
    let g:vimtex_view_method = 'skim'
endif
let g:vimtex_compiler_latexmk = {
      \ 'build_dir': 'out',
      \ 'continuous' : 1,
      \ 'options' : [
      \   '-xelatex',
      \   '-verbose',
      \   '-silent',
      \   '-synctex=1',
      \   '-interaction=nonstopmode',
      \   '-file-line-error',
      \   '-bibtex',
      \ ],
      \}
autocmd Filetype tex setl updatetime=10
set conceallevel=2
let g:tex_conceal='abdmg'
let g:tex_flavor = 'xelatex'
let g:vimtex_compiler_progname = 'nvr'
