let g:homes = {}
let g:homes['mac'] = '$HOME/\.config/nvim'
let g:homes['linux'] = '$HOME/\.config/nvim'
let g:homes['win'] = '$HOME/AppData/Local/nvim'

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

let settings = ['basic', 'functions', 'shortcuts']
for setting in settings
    exec printf('source %s/settings/%s.vim', g:home, setting)
endfor

let plugins = ['coc', 'fzf', 'leaderf', 'nerdtree', 'snippets', 'others']
call plug#begin(g:home . '/plugged')
for plugin in plugins
    exec printf('source %s/settings/plugins/%s.vim', g:home, plugin)
endfor
call plug#end()

exec printf('source %s/%s', g:home, 'options.vim')
