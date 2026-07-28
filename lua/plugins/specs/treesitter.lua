local languages = {
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
}

return {
    "nvim-treesitter/nvim-treesitter",
    dependencies = {
        {
            "nvim-treesitter/nvim-treesitter-textobjects",
            branch = "main",
            config = function()
                local textobjects = require("nvim-treesitter-textobjects")
                local select = require("nvim-treesitter-textobjects.select")

                textobjects.setup({ select = { lookahead = true } })

                local mappings = {
                    af = "@function.outer",
                    ["if"] = "@function.inner",
                    ac = "@class.outer",
                    ic = "@class.inner",
                    aa = "@parameter.outer",
                    ia = "@parameter.inner",
                }

                for key, query in pairs(mappings) do
                    vim.keymap.set({ "x", "o" }, key, function()
                        select.select_textobject(query, "textobjects")
                    end, { silent = true })
                end
            end,
        },
        {
            "MeanderingProgrammer/treesitter-modules.nvim",
            config = function()
                require("treesitter-modules").setup({
                    ensure_installed = languages,
                    install_options = { max_jobs = 1 },
                    incremental_selection = {
                        enable = true,
                        keymaps = {
                            init_selection = "<CR>",
                            node_incremental = "<CR>",
                            scope_incremental = "grc",
                            node_decremental = "grm",
                        },
                    },
                    indent = { enable = false },
                })
            end,
        },
    },
    branch = "main",
    lazy = false,
    build = ":TSUpdate",
    config = function()
        require("nvim-treesitter").setup({
            install_dir = vim.fn.stdpath("data") .. "/site",
        })

        local group = vim.api.nvim_create_augroup("TreesitterHighlight", { clear = true })
        vim.api.nvim_create_autocmd("FileType", {
            group = group,
            callback = function(args)
                if vim.bo[args.buf].filetype ~= "html" then
                    pcall(vim.treesitter.start, args.buf)
                end
            end,
        })

        vim.opt.conceallevel = 0
    end,
}
