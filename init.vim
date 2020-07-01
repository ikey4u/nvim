if !exists("g:os")
    if has("mac")
        let g:os = "mac"
        let g:home = "$HOME/\.config/nvim"
    elseif has("unix")
        let g:os = "linux"
        echo "Not support"
        finish
    elseif has("win32")
        let g:os = "win"
        echo "Not support"
        finish
    else
        let g:os = "unknown"
        echo "Not support"
        finish
    endif
endif

source ~/.config/nvim/basic.vim
source ~/.config/nvim/functions.vim
source ~/.config/nvim/shortcuts.vim
source ~/.config/nvim/plugins.vim

" [ 终端按下 ESC 返回 Normal 模式] 
tnoremap <Esc> <C-\><C-n>
" [ 水平或垂直打开终端] 
noremap <Leader>t :split term://zsh<CR>
noremap <Leader>T :vsplit term://zsh<CR>
" nvim 内部的复制放到剪贴板中
set clipboard+=unnamedplus
