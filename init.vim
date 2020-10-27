let g:homes = {}
let g:homes['mac'] = '$HOME/\.config/nvim'
let g:homes['linux'] = '$HOME/\.config/nvim'
let g:homes['win'] = '$HOME/AppData/Local/nvim'

" neovim python3 可执行程序路径, 参见: https://neovim.io/doc/user/provider.html
let g:python3_host_prog = expand('$HOME/.pyenv/shims/python3')

if has('unix')
    let g:home = g:homes['linux']
endif

if has('mac')
    let g:home = g:homes['mac']
endif

if has('win32')
    let g:home = g:homes['win']
endif

if !exists('g:home')
    echo 'Platform is not supported!'
    finish
endif

" 缓存文件默认路径
let g:tmpbuf = g:home . '/.tmp'

" 将数组写成多行, 方便注释掉然后排查问题
let settings = [
    \ 'basic',
    \ 'shortcuts',
    \ 'functions',
\ ]
for setting in settings
    exec printf('source %s/settings/%s.vim', g:home, setting)
endfor

let plugins = [
    \ 'coc',
    \ 'fzf',
    \ 'leaderf',
    \ 'nerdtree',
    \ 'snippets',
    \ 'markdown-preview',
    \ 'easymotion',
    \ 'vimtex',
    \ 'others',
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
