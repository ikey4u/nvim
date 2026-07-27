local env = require("std.env")

vim.g.home = env.script_dir()
vim.g.tmpbuf = env.home_dir() .. "/.cache"
vim.env.CONFIG_DIR = env.get_sys_config_dir()
vim.env.CACHE_DIR = env.get_sys_cache_dir()

require("config.options")
require("config.keymaps")
require("config.commands")
require("plugins.lazy")
