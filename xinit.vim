" 水平垂直线显示
set cursorline
set cursorcolumn

" neovim python3 可执行程序路径, 参见: https://neovim.io/doc/user/provider.html
let g:python3_host_prog = expand('$HOME/.pyenv/shims/python3')
" 将数组写成多行, 方便注释掉然后排查问题
let settings = [
    \ 'shortcuts',
    \ 'functions',
\ ]
for setting in settings
    exec printf('source %s/settings/%s.vim', g:home, setting)
endfor

let plugins = [
    \ 'leaderf',
    \ 'nerdtree',
    \ 'markdown-preview',
    \ 'easymotion',
    \ 'vimtex',
    \ 'others',
    \ 'statusline',
    \ 'clang-format',
    \ 'imk',
    \ 'terminal'
\ ]

call plug#begin(g:home . '/plugged')
for plugin in plugins
    exec printf('source %s/settings/plugins/%s.vim', g:home, plugin)
endfor
call plug#end()

" 个性化配置
let envfile = printf('%s/%s', expand('$HOME'), 'Sync/normal/conf/env.vim')
if filereadable(envfile)
    exec printf('source %s', envfile)
endif

