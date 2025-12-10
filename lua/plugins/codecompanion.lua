return {
  {
    "olimorris/codecompanion.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
      "hrsh7th/nvim-cmp",
      "nvim-telescope/telescope.nvim",
    },
    config = function()
      require("codecompanion").setup({
        strategies = {
          chat = { adapter = "deepseek" },
          inline = { adapter = "deepseek" },
          agent = { adapter = "deepseek" },
        },
        adapters = {
          deepseek = function()
            return require("codecompanion.adapters").extend("openai", {
              env = {
                api_key = vim.fn.getenv("DEEPSEEK_API_KEY") or "YOUR_API_KEY_HERE",
              },
              url = "https://api.deepseek.com/v1",
              schema = {
                model = { default = "deepseek-coder" },
              },
            })
          end,
        },
        display = {
          action_palette = { provider = "telescope" },
          chat = {
            show_settings = true,
            separator = "─",
          },
        },
        log_level = "DEBUG",
      })

      vim.keymap.set("n", "<leader>aa", "<cmd>CodeCompanionActions<cr>", { desc = "CodeCompanion Actions" })
      vim.keymap.set("v", "<leader>aa", "<cmd>CodeCompanionActions<cr>", { desc = "CodeCompanion Actions" })
      vim.keymap.set("n", "<leader>ac", "<cmd>CodeCompanionChat<cr>", { desc = "CodeCompanion Chat" })
      vim.keymap.set("v", "<leader>ac", "<cmd>CodeCompanionChat<cr>", { desc = "CodeCompanion Chat" })
      vim.keymap.set("v", "ga", "<cmd>CodeCompanionAdd<cr>", { desc = "Add selected code to chat" })
      vim.keymap.set("n", "<leader>ai", "<cmd>CodeCompanionInline<cr>", { desc = "Inline AI" })
      vim.keymap.set("v", "<leader>ai", "<cmd>CodeCompanionInline<cr>", { desc = "Inline AI" })
    end,
    cmd = { "CodeCompanion", "CodeCompanionChat", "CodeCompanionInline" },
    event = "VeryLazy",
  },
}
