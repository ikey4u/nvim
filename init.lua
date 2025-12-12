local env = require("std.env")

vim.g.home = env.script_dir()
vim.g.tmpbuf = env.home_dir() .. "/.cache"

require("config.options")
require("config.lazy")
