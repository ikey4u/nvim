local path = require("std.path")

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

function M.check_python()
    local python

    if vim.env.NVIM_PYTHON_EXE_PATH then
        python = vim.fn.expand("$NVIM_PYTHON_EXE_PATH")
    else
        if M.system() == "Linux" or M.system() == "Darwin" then
            local pyenv_python = vim.fn.expand("$HOME/.pyenv/shims/python3")
            if vim.fn.filereadable(pyenv_python) == 1 then
                python = pyenv_python
            else
                python = vim.fn.exepath("python3")
            end
            local o = vim.system({
                python,
                "-c",
                "import os, sys; print(os.path.realpath(sys.executable))",
            }, { text = true }):wait()
            python = vim.trim(o.stdout)
        else
            python = vim.fn.system([[py -3 -c "import sys; print(sys.executable, end='')"]])
        end
    end

    python = path.absolute(python)

    if not python or vim.fn.executable(python) ~= 1 then
        return nil
    end

    return python
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
