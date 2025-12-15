local env = require("std.env")
local io = require("std.io")

vim.g.home = env.script_dir()
vim.g.tmpbuf = env.home_dir() .. "/.cache"

local pyexe = env.check_python()
if pyexe then
    vim.g.python3_host_prog = pyexe
else
    io.echo("[!] python3 is not found, the python related plugins may not work")
end

require("config.options")
require("config.keymaps")
require("config.commands")
require("config.lazy")
