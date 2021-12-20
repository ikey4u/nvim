Plug 'neoclide/coc.nvim', {'branch': 'release'}

" 自动安装的扩展列表
let g:coc_global_extensions = ['coc-json', 'coc-git', 'coc-pyright', 'coc-go', 'coc-css', 'coc-html', 'coc-sh', 'coc-snippets', 'coc-rust-analyzer']

" 按下 tab 触发自动补全, 再按 tab 向下移动, 按 shfit tab 向上一动.
" tab 键可能被其他插件覆盖, 使用 `:verbose imap <tab>` 确保 tab 是由 coc 设置的.
inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"
function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" 按下回车执行代码补全
if exists('*complete_info')
  inoremap <expr> <cr> complete_info()["selected"] != "-1" ? "\<C-y>" : "\<C-g>u\<CR>"
else
  inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"
endif

" 代码快捷键
nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)
nmap <silent> sr <Plug>(coc-rename)

" normal 模式下在关键字上按下 K 显示 preview 中的文档
nnoremap K :call <SID>show_documentation()<CR>
function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  else
    call CocAction('doHover')
  endif
endfunction

" 自动导入 go 包
autocmd BufWritePre *.go :silent call CocAction('runCommand', 'editor.action.organizeImport')
