local lsp = require('lspconfig')

local on_attach = function(client, bufnr)
  vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

  local bufopts = { noremap=true, silent=true, buffer=bufnr }
  vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, bufopts)
  vim.keymap.set('n', 'gd', vim.lsp.buf.definition, bufopts)
  vim.keymap.set('n', 'K', vim.lsp.buf.hover, bufopts)
  vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, bufopts)
  vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, bufopts)
  vim.keymap.set('n', '<space>wa', vim.lsp.buf.add_workspace_folder, bufopts)
  vim.keymap.set('n', '<space>wr', vim.lsp.buf.remove_workspace_folder, bufopts)
  vim.keymap.set('n', '<space>wl', function()
    print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
  end, bufopts)
  vim.keymap.set('n', '<space>D', vim.lsp.buf.type_definition, bufopts)
  vim.keymap.set('n', '<space>rn', vim.lsp.buf.rename, bufopts)
  vim.keymap.set('n', '<space>ca', vim.lsp.buf.code_action, bufopts)
  vim.keymap.set('n', 'gr', vim.lsp.buf.references, bufopts)
  vim.keymap.set('n', '<space>f', vim.lsp.buf.formatting, bufopts)
end

local lsp_flags = {
  debounce_text_changes = 150,
}

--[[

- 项目根目录

    clangd 的项目根目录使用 .vimroot 文件来标记

- clangd 可执行程序

    需要编译 llvm 14 及其以上版本, 如果是 mac 不要使用自带的 clangd. 编译安装后,
    导出其安装目录为 LLVM_HOME, 该安装目录结构如下

        ${LLVM_HOME}
        ├── bin
        ├── include
        ├── lib
        ├── libexec
        └── share

- clangd 配置文件

    在 .vimroot 所在目录下面新建一个 .clangd 文件, 该文件格式为 YAML, 参考选项参见 https://clangd.llvm.org/config#diagnostics,
    比如如下配置表示屏蔽 clangd 所有警告

        Diagnostics:
            Suppress: '*'

- 生成 compile_commands.json

    cmpile_commands.json 文件的生成依赖于 cmake, 基本命令如下

        mkdir build && cd build
        cmake -DCMAKE_EXPORT_COMPILE_COMMANDS=1  ..

    将生成的文件放到 .vimroot 同目录的 build 目录下即可.

--]]
lsp.clangd.setup {
    on_attach = on_attach,
    flags = lsp_flags,
    cmd = {
        vim.env.LLVM_HOME .. "/bin/clangd",
        "--background-index",
        "--compile-commands-dir=build",
        "--clang-tidy",
        "--clang-tidy-checks=performance-*,bugprone-*",
        "--completion-style=detailed",
        "--all-scopes-completion",
        "--header-insertion=iwyu",
        "-j=8",
    },
    root_dir = lsp.util.root_pattern('.vimroot'),
}
