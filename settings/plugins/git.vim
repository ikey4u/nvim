function! DocGit()
python3 << EOF
DOCS = '''
# Git 插件文档

fugitive 插件为 vim 提供了在编辑器中操作 Git 的能力, 其基本命令是 :Git, 也可以简
写为 :G, 它本质上是封装了 git 命令.

- :Gcommit, :Git commit
- :Gdiff, :Git diff
- :Glog, :Git log
- :Gblame, :Git blame
- :Gmergetool, :Git mergetool
- :Gedit, GSplit

    查看 blob, tree, commit 或者 tag, 比如下面的命令

        :Gedit HEAD~3:%

    将会加载当前文件倒数第 3 次提交的版本.

- :Gdiffsplit

    分屏打开当前文件的 staged 版本

- :Gread
- :Gwrite
- :Ggrep, :Glgrep
- :Gmove, :Grename
- :Gdelete, :Gremove
- :Gbrowe

其实更多帮助可以使用 :help fugitive 来看.

# 快捷键映射

- Staging/Unstaging 映射

    - s/u/-: stage, unstage, stage/unstage 互相切换
    - U: Unstage 所有文件
    - >/</=: 打开 inline diff, 关闭 inline diff, inline diff 开关互相切换

- Diff 映射

    - dd: 水平分割 diff 窗口
    - dv: 垂直分割 diff 窗口

- Commit 映射

    - cc: 创建 commit
    - ca: 修改上一次的 commit

- Checkout/branch 映射

    - coo: checkout 光标下的 commit

'''
print(DOCS)
EOF
endfunction

" Git 插件
" Plug 'tpope/vim-fugitive'
" Plug 'tveskag/nvim-blame-line'
Plug  'airblade/vim-gitgutter'
