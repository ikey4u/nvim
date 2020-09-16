function! DocCoc()
python3 << EOF
DOCS = '''
# Coc 文档

安装 nodejs, 建议采用 n 工具进行安装.

    export N_PREFIX="$HOME/.usr/n"; [[ :$PATH: == *":$N_PREFIX/bin:"* ]] || PATH+=":$N_PREFIX/bin"
    curl -L https://git.io/n-install | bash

安装完成之后在 plug 中添加插件如下并安装.

    Plug 'neoclide/coc.nvim', {'branch': 'release'}

重新打开 nvim 安装插件

- snippets 补全

        :CocInstall coc-snippets

- python 补全

    命令行安装

        pip3 install jedi

    neovim 安装

        :CocInstall coc-python

    然后 :CocConfig 打开 coc 的配置文件, 在里面写入默认 python 路径

        {
            "python.pythonPath": "~/.pyenv/shims/python"
        }

    如果不配置, 可以在 neovim 中打开 python 文件后, 执行如下命令选择 python 解释器

        :CocCommand python.setInterpreter

- C 家族补全

     需要手动下载 clangd 并加入到环境变量中 (https://github.com/clangd/coc-clangd),
     然后在 neovim 中执行

        :CocInstall coc-clangd
'''
print(DOCS)
EOF
endfunction

Plug 'neoclide/coc.nvim', {'branch': 'release'}
" <C-z> 触发 coc 补全
" inoremap <silent><expr> <C-z> coc#refresh()

" Don't pass messages to |ins-completion-menu|.
set shortmess+=c

" Always show the signcolumn, otherwise it would shift the text each time
" diagnostics appear/become resolved.
if has("patch-8.1.1564")
  " Recently vim can merge signcolumn and number column into one
  set signcolumn=number
else
  set signcolumn=yes
endif

" Use tab for trigger completion with characters ahead and navigate.
" NOTE: Use command ':verbose imap <tab>' to make sure tab is not mapped by
" other plugin before putting this into your config.
inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" Use <c-z> to trigger completion.
if has('nvim')
  inoremap <silent><expr> <c-z> coc#refresh()
else
  inoremap <silent><expr> <c-@> coc#refresh()
endif

" Use <cr> to confirm completion, `<C-g>u` means break undo chain at current
" position. Coc only does snippet and additional edit on confirm.
" <cr> could be remapped by other vim plugin, try `:verbose imap <CR>`.
if exists('*complete_info')
  inoremap <expr> <cr> complete_info()["selected"] != "-1" ? "\<C-y>" : "\<C-g>u\<CR>"
else
  inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"
endif

" Use `[g` and `]g` to navigate diagnostics
" Use `:CocDiagnostics` to get all diagnostics of current buffer in location list.
nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)

" GoTo code navigation.
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" Normal 模式下在关键字上按下 K 显示 preview 中的文档
nnoremap K :call <SID>show_documentation()<CR>
function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  else
    call CocAction('doHover')
  endif
endfunction

" Symbol renaming.
nmap <leader>rn <Plug>(coc-rename)

" Add (Neo)Vim's native statusline support.
" NOTE: Please see `:h coc-status` for integrations with external plugins that
" provide custom statusline: lightline.vim, vim-airline.
set statusline^=%{coc#status()}%{get(b:,'coc_current_function','')}
