-- 编译时尝试的编译器顺序, 可以使用 CC 环境变量指定编译器
require('nvim-treesitter.install').compilers = {
    vim.fn.getenv('CC'), "zig", "clang", "gcc",
}

require('nvim-treesitter.configs').setup {
  ensure_installed = {
      "html", "css", "cpp", "bash", "vim", "lua", "javascript", "go", "rust", "cmake", "json",
      "make", "kotlin", "vue", "svelte", "python", "toml",
  },
  highlight = {
    enable = true,
    additional_vim_regex_highlighting = false
  },
  incremental_selection = {
    enable = true,
    keymaps = {
      init_selection = '<CR>',
      node_incremental = '<CR>',
    }
  },
  indent = {
    enable = true
  }
}
