function! DocStatusline()
python3 << EOF
DOCS = '''

vim 中的状态栏使用 statusline 变量设置, 其帮助文档可以使用 :h statusline 查看.

状态栏由不同的元素组成, 每一个元素跟 C 的格式化字符串很像, 其组成如下所示

    %{formatter}{item}

% 号用来标记一个元素的开始, {formatter} 表示元素样式, {item} 表示元素名称.
如果要显示一个百分号, 可以使用两个百分号来表示.

- {formatter}

    {formatter} 常见的格式为 -0{minwid}.{maxwid}, 常见的 {formatter} 有如下几种

    - 短横(-): 表示左对齐, 默认是右对齐
    - 0: 如果指定了宽度且有剩余宽度, 则用 0 填充
    - {minwid}: 为一个整数, 表示最小宽度
    - {maxwid}: 为一个整数, 表示最大宽度

- {item}

    - f: 当前 buffer 中文件的相对路径
    - F: 当前 buffer 中文件的绝对路径
    - n: 当前 buffer 编号
    - m: 修改标记, 如果为 [+] 表示文件可修改, 为 [-] 表示文件不可修改
    - M: 和 m 一样为修改标记, 只不过用 + 或者 - 来表示
    - r: 只读标记, 显示为 [RO],
    - R: 同 r, 显示为 RO
    - h: 显示帮助标记, 显示为 [HELP]
    - =: 间隔符号, 将元素左右分开
    - l: 行号
    - c: 列号
    - {: 表达式估值, 表达式应该以 } 结尾
    - (: 项目组, 以 %) 结尾

'''
print(DOCS)
EOF
endfunction

" 使状态栏显示光标位置
set ruler
" 启用状态栏信息
set laststatus=2
" 设置命令行的高度为2, 默认为1
set cmdheight=2
" 设置状态栏
set statusline=[%n]
set statusline+=\ %y
set statusline+=\ [%{&fileformat},%{&fenc?&enc:&fenc}%{(&bomb?',[BOM]':'')}]
set statusline+=\ %F
set statusline+=\ %m%r
set statusline+=\ %=
set statusline+=\|R%05l,C%05c,%03p%%\|
