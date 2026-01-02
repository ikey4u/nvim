local M = {}

-- Get LSP binary using lsp's name
--
-- Assume the lsp's name is `lua_ls`, then this function will try to search
-- lsp binary from environment `LUA_LS_EXE`, and then `lua_ls` command, the
-- first wins.
function M.get_cmd_from_env(name)
    local cmd

    local env_exe = vim.env[name:upper():gsub("%.", "_") .. "_EXE"]
    if env_exe and env_exe ~= "" then
        local p = vim.fn.exepath(env_exe)
        if p and p ~= "" then
            cmd = p
        end
    end
    if cmd then
        return cmd
    end

    cmd = vim.fn.exepath(name)
    if cmd and cmd ~= "" then
        return cmd
    end

    return cmd
end

function M.get_default()
    return {
        flags = { debounce_text_changes = 150 },
        capabilities = require("cmp_nvim_lsp").default_capabilities(vim.lsp.protocol.make_client_capabilities()),
        on_attach = function(_client, bufnr)
            vim.api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.vim.lsp.omnifunc")
            local bufopts = { noremap = true, silent = true, buffer = bufnr }

            vim.keymap.set("n", "<space>ge", vim.diagnostic.open_float, bufopts)
            vim.keymap.set("n", "<space>gD", vim.lsp.buf.declaration, bufopts)
            vim.keymap.set("n", "<space>gi", vim.lsp.buf.implementation, bufopts)
            vim.keymap.set("n", "<space>gy", "<cmd>split |lua vim.lsp.buf.definition()<CR>", bufopts)
            vim.keymap.set("n", "<space>gx", "<cmd>vsplit |lua vim.lsp.buf.definition()<CR>", bufopts)
            vim.keymap.set("n", "<space>gd", vim.lsp.buf.definition, bufopts)
            vim.keymap.set("n", "<space>gh", ":Lspsaga peek_definition<CR>", bufopts)
            vim.keymap.set("n", "<space>gt", vim.lsp.buf.type_definition, bufopts)
            vim.keymap.set("n", "<space>gn", vim.lsp.buf.rename, bufopts)
            vim.keymap.set("n", "<space>gc", vim.lsp.buf.code_action, bufopts)
            vim.keymap.set("n", "<space>gr", vim.lsp.buf.references, bufopts)
            vim.keymap.set("n", "<space>FF", vim.lsp.buf.format, bufopts)
            vim.keymap.set("n", "<space>gwa", vim.lsp.buf.add_workspace_folder, bufopts)
            vim.keymap.set("n", "<space>gwr", vim.lsp.buf.remove_workspace_folder, bufopts)
            vim.keymap.set("n", "<space>gwl", function()
                print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
            end, bufopts)
        end,
    }
end

return M
