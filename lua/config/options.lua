-- Always show diagnostic column
vim.opt.signcolumn = "yes"

-- Make neovim floating windows bordered, available since nvim 0.11.0.
--
-- Once more, how to go into the floating window? Press twice the shortcut.
-- Take hover as an example, you press shift+k to open hover window, then
-- press again shift+k to go into the opened floating window, to exit the
-- floating window, press `:q`.
vim.o.winborder = "rounded"

vim.opt.filetype = "on"
vim.cmd("filetype plugin on")
vim.cmd("filetype plugin indent on")

vim.opt.smartindent = true
vim.opt.smarttab = true

vim.opt.expandtab = true
vim.opt.shiftwidth = 4
vim.opt.tabstop = 4
vim.opt.softtabstop = 4

vim.env.LANG = "en"
vim.opt.langmenu = "zh_CN.UTF-8"

vim.opt.timeoutlen = 1000
vim.opt.ttimeoutlen = 0

vim.opt.virtualedit = "all"
vim.opt.wrap = false
vim.opt.shortmess:append("atI")
vim.opt.showmatch = true
vim.opt.cindent = true
vim.opt.autoindent = true
vim.opt.mouse = "a"
vim.opt.showcmd = true
vim.cmd("syntax on")
vim.g.html_use_css = 1
vim.g.html_number_lines = 0

vim.opt.encoding = "utf-8"
vim.opt.fileencoding = "utf-8"
vim.opt.fileencodings = { "ucs-bom", "utf-8", "gbk", "cp936" }
vim.opt.fileformat = "unix"
vim.opt.fileformats = { "unix", "dos", "mac" }

vim.opt.foldlevel = 99
vim.opt.foldenable = true
vim.opt.foldmethod = "marker"

vim.opt.writebackup = false
vim.opt.backup = false
vim.opt.swapfile = false
vim.opt.undofile = false

if vim.fn.filereadable(vim.g.home .. "/colors/diokai.vim") == 1 then
    vim.cmd("colorscheme diokai")
end

vim.opt.formatoptions:append("mB")
vim.opt.formatoptions:remove("t")

vim.opt.colorcolumn = "80"
vim.opt.textwidth = 80
vim.opt.autochdir = true
vim.opt.number = true

vim.opt.clipboard:append("unnamedplus")

vim.o.autoread = true

vim.lsp.set_log_level("off")
