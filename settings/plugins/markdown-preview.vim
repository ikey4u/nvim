" 开启调试日志的方法
"
"   let $NVIM_MKDP_LOG_FILE = expand('~/mkdp-log.log')
"   let $NVIM_MKDP_LOG_LEVEL = 'debug'
"
" 当使用 neovim 监听一个远程 RPC 接口的时候, 不要使用 TCP Socket,
" 也就是不要使用类似于下面的地址
"
"   nvim --listen 127.0.0.1:6666
"
" 因为这种地址在 markdown-preview 插件(nodejs 写的程序)中不受支持, 参见
"
"   https://github.com/iamcco/markdown-preview.nvim/issues/219
"
" 那么怎么解决呢? 远程监听使用 Unix 套接字, 比如
"
"   nvim --listen /tmp/nvim
"
" 注意 nvim 不知持类似与下面的监听地址
"
"   nvim --listen http://127.0.0.1:6666
"
Plug 'iamcco/markdown-preview.nvim', { 'do': 'cd app & npm install'  }
let g:mkdp_auto_start = 1
let g:mkdp_echo_preview_url = 1
