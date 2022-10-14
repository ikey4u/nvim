" Automatically read indent configuration from .clang-format in working directory,
" if the indent is not 4, set it as is
function SetCFamilyIndent()
    if !exists(g:VimRoot)
        call FindWorkingDir()
    endif
python3 << EOF
import vim
import os

workdir = vim.eval("g:VimRoot")
fmtfile = os.path.join(workdir, ".clang-format")
if os.path.exists(fmtfile):
    with open(fmtfile) as _:
        for line in _:
            if not line.startswith("IndentWidth:"):
                continue
            line = line.replace("IndentWidth:", "").strip()
            indent = int(line)
            if indent != 4:
                vim.command(f"setlocal ts={indent} sw={indent} sts=0 et")
                break
EOF
endfunction
autocmd FileType c,cpp call SetCFamilyIndent()

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

" 将文件编码转换为 unix.utf-8
function! FormatUnixAndUTF8()
    set fileformat=unix
    set fileencoding=utf-8
    set nobomb
endfunction

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

" 设置工作目录
"
" 当前工作目录标记文件为 ['.git', '.vimroot'], 越靠后的标记文件优先级越高, 如果任何一个标记文件都找
" 不到, 则将工作目录设置为当前文件所在的目录.
"
" 工作目录找到后, 其值将会存放在 g:VimRoot 中.
"
function! FindWorkingDir()
let g:VimRoot = get(g:, 'VimRoot', expand('%:p:h'))

python3 << EOF
import vim
import os
curdir = vim.eval("expand('%:p:h')")
curdir = os.path.abspath(curdir)
if not os.path.isdir(curdir):
    curdir = os.path.dirname(curdir)

def get_root_dir_by_marker(curdir, marker):
    while True:
        # reach filesytem root directory
        if curdir == os.path.dirname(curdir):
            return None
        if os.path.exists(os.path.join(curdir, marker)):
            return curdir
        else:
            curdir = os.path.dirname(curdir)

markers = ['.git', '.vimroot']
rootdirs = []
rootdir = None
for marker in markers:
    rootdirs.append(get_root_dir_by_marker(curdir, marker))
for d in rootdirs[-1::]:
    if d is not None:
        rootdir = d
        break
if rootdir is None:
    rootdir = curdir

if vim.eval("g:VimRoot") != rootdir:
    print(f"[+] change root directory to {rootdir}")
    vim.command(f"let g:VimRoot = '{rootdir}' ")
EOF
endfunction
autocmd BufEnter,BufWinEnter * :call FindWorkingDir()

" :SetColor => Set color theme
command! -nargs=? -complete=command SetColor call SetColor(<q-args>)
" :Tabmsg <cmd> => Capture output of ex command
command! -nargs=+ -complete=command Tabmsg call Tabmsg(<q-args>)
" :Recent => Open recent files
command! Recent call Recent()
" :FmtUU => Convert file encoding into UTF8
command! FmtUU call FormatUnixAndUTF8()
" :FmtJSON => Format JSON file
command! FmtJSON call FormatJSON()
" :Note => Open notes
command! Note exec "sp ~/.vimnotes.txt"
" <leader>ev => Open configuration file
nnoremap <leader>ev :vsplit $MYVIMRC<cr>
" <leader>sv => Refresh configuration file
nnoremap <leader>sv :source $MYVIMRC<cr>
" <space>p => Open configuration directory
nnoremap <space>p :exec "vsplit " . expand(g:home)<cr>
" <space>j => Switch to next tab
nnoremap <space>j :tabnext<cr>
" <space>k => Switch to upper tab
nnoremap <space>k :tabprevious<cr>
" <leader>man => Show this help
nnoremap <silent> <space>M :call Help() <cr> | redraw!
" jk => Enter nomal mode when press jk in insert mode
inoremap jk <esc>
" \P => Copy current file absolute path into clipboard
nnoremap <silent> <leader>P :let @+ = expand("%:p")<cr>
" Cm => Remove all ^M Symbols in normal mode
" normal 模式下输入 Cm 清除行尾 ^M 符号并保证为 unix 文件格式
" g 表示全局, e 表示如果出错则不显示错误信息, 如果文件没有 ^M,
" 但是按下这个快捷键就会报错, 因此这里使用 e 来屏蔽错误
nnoremap <silent> Cm :%s/\r$//ge<CR>:set fileformat=unix<CR>
" <C-h>, <C-l>, <C-j>, <C-k> => resize window in normal mode
noremap <silent> <C-h> :vertical resize +3<CR>
noremap <silent> <C-l> :vertical resize -3<CR>
noremap <silent> <C-j> :resize +3<CR>
noremap <silent> <C-k> :resize -3<CR>

" load vim plugins
let plugins = [
    \ 'nerdtree',
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
    exec printf('source %s/plugins/%s.vim', g:home, plugin)
endfor
call plug#end()

" load lua plugins
lua require('index')
