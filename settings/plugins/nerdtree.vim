function! DocNerdtree()
python3 << EOF
DOCS = '''
# Nerdtree 文档

TODO

'''
print(DOCS)
EOF
endfunction
Plug 'scrooloose/nerdtree'
" <leader>r => 自动刷新 nerdtree 目录到当前工作目录
noremap <leader>r :NERDTreeFind<cr>
" 忽略的文件列表
let NERDTreeIgnore = ['\.pyc$', '__pycache__', '\.db$']
