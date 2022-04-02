" 本插件参考修改自: https://gist.github.com/ram535/b1b7af6cd7769ec0481eb2eed549ea23

let s:monkey_terminal_window = -1
let s:monkey_terminal_buffer = -1
let s:monkey_terminal_job_id = -1

function! MonkeyTerminalOpen()
    if !bufexists(s:monkey_terminal_buffer)
        new monkey_terminal
        wincmd J
        resize 10
        let s:monkey_terminal_job_id = termopen($SHELL, { 'detach': 1 })

        silent file Terminal\ 1
        let s:monkey_terminal_window = win_getid()
        let s:monkey_terminal_buffer = bufnr('%')

        set nobuflisted

        startinsert
    else
        if !win_gotoid(s:monkey_terminal_window)
            sp
            wincmd J
            resize 10
            buffer Terminal\ 1
            let s:monkey_terminal_window = win_getid()
        endif
    endif
endfunction

function! MonkeyTerminalToggle()
    if win_gotoid(s:monkey_terminal_window)
        call MonkeyTerminalClose()
    else
        call MonkeyTerminalOpen()
    endif
endfunction

function! MonkeyTerminalClose()
    if win_gotoid(s:monkey_terminal_window)
        hide
    endif
endfunction

" <C-\> => 切换终端
nnoremap <C-\> :call MonkeyTerminalToggle()<cr>
tnoremap <C-\> <C-\><C-n>:call MonkeyTerminalToggle()<cr>
" <ESC><ESC> => 终端模式下快速按下两个 ESC 进入 Normal 模式
tnoremap <ESC><ESC> <C-\><C-n>
