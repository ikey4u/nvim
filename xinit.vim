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
endfunction

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
nnoremap Cs :StripWhitespace<CR>

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
Plug 'ntpeters/vim-better-whitespace'
let g:better_whitespace_enabled=1
Plug 'ryanoasis/vim-devicons'
Plug 'udalov/kotlin-vim'
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
" 在远程主机上拷贝到本地剪切板
Plug 'ojroques/vim-oscyank'
" vim 中执行 y 操作时, 自动拷贝到本地剪贴板
autocmd TextYankPost * if v:event.operator is 'y' && v:event.regname is '' | execute 'OSCYankReg "' | endif
let g:oscyank_max_length = 1000000
" 将终端视作 tmux, 该选项十分重要, 如果不设置, 在 tmux 中无法正确复制,
" 如果不用 tmux 设置此选项页也没有副作用, 因此加上该选项
let g:oscyank_term = 'tmux'
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
let g:UltiSnipsSnippetDirectories=[g:home . '/snips']
" Rust Analyzer Wrapper
Plug 'simrat39/rust-tools.nvim'
" Lua Utilities
Plug 'nvim-lua/plenary.nvim'
" golang
Plug 'fatih/vim-go', { 'do': ':GoUpdateBinaries' }
let g:go_fmt_autosave = 0
" neovim builtin language server configuration
Plug 'neovim/nvim-lspconfig'
" mason package manager
Plug 'williamboman/mason.nvim'
" lspconfig plugin for mason
Plug 'williamboman/mason-lspconfig.nvim'
Plug 'ikey4u/nvim-previewer', { 'do': 'cargo build --release' }
let g:nvim_previewer_browser = "firefox"
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim', { 'tag': '0.1.0' }
nnoremap <leader>ff <cmd>lua require('telescope.builtin').find_files{ cwd = vim.g.VimRoot }<cr>
nnoremap <leader>fg <cmd>lua require('telescope.builtin').live_grep{ cwd = vim.g.VimRoot }<cr>
nnoremap <leader>fb <cmd>Telescope buffers<cr>
nnoremap <leader>fh <cmd>Telescope help_tags<cr>
nnoremap <leader>w :execute 'Telescope live_grep default_text=' . expand('<cword>') . ' search_dirs=' . g:VimRoot <cr>
call plug#end()

autocmd FileType c,cpp call SetCFamilyIndent()
autocmd BufEnter,BufWinEnter * :call FindWorkingDir()

lua require('index')
