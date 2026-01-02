-- mini.nvim has many modules, see the full list here: https://nvim-mini.org/mini.nvim/#modules
return {
  'nvim-mini/mini.nvim',
  version = '0.17.0',
  config = function()
      -- Setup comment
      --
      -- We use `folke/ts-comments` plugin to work with mini.comment, to best
      -- utilize comment ability in variable programming languages, you
      -- should better install treesitter highlight for the language, see
      -- option `ensure_installed` in treesitter plugin
      --
      -- Some common shortcuts:
      --
      -- - Use `gcc` to comment/uncomment current line
      -- - Visual selection, then `gc`
      -- - 
      require('mini.comment').setup()
  end,
  dependencies = {
    'nvim-tree/nvim-web-devicons',
    'nvim-treesitter/nvim-treesitter',
    {
        "folke/ts-comments.nvim",
        opts = {},
    },
  }
}
