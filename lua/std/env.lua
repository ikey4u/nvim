local M = {}

function M.script_dir()
  local file = debug.getinfo(2, "S").source:sub(2)
  return vim.fn.fnamemodify(file, ":h")
end

function M.home_dir()
    return vim.fn.expand("~")
end

return M
