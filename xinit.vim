" Automatically format c/cpp and header files on save
function ClangFormat()
    call FindWorkingDir()
    let cfc = g:VimRoot . "/.clang-format"
    if !filereadable(cfc)
        echomsg printf(".clang-format is not found: %s", cfc)
        return 0
    endif
    let cfc_disable_marker = g:VimRoot . "/.clang-format-disabled"
    if filereadable(cfc_disable_marker)
        echomsg printf(".clang-format is explicitly disabled using %s", cfc_disable_marker)
        return 0
    endif

    let clang_format_command = $CLANG_FORMAT_PATH
    echomsg clang_format_command
    if !executable(clang_format_command)
        let clang_format_command = "clang-format"
    endif
    if executable(clang_format_command)
        execute printf("silent !%s --style=file:%s -i %s", expand(clang_format_command), cfc, expand("%:p"))
        " disable warning message `Press ENTER or type command to continue` generated from above command
        redraw
    else
        echomsg printf(".clang-format is found at %s, but clang-format command is not found!", cfc)
    endif
endfunction

" Automatically read indent configuration from .clang-format in working directory,
" if the indent is not 4, set it as is
function SetCFamilyIndent()
    call FindWorkingDir()
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

function! Display(msg)
    if empty(a:msg)
        return
    endif

    " create a horizontal split virtual unnamed buffer window
    new
    setlocal buftype=nofile bufhidden=wipe noswapfile nobuflisted nomodified
    " put the message on the first line
    let msg = substitute(a:msg, '\r', '', 'g')
    silent put = msg
endfunction

" 捕获 ex 的输出, 用法 :Redir <cmd>
" 将会打开一个新的 tab 窗口, 存放输出的消息
" http://vim.wikia.com/wiki/Capture_ex_command_output
function! Redir(cmd)
    redir => message
    silent execute a:cmd
    redir END
    call Display(message)
endfunction

" Open history echoed messages in unnamed buffer
function! Message()
    redir => message
    silent messages
    redir END
    call Display(message)
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
for d in rootdirs[::-1]:
    if d is not None:
        rootdir = d
        break
if rootdir is None:
    rootdir = curdir

if vim.eval("g:VimRoot") != rootdir:
    print(f"[+] change root directory to {rootdir}")
    vim.command(f"let g:VimRoot = '{rootdir}' ")
EOF
" update leaderf working directory
let g:Lf_WorkingDirectory=g:VimRoot
endfunction

" :SetColor => Set color theme
command! -nargs=? -complete=command SetColor call SetColor(<q-args>)
" :Redir <cmd> => Capture output of ex command
command! -nargs=+ -complete=command Redir call Redir(<q-args>)
" :Message <cmd> => Echo history echoed message
command! Message call Message()
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
nnoremap Cs :%s/\s\+$//ge<CR>

" load vim plugins
let plugins = [
    \ 'nerdtree',
    \ 'vimtex',
\ ]
call plug#begin(g:home . '/plugged')
Plug 'scrooloose/nerdtree'
exec printf('source %s/%s', g:home, 'nerdtree.conf')
Plug 'lervag/vimtex'
exec printf('source %s/%s', g:home, 'vimtex.conf')
Plug 'jiangmiao/auto-pairs'
Plug 'scrooloose/nerdcommenter'
let g:NERDSpaceDelims=1
Plug 'mattn/emmet-vim'
Plug 'majutsushi/tagbar'
Plug 'mhinz/vim-startify'
let g:startify_files_number = 20
Plug 'ryanoasis/vim-devicons'
Plug 'udalov/kotlin-vim'
if g:os != "Windows"
    Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
endif

" Yank text to client system clipboard when editing on host using vim
"
"     client ---(ssh)---> host
"
" If you use vim in tmux, you should install tmux-yank
"
"    set -g @plugin 'tmux-plugins/tmux-yank'
"
" and tmux-yank requires xsel on linux.
"
" If you want to paste from client clipboard into host, using cmd+v on darwin
" or ctrl+shift+v on linux
Plug 'ojroques/vim-oscyank'
autocmd TextYankPost * if v:event.operator is 'y' && v:event.regname is '' | execute 'OSCYankRegister "' | endif
let g:oscyank_max_length = 1000000
" If you use vim in tmux, you must enable the following option in tmux
"
"     set -g set-clipboard on
"
let g:oscyank_term = 'default'
" disable verbose message
let g:oscyank_silent = v:true

" 文件格式化插件
Plug 'sbdchd/neoformat'
" markdown 表格
"
" 通过 :TableModeEnable 启用表格模式, 按下 | 开始输入表格内容, 按下 || 自动填充行分隔符.
" 编辑表格完毕后, 可以使用 :TableModeDisable 退出.
Plug 'dhruvasagar/vim-table-mode'
" Auto Completion
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/cmp-buffer'
Plug 'hrsh7th/cmp-path'
Plug 'hrsh7th/cmp-cmdline'
Plug 'hrsh7th/nvim-cmp'
Plug 'quangnguyen30192/cmp-nvim-ultisnips'
Plug 'onsails/lspkind.nvim'
Plug 'SirVer/ultisnips'
let g:UltiSnipsSnippetDirectories=[g:home . '/snips', expand('$HOME/\.snips')]
" Rust Analyzer Wrapper
Plug 'simrat39/rust-tools.nvim'
" Lua Utilities
Plug 'nvim-lua/plenary.nvim'
" golang
if executable("go")
    Plug 'fatih/vim-go', { 'do': ':GoUpdateBinaries' }
    let g:go_fmt_autosave = 0
else
    echomsg "go is not installed, vim-go will not work"
endif
" neovim builtin language server configuration
Plug 'neovim/nvim-lspconfig'
" mason package manager
Plug 'williamboman/mason.nvim'
" lspconfig plugin for mason
Plug 'williamboman/mason-lspconfig.nvim'
if executable("cargo")
    Plug 'ikey4u/nvim-previewer', { 'do': 'cargo build --release', 'branch': 'master' }
    let g:nvim_previewer_browser = "firefox"
else
    echomsg "cargo is not installed, nvim-previewer will not work"
endif

Plug 'Yggdroot/LeaderF'
" disable default shortcut `<leader>f`
let g:Lf_ShortcutF = ""
" search files in buffer
noremap <leader>Fb :<C-U><C-R>=printf("Leaderf buffer %s", "")<CR><CR>
" disable cache (or else you cannot find new added files)
let g:Lf_UseCache = 0
" see https://github.com/universal-ctags/ctags to intall exctags.
" note that the default name for exctags is ctags, you must rename it to exctags
if executable("exctags")
    let g:Lf_Ctags = "exctags"
else
    echomsg "exctags (ctags) is not installed, Leaderf tags will not work"
endif
" LeaderF's working directory will be set in function FindWorkingDir,
" as a result we do not need root marker and directory mode:
"
"     let g:Lf_RootMarkers = ['.vimroot', '.git']
"     let g:Lf_WorkingDirectoryMode = 'Ac'
"
let g:Lf_WildIgnore = {
        \ 'dir': ['.svn','.git','.hg', '.cache'],
        \ 'file': ['*.sw?','~$*','*.bak','*.exe','*.o','*.so','*.py[co]']
        \}
let g:Lf_UseVersionControlTool = 0
let g:Lf_RecurseSubmodules = 1
let g:Lf_ShowHidden = 1
if executable("rg")
    let g:Lf_DefaultExternalTool = "rg"
    " :Lfn => Show all functions (require exctags)
    command! Lfn :LeaderfFunction
    " :Lcs => Show color scheme
    command! Lcs :LeaderfColorscheme
    " :Lmru => Show recent opened files
    command! Lmru :LeaderfMru
    " :Lf => Search file
    command! Lf :Leaderf file
    command! Lff :Leaderf file --case-insensitive
    command! Lfff :Leaderf file --case-insensitive --no-ignore
    " :Lr => Search text using regexp (line size is limited to 1000)
    "
    " Leaderf is merely a wrapper of rg which has no option to show partial content of a line,
    " but we can use rg's option `--max-columns-preview` as a workground.
    command! -nargs=+ -complete=command Lr :Leaderf rg -M 1000 -e <q-args><CR>
    command! -nargs=+ -complete=command Lrr :Leaderf rg --ignore-case -M 1000 -e <q-args><CR>
    command! -nargs=+ -complete=command Lrrr :Leaderf rg --ignore-case --no-ignore -M 1000 -e <q-args><CR>
    " :Lw => Search text
    command! -nargs=+ -complete=command Lw :Leaderf rg -M 1000 <q-args><CR>
    command! -nargs=+ -complete=command Lww :Leaderf rg --ignore-case -M 1000 <q-args><CR>
    command! -nargs=+ -complete=command Lwww :Leaderf rg --ignore-case --no-ignore -M 1000 <q-args><CR>
    " <leader>w => Search text under cursor
    noremap <leader>w :<C-U><C-R>=printf("Leaderf rg --ignore-case -M 1000 -e %s ", expand("<cword>"))<CR><CR>
    " <leader>fw => Search text under cursor with ignore and hidden files, `f` represents `full`
    noremap <leader>fw :<C-U><C-R>=printf("Leaderf rg --hidden --ignore-case --no-ignore -M 1000 -e %s ", expand("<cword>"))<CR><CR>
else
    echomsg "rg is not installed, Leaderf search will not work"
endif
call plug#end()

autocmd FileType c,cpp call SetCFamilyIndent()
autocmd BufEnter,BufWinEnter * :call FindWorkingDir()
autocmd BufWritePost *.c,*.cpp,*.h,*.cc :call ClangFormat()
autocmd BufWritePost *.rs :lua vim.lsp.buf.format()

lua require('index')
