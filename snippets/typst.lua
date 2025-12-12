local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node

local function filename_without_ext()
    local filename = vim.fn.expand("%:t:r")
    return filename ~= "" and filename or "untitled"
end

local function current_datetime()
    return os.date("%Y-%m-%d %H:%M:%S")
end

return {
    s({
        trig = "meta",
        name = "Insert typst metadata",
        desc = "Insert metadata template using n.typ",
    }, {
        t('#import "n.typ"'),
        t({ "", '#n.meta("' }),
        f(filename_without_ext),
        t('", "'),
        f(current_datetime),
        t('")'),
        t({ "", "#show: doc => n.pretty(doc)" }),
        i(0),
    }),
}
