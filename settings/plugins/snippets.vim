function! DocUltisnips()
python3 << EOF
DOCS = '''
# Ultisnips 文档

- 基本格式

    UltiSnips 的代码段格式如下

        snipmate <abbrevation> <description> <options>

        endsnippet

    <abbrevation> 就是要触发代码段的简写字符, <description> 表示对该代码段的描述,
    <options> 暂时先不用管.

- 占位符号

    在代码段中可以用 ${1}, ${2} 表示占位符号, 如果希望给占位符添加描述性文本,
    可以使用 ${1:<text>} 这种格式.

- 插值

    - 命令行

        代码段的内容使用反双引号(backquote)来表示命令行插值, 即反引号中的内容将会被视作命令行执行.

    - python

        如果反引号中以 !p 开头, 表示执行 python 代码, !p 为 python 引入了一个 snip 对象,
        该对象具有如下几个属性

        - rv: 作为代码段中的返回值
        - fn: 当前文件名
        - ft: 当前文件类型

        比如自动插入文件名

            snippet test
            `!p snip.rv = snip.fn`
            endsnippet

        再比如自动生成日期时间

            snippet
            `!p
            from datetime import datetime
            snip.rv = datetime.today().strftime("%Y-%m-%d")`
            `
            endsnippet

        ultisnips 也支持全局的 snippet, 使用 `gloal !p` 关键字,
        只支持 python 代码, 如下所示

            global !p
            def upper_right(inp):
                return (75 - 2 * len(inp))*' ' + inp.upper()
            endglobal

        这个时候就可以在 snippet 文件中使用 upper_right 函数了

            snippet wow
            ${1:Text}`!p snip.rv = upper_right(t[1])`
            endsnippet

        由于 vim 支持 python 脚本, 除了使用 global 外,
        还可以新建 $HOME/.config/nvim/pythonx, 在该目录下新建 snips 文件夹,
        并将如下内容写入到 snips/__init__.py 中:

            from datetime import datetime

            def date(fmt):
                return datetime.today().strftime(fmt)

        然后就可以在 snippet 中使用

            snippet date
            `!p
            import snips
            snip.rv = snips.date("%Y-%m-%d")
            `
- 扩展

    snippet 文件支持文件扩展, 比如在 cpp.snippets 中写入如下一行

       extends c

    表示扩展来自类型文件类型为 c 的 snippets, 也就是扩展自 c.snippets.

- snippet 搜索目录

    在 UltiSnips 中可以使用 g:UltiSnipsSnippetDirectories 来设置 snippet 的搜索目录,
    该变量的值可以是一个路径字符串, 或者一个数组.

    当为一个相对路径字符串时, 默认去 $HOME/.vim 下搜索, 如果为一个绝对路径字符串,
    则按照该路径去搜索.

    当为一个数组时, 如果第一个元素是绝对路径, 那么后面的元素将被忽略,
    所以配置数组时应该将元素设置为相对路径字符串, 这个时候可以配合 g:UltiSnipsSnippetsDir 设置搜索根目录,
    然后在该根目录下放置多个 snippet 文件夹, 比如

        let g:UltiSnipsSnippetsDir = expand(g:home)
        let g:UltiSnipsSnippetDirectories=['UltiSnips', 'SelfSnips']

    除此之外, ultisnips 不支持二级子目录, 比如 expand(g:home).'/UltiSnips/ext'.

'''
print(DOCS)
EOF
endfunction
" <c-d> => 触发 ultisnips 的自动补全, 避免 <tab> 与 coc 冲突
" <c-j> => 下一个 ultisnips 占位符
" <c-k> => 上一个 ultisnips 占位符
Plug 'SirVer/ultisnips'
let g:UltiSnipsExpandTrigger="<c-d>"
let g:UltiSnipsJumpForwardTrigger="<c-j>"
let g:UltiSnipsJumpBackwardTrigger="<c-k>"
" 编辑 UltiSnips 的时候水平打开编辑窗口
let g:UltiSnipsEditSplit="horizontal"
" 设置 ultisnips 搜索目录
let g:UltiSnipsSnippetsDir = expand(g:home)
let g:UltiSnipsSnippetDirectories=['UltiSnips', 'SelfSnips']

let g:snipMate = { 'snippet_version' : 1 }

" snipmate (依赖于 vim-addon-mw-utils 和 tlib_vim)
Plug 'MarcWeber/vim-addon-mw-utils'
Plug 'tomtom/tlib_vim'
Plug 'garbas/vim-snipmate'

" ultisnips 和 snipmate 代码片段
Plug 'honza/vim-snippets'
