local api = vim.api

-- :Note
api.nvim_create_user_command(
    "Note",
    function()
        vim.cmd("sp ~/.vimnotes.txt")
    end,
    {}
)

local colorSchemeGroup = api.nvim_create_augroup("extrahighlight", { clear = true })
api.nvim_create_autocmd("ColorScheme", {
    group = colorSchemeGroup,
    command = "highlight colorcolumn ctermbg=238",
})

local formatOnSaveGroup = api.nvim_create_augroup("LspFormatOnSave", { clear = true })
api.nvim_create_autocmd("BufWritePre", {
    group = formatOnSaveGroup,
    pattern = "*",
    callback = function()
        vim.lsp.buf.format({
            async = false,
            timeout_ms = 1000,
        })
    end,
})

local ftgroup = api.nvim_create_augroup("Indent", { clear = true })
api.nvim_create_autocmd("FileType", {
    group = ftgroup,
    pattern = {
        "javascriptreact", "svelte", "javascript", "vue",
        "html", "css", "yaml", "dart", "typescript"
    },
    callback = function()
        vim.opt_local.tabstop = 2
        vim.opt_local.shiftwidth = 2
        vim.opt_local.softtabstop = 0
        vim.opt_local.expandtab = true
    end
})
api.nvim_create_autocmd("FileType", {
    group = ftgroup,
    pattern = "text",
    callback = function()
        vim.opt_local.cindent = false
    end
})
api.nvim_create_autocmd("FileType", {
    group = ftgroup,
    pattern = { "c", "cpp" },
    callback = function()
        -- C, C++ switch case indent, see: https://stackoverflow.com/questions/3444696/how-to-disable-vims-indentation-of-switch-case
        vim.opt_local.cinoptions = "l1"
    end
})
api.nvim_create_autocmd("FileType", {
    group = ftgroup,
    pattern = "javascript",
    callback = function()
        vim.bo.filetype = "javascriptreact"
    end,
})
api.nvim_create_autocmd({ "BufNewFile", "BufRead" }, {
    group = ftgroup,
    pattern = "*.json5",
    callback = function()
        vim.bo.filetype = "json5"
    end
})
