" :call CNmark2ENmark => 中文标点替换为英文标点
function! CNmark2ENmark()
        exe "try | %s/：/:/g | catch | endtry"
        exe "try | %s/。/./g | catch | endtry"
        exe "try | %s/，/,/g  | catch | endtry"
        exe "try | %s/；/;/g | catch | endtry"
        exe "try | %s/？/?/g | catch | endtry"
        exe "try | %s/‘/\'/g | catch | endtry"
        exe "try | %s/’/\'/g | catch | endtry"
        exe "try | %s/”/\"/g | catch | endtry"
        exe "try | %s/“/\"/g | catch | endtry"
        exe "try | %s/《/\</g | catch | endtry"
        exe "try | %s/》/\>/g | catch | endtry"
        exe "try | %s/——/-/g | catch | endtry"
        exe "try | %s/）/\)/g | catch | endtry"
        exe "try | %s/（/\(/g | catch | endtry"
        exe "try | %s/……/^/g | catch | endtry"
        exe "try | %s/￥/$/g | catch | endtry"
        exe "try | %s/！/!/g | catch | endtry"
        exe "try | %s/·/`/g | catch | endtry"
        exe "try | %s/、/,/g | catch | endtry"
        exe "try | %s/│/|/g | catch | endtry"
        exe "try | %s/　/ /g | catch | endtry"
endfunction

" :call ENmark2CNmark => 英文标点替换为中文标点
function! ENmark2CNmark()
        exe "try | %s/:/：/g | catch | endtry"
        exe "try | %s/,/，/g  | catch | endtry"
        exe "try | %s/;/；/g | catch | endtry"
        exe "try | %s/?/？/g | catch | endtry"
        exe "try | %s/\'/‘/g | catch | endtry"
        exe "try | %s/\'/’/g | catch | endtry"
        exe "try | %s/\"/”/g | catch | endtry"
        exe "try | %s/\"/“/g | catch | endtry"
        exe "try | %s/\</《/g | catch | endtry"
        exe "try | %s/\>/》/g | catch | endtry"
        exe "try | %s/\)/）/g | catch | endtry"
        exe "try | %s/\(/（/g | catch | endtry"
        exe "try | %s/$/￥/g | catch | endtry"
        exe "try | %s/!/！/g | catch | endtry"
        exe "try | %s/|/│/g | catch | endtry"
        exe "try | %s/ /　/g | catch | endtry"
endfunction

" [捕获 Ex 输出]
" 捕获 ex 的输出, 用法 :Tabmsg <cmd>
" 将会打开一个新的 tab 窗口, 存放输出的消息
" http://vim.wikia.com/wiki/Capture_ex_command_output
function! Tabmsg(cmd)
  redir => message
  silent execute a:cmd
  redir END
  if empty(message)
    echoerr "no output"
  else
    " use "new" instead of "tabnew" below if you prefer split windows instead of tabs
    tabnew
    setlocal buftype=nofile bufhidden=wipe noswapfile nobuflisted nomodified
    silent put=message
  endif
endfunction
" :Tabmsg <cmd> => 捕获 ex 命令 <cmd> 的输出
command! -nargs=+ -complete=command Tabmsg call Tabmsg(<q-args>)

" [最近文件列表]
" :Recent 打开最近打开的文件列表, 然后使用 gf 打开文件
function! Recent()
    " => 表示将消息重定位到变量中
    redir => recent
    silent execute "browse oldfiles"
    redir END
    tabnew
    setlocal buftype=nofile bufhidden=wipe noswapfile nobuflisted nomodified
    silent put=recent
endfunction
" :Recent => 显示最近文件列表
command! Recent call Recent()

" [将文件编码转换为 unix.utf-8]
function! FormatUnixAndUTF8()
    set fileformat=unix
    set fileencoding=utf-8
    set nobomb
endfunction
command! FmtUU call FormatUnixAndUTF8()

" JSON 格式化
function! FormatJSON()
python3 << EOF
import vim
import json
fpath = vim.eval("expand('%:p')")
with open(fpath, "r+", encoding = "utf-8") as _:
    lines = json.load(_)
    _.seek(0)
    _.truncate(0)
    json.dump(lines, _, ensure_ascii = False, indent = 4)
EOF
endfunction
" :FmtJSON => 格式化 JSON
command! FmtJSON call FormatJSON()

" 年记录
function! Year()
    exec 'vsplit ' . expand(g:myyear)
endfunction
command! Year call Year()

" 计划日程
function! Plan()
    exec 'vsplit ' . expand(g:myplan)
endfunction
command! Plan call Plan()

" 书籍阅读
function! Book()
    exec 'vsplit ' . expand(g:mybook)
endfunction
command! Book call Book()

" 创意思维
function! Idea()
    exec 'vsplit ' . expand(g:myidea)
endfunction
command! Idea call Idea()

function! Help()
    " 将所有 .vim 文件中符合以下格式的文档提取出来, 作为帮助文档
    "
    "   " <command> => <explain>
    "
    " 格式为: 双引号开始, 接着是命令, 然后是箭头, 箭头后面是解释.
    "
    " 实际上就是执行下面的命令
    "
    "   rg -I -N --glob "*.vim" '"\s* (.+) => (\w+)' -r '- $1: $2' > $HOME/.config/nvim/.tmp
    "
    silent exec printf("!rg -I -N --glob \"*.vim\" '\"\\s* (.+) => (\\w+)' -r '- $1 ⇒ $2' %s > %s", g:home, g:tmpbuf)
    exec printf('vnew %s', g:tmpbuf)
endfunction
" <leader>man => 显示本帮助文档
nnoremap <silent> <leader>man :call Help() <cr> | redraw!

function! SetColor(color)
    let colors = split(a:color, '\.')

    if len(colors) == 1
        exec 'colorscheme '. colors[0]
    elseif len(colors) == 2
        let level = colors[1]
        exec 'set background=' . level

        let colorname = colors[0]
        exec 'colorscheme '. colorname
    else
        let colors = [
                    \ "desert.dark",
                    \ "diokai.dark",
                    \ "dracula.dark",
                    \ "perun.dark",
                    \ "rupza.dark",
                    \ "evening.dark",
                    \ "fruchtig.light",
                    \ "cosmic_latte.<dark|light>",
                    \ ]

        redir => message
        silent echom "Usage: SetColor <colorname>.<light|dark>"
        silent echom "Available color schemes:"
        for color in colors
            silent echom "    " . color
        endfor
        redir END

        vnew
        setlocal buftype=nofile bufhidden=wipe noswapfile nobuflisted nomodified
        silent put=message
    endif
endfunction
" :SetColor => 设置颜色主题
command! -nargs=? -complete=command SetColor call SetColor(<q-args>)

" shebang 设定
function! CinOptions()
    " sh 类型的文件启用 shebang 缩进, 其他文件则取消
    if &filetype == "sh"
        set cinoptions=#1
    else
        set cinoptions=#0
    endif
endfunction
autocmd WinEnter * :call CinOptions()

" 设置工作目录
"
" 从当前文件路径向上回溯, 直到找到一个目录包含有一个文件 .vimroot 为止,
" 含有 .vimroot 的目录即被设置为工作目录, 该工作目录的值被放到 g:VimRoot 中.
" 如果找不到含有 .vimroot 的目录, 那么就设置工作目录为当前文件所在的目录.
function! FindWorkingDir()
python3 << EOF
import vim
import os
curdir = vim.eval("expand('%:h')")
curdir = os.path.abspath(curdir)
if not os.path.isdir(curdir):
    curdir = os.path.dirname(curdir)

rootdir = curdir
while True:
    # reach filesytem root directory
    if curdir == os.path.dirname(curdir):
        break
    if os.path.exists(os.path.join(curdir, '.vimroot')):
        rootdir = curdir
        break
    else:
        curdir = os.path.dirname(curdir)
vim.command(f"let g:VimRoot = '{rootdir}' ")
EOF
endfunction
