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
