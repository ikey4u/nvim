local M = {}

-- Get mason installed LSP binary path
function M.get_mason_binary_path(lsp_name)
    local registry = require("mason-registry")
    local mason_lspconfig = require("mason-lspconfig")

    local mapping = mason_lspconfig.get_mappings().lspconfig_to_package
    local pkg_name = mapping[lsp_name] or lsp_name
    if not registry.is_installed(pkg_name) then
        return nil
    end

    local bin_path = vim.fn.stdpath("data") .. "/mason/bin/" .. pkg_name
    if vim.fn.executable(bin_path) == 1 then
        return bin_path
    end

    return nil
end

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

    local mason_bin_path = M.get_mason_binary_path(name)
    cmd = vim.fn.exepath(mason_bin_path)
    if cmd and cmd ~= "" then
        return cmd
    end

    return cmd
end

function M.get_config(opts)
    local builtin = {
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
    if opts ~= nil then
        builtin = vim.tbl_deep_extend('force', builtin, opts)
    end
    return builtin
end

return M
