Plug 'lervag/vimtex'

" Disable quickfix window
let g:vimtex_quickfix_enabled=0
if has('mac')
    let g:vimtex_view_method = 'skim'
endif
let g:vimtex_compiler_latexmk = {
      \ 'build_dir': 'out',
      \ 'continuous' : 1,
      \ 'options' : [
      \   '-xelatex',
      \   '-verbose',
      \   '-silent',
      \   '-synctex=1',
      \   '-interaction=nonstopmode',
      \   '-file-line-error',
      \   '-bibtex',
      \ ],
      \}
autocmd Filetype tex setl updatetime=10

" symbol hidden level
"
"     0: show normal text
"     1: replace hidden symbol with space
"     2: hide the hidden symbol
set conceallevel=2
" a = accents/ligatures
" b = bold and italic
" d = delimiters
" m = math symbols
" g = Greek
" s = superscripts/subscripts
let g:tex_conceal='abdmg'
let g:tex_flavor = 'xelatex'
let g:vimtex_compiler_progname = 'nvr'

" vimtext plugin uses `b:vimtex_main` variable to recognize main tex file when there are multiple
" text files. This function set the variable to the file `main.tex` located in the working root
" directory (the directory containing .git directory or .vimroot file).
"
" To make vimtex work, you must also add the following directive on the top of the main tex file
"
"        %! TEX program = xelatex
"
function SetVimTexMainFile()
    if !exists(g:VimRoot)
        call FindWorkingDir()
    endif
    let b:vimtex_main = g:VimRoot . '/main.tex'
endfunction
autocmd BufReadPre *.tex :call SetVimTexMainFile()
