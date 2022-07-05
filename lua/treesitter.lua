-- 编译时尝试的编译器顺序, 可以使用 CC 环境变量指定编译器
require('nvim-treesitter.install').compilers = {
    vim.fn.getenv('CC'), "clang","zig", "gcc",
}

require('nvim-treesitter.configs').setup {
  ensure_installed = {
      "html", "css", "cpp", "bash", "vim", "lua", "go", "rust", "cmake", "json",
      "make", "kotlin", "python", "toml", "json5",
  },
  highlight = {
    enable = true,
    additional_vim_regex_highlighting = false,
    -- 暂时禁用 treesitter 的 html 高亮, https://github.com/nvim-treesitter/nvim-treesitter/issues/1788
    disable = { "html" },
  },
  incremental_selection = {
    enable = true,
    keymaps = {
      init_selection = '<CR>',
      node_incremental = '<CR>',
    }
  },
  indent = {
    enable = true,
  }
}
