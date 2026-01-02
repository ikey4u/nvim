return {
    "nvim-treesitter/nvim-treesitter",
    dependencies = {
        "nvim-treesitter/nvim-treesitter-textobjects",
    },
    branch = "master",
    lazy = false,
    build = ":TSUpdate",
    main = "nvim-treesitter.config",
    config = function()
        require("nvim-treesitter.install").compilers = {
            vim.fn.getenv("CC"),
            "clang",
            "zig",
            "gcc",
        }

        require("nvim-treesitter.configs").setup({
            ensure_installed = {
                "html",
                "css",
                "cpp",
                "bash",
                "vim",
                "lua",
                "go",
                "rust",
                "cmake",
                "json",
                "make",
                "kotlin",
                "python",
                "toml",
                "json5",
                "c",
                "svelte",
                "vue",
                "typescript",
            },
            highlight = {
                enable = true,
                additional_vim_regex_highlighting = false,
                -- treesitter cannot highlight large html, see https://github.com/nvim-treesitter/nvim-treesitter/issues/1788
                disable = { "html" },
            },
            incremental_selection = {
                enable = true,
                keymaps = {
                    init_selection = "<CR>",
                    node_incremental = "<CR>",
                },
            },
            -- It seems that treesitter has a bad support for indent
            indent = {
                enable = false,
            },

            textobjects = {
                select = {
                    enable = true,
                    lookahead = true,
                    keymaps = {
                        ["af"] = "@function.outer",
                        ["if"] = "@function.inner",
                        ["ac"] = "@class.outer",
                        ["ic"] = "@class.inner",
                        ["aa"] = "@parameter.outer",
                        ["ia"] = "@parameter.inner",
                    },
                },
            }
        })

        -- treesitter will always enable conceallevel which will make markdown
        -- code block boundary concealed.
        --
        -- See https://github.com/nvim-treesitter/nvim-treesitter/issues/3723
        vim.opt.conceallevel = 0
    end,
}
