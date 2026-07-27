return {
    "ibhagwan/fzf-lua",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
        local fzf = require("fzf-lua")

        fzf.setup({})

        local no_preview = {
            winopts = { preview = { hidden = true } },
        }

        local function files(opts)
            fzf.files(vim.tbl_deep_extend("force", {}, no_preview, opts or {}))
        end

        local function grep(query, opts)
            opts = opts or {}
            if query == "" then
                fzf.live_grep(opts)
                return
            end

            opts.search = query
            fzf.grep(opts)
        end

        vim.api.nvim_create_user_command("Lfn", function()
            fzf.lsp_document_symbols()
        end, {})
        vim.api.nvim_create_user_command("Lcs", function()
            fzf.colorschemes()
        end, {})
        vim.api.nvim_create_user_command("Lmru", function()
            fzf.oldfiles()
        end, {})

        vim.api.nvim_create_user_command("Lf", function()
            files()
        end, {})
        vim.api.nvim_create_user_command("Lff", function()
            files({ fzf_opts = { ["--ignore-case"] = true } })
        end, {})
        vim.api.nvim_create_user_command("Lfff", function()
            files({
                cmd = "rg --files --hidden --follow --no-ignore -g '!.git/*'",
            })
        end, {})

        vim.api.nvim_create_user_command("Lr", function(opts)
            grep(opts.args)
        end, { nargs = "*" })
        vim.api.nvim_create_user_command("Lrr", function(opts)
            grep(opts.args, { fzf_opts = { ["--ignore-case"] = true } })
        end, { nargs = "*" })
        vim.api.nvim_create_user_command("Lrrr", function(opts)
            grep(opts.args, { hidden = true, no_ignore = true })
        end, { nargs = "*" })
        vim.api.nvim_create_user_command("Lw", function(opts)
            grep(opts.args)
        end, { nargs = "*" })
        vim.api.nvim_create_user_command("Lww", function(opts)
            grep(opts.args, { fzf_opts = { ["--ignore-case"] = true } })
        end, { nargs = "*" })
        vim.api.nvim_create_user_command("Lwww", function(opts)
            grep(opts.args, { hidden = true, no_ignore = true })
        end, { nargs = "*" })

        vim.keymap.set("n", "<leader>Fb", function()
            fzf.buffers()
        end, { noremap = true, silent = true })
        vim.keymap.set("n", "<leader>w", function()
            fzf.grep_cword({ fzf_opts = { ["--ignore-case"] = true } })
        end, { noremap = true, silent = true })
        vim.keymap.set("n", "<leader>fw", function()
            fzf.grep_cword({ hidden = true, no_ignore = true })
        end, { noremap = true, silent = true })
    end,
}
