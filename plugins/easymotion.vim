function! DocEasymotion()
python3 << EOF
DOCS = '''
# Easymotion 文档

正常情况下使用 w 是向前移动一个单词, 如果单词比较靠后,
那么我们需要按多次 w, 使用该插件可以快速移动.

快速按下 <leader><leader>w 就可以在当前行执行搜索,
每一个单词首字母被高亮, 按下高亮字符即可调整.

类似的 <leader><leader>j 是用于向行下跳转,
配合 k 可以向上跳转, 配合 s 可以在当前行搜索字符.
快速光标移动

这里将默认的 <leader><leader> 修改为 <space><space>
'''
print(DOCS)
EOF
endfunction

Plug 'easymotion/vim-easymotion'
" <space><space> => 触发 easymotion
map <space><space> <Plug>(easymotion-prefix)

