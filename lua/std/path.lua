local M = {}

function M.absolute(path)
    if not path or path == "" then
        return nil
    end
    return vim.fn.fnamemodify(path, ":p")
end

return M
