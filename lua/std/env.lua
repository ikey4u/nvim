local M = {}

function M.script_dir()
    local file = debug.getinfo(2, "S").source:sub(2)
    return vim.fn.fnamemodify(file, ":h")
end

function M.home_dir()
    return vim.fn.expand("~")
end

function M.system()
    local sys = vim.loop.os_uname().sysname

    if sys == "Linux" or sys == "Darwin" then
        return sys
    end

    if sys == "Windows_NT" or sys:match("^MINGW") or sys:match("^MSYS") then
        return "Windows"
    end

    return sys
end

local is_mac = vim.fn.has("mac") == 1
local is_win = vim.fn.has("win32") == 1
function M.get_sys_cache_dir()
    if is_win then
        return vim.fn.getenv("LocalAppData")
    elseif is_mac then
        return M.home_dir() .. "/Library/Caches"
    else
        return vim.fn.getenv("XDG_CACHE_HOME") or (M.home_dir() .. "/.cache")
    end
end

function M.get_sys_config_dir()
    if is_win then
        return vim.fn.getenv("AppData")
    elseif is_mac then
        return M.home_dir() .. "/Library/Application Support"
    else
        return vim.fn.getenv("XDG_CONFIG_HOME") or (M.home_dir() .. "/.config")
    end
end

return M
