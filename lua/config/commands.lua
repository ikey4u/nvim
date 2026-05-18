local api = vim.api

-- :Note
api.nvim_create_user_command("Note", function()
    vim.cmd("sp ~/.vimnotes.txt")
end, {})

local git_tree = {
    active = false,
    previous = nil,
}

local function git_tree_cwd()
    local name = api.nvim_buf_get_name(0)
    if name ~= "" then
        local dir = vim.fn.fnamemodify(name, ":p:h")
        if vim.fn.isdirectory(dir) == 1 then
            return dir
        end
    end
    return vim.fn.getcwd()
end

local function git_tree_root()
    local result = vim.system({ "git", "rev-parse", "--show-toplevel" }, {
        cwd = git_tree_cwd(),
        text = true,
    }):wait()
    if result.code ~= 0 then
        vim.notify("GitTree: not in a git repository", vim.log.levels.WARN)
        return nil
    end
    return vim.trim(result.stdout or "")
end

local function git_tree_has_changes(root)
    local result = vim.system({ "git", "status", "--porcelain=v1", "-z", "--untracked-files=all" }, {
        cwd = root,
        text = true,
    }):wait()
    if result.code ~= 0 then
        vim.notify("GitTree: failed to read git status", vim.log.levels.ERROR)
        return nil
    end
    return result.stdout ~= ""
end

local function git_tree_core()
    local ok, core = pcall(require, "nvim-tree.core")
    if ok then
        return core
    end
    return nil
end

local function git_tree_set_filter(name, enabled)
    local core = git_tree_core()
    if not core then
        return
    end
    local explorer = core.get_explorer()
    if not explorer or not explorer.filters or explorer.filters.state[name] == enabled then
        return
    end

    local tree_api = require("nvim-tree.api")
    local toggles = {
        git_clean = tree_api.tree.toggle_git_clean_filter,
        dotfiles = tree_api.tree.toggle_hidden_filter,
    }
    if toggles[name] then
        toggles[name]()
    end
end

local function git_tree_save_state()
    local core = git_tree_core()
    local explorer = core and core.get_explorer()
    local filters = explorer and explorer.filters and explorer.filters.state or {}
    git_tree.previous = {
        root = core and core.get_cwd() or nil,
        git_clean = filters.git_clean,
        dotfiles = filters.dotfiles,
    }
end

local function git_tree_disable(tree_api)
    if git_tree.previous and git_tree.previous.root then
        tree_api.tree.open({ path = git_tree.previous.root, focus = true })
        tree_api.tree.change_root(git_tree.previous.root)
    else
        tree_api.tree.open({ focus = true })
    end

    local git_clean = false
    local dotfiles = true
    if git_tree.previous then
        if git_tree.previous.git_clean ~= nil then
            git_clean = git_tree.previous.git_clean
        end
        if git_tree.previous.dotfiles ~= nil then
            dotfiles = git_tree.previous.dotfiles
        end
    end

    git_tree_set_filter("git_clean", git_clean)
    git_tree_set_filter("dotfiles", dotfiles)
    tree_api.tree.reload()
    git_tree.active = false
    git_tree.previous = nil
end

local function git_tree_apply(tree_api, root)
    tree_api.tree.open({ path = root, focus = true })
    tree_api.tree.change_root(root)
    git_tree_set_filter("git_clean", true)
    git_tree_set_filter("dotfiles", false)
    tree_api.git.reload()
    tree_api.tree.reload()
    tree_api.tree.expand_all()
end

local function git_tree_refresh()
    local ok, tree_api = pcall(require, "nvim-tree.api")
    if not ok then
        vim.notify("GitTree: nvim-tree is not available", vim.log.levels.ERROR)
        return
    end

    if not git_tree.active then
        tree_api.git.reload()
        tree_api.tree.reload()
        return
    end

    local root = git_tree_root()
    if not root then
        return
    end

    local has_changes = git_tree_has_changes(root)
    if has_changes == nil then
        return
    end

    if not has_changes then
        tree_api.tree.close()
        git_tree.active = false
        git_tree.previous = nil
        vim.notify("GitTree: no changed files")
        return
    end

    git_tree_apply(tree_api, root)
end

_G.git_tree_refresh = git_tree_refresh

local function git_tree_show()
    local ok, tree_api = pcall(require, "nvim-tree.api")
    if not ok then
        vim.notify("GitTree: nvim-tree is not available", vim.log.levels.ERROR)
        return
    end

    if git_tree.active then
        git_tree_disable(tree_api)
        return
    end

    local root = git_tree_root()
    if not root then
        return
    end

    local has_changes = git_tree_has_changes(root)
    if has_changes == nil then
        return
    end

    if not has_changes then
        tree_api.tree.close()
        vim.notify("GitTree: no changed files")
        return
    end

    git_tree_save_state()
    git_tree_apply(tree_api, root)
    git_tree.active = true
end

api.nvim_create_user_command("GitTree", git_tree_show, {})

local function git_help_show()
    local lines = {
        "Git commands",
        "",
        ":GitTree  Toggle changed-files-only nvim-tree view",
        ":GitHelp  Show this help",
        "",
        "nvim-tree file status signs",
        "",
        "M  modified / unstaged",
        "S  staged",
        "A  added / untracked",
        "D  deleted",
        "R  renamed",
        "U  unmerged",
        "I  ignored",
        "",
        "editor line status signs",
        "",
        "+  added line",
        "~  changed line",
        "_  deleted line",
        "‾  deleted line above first line",
        "≃  changed line with deletion",
        "?  untracked line",
        "",
        "Press q to close",
    }
    local width = 0
    for _, line in ipairs(lines) do
        width = math.max(width, vim.fn.strdisplaywidth(line))
    end
    width = math.min(width + 4, vim.o.columns - 4)
    local height = math.min(#lines, vim.o.lines - 4)
    local buf = api.nvim_create_buf(false, true)
    api.nvim_buf_set_lines(buf, 0, -1, false, lines)
    vim.bo[buf].buftype = "nofile"
    vim.bo[buf].bufhidden = "wipe"
    vim.bo[buf].swapfile = false
    vim.bo[buf].filetype = "githelp"
    vim.bo[buf].modifiable = false
    local win = api.nvim_open_win(buf, true, {
        relative = "editor",
        width = width,
        height = height,
        row = math.max(math.floor((vim.o.lines - height) / 2 - 1), 0),
        col = math.max(math.floor((vim.o.columns - width) / 2), 0),
        style = "minimal",
        border = "single",
    })
    vim.wo[win].number = false
    vim.wo[win].relativenumber = false
    vim.wo[win].signcolumn = "no"
    vim.keymap.set("n", "q", function()
        api.nvim_win_close(win, true)
    end, { buffer = buf, noremap = true, silent = true })
end

api.nvim_create_user_command("GitHelp", git_help_show, {})

local color_scheme_group = api.nvim_create_augroup("extrahighlight", { clear = true })
api.nvim_create_autocmd("ColorScheme", {
    group = color_scheme_group,
    command = "highlight colorcolumn ctermbg=238",
})

vim.g.format_on_save = false

local format_on_save_group = api.nvim_create_augroup("LspFormatOnSave", { clear = true })
api.nvim_create_autocmd("BufWritePre", {
    group = format_on_save_group,
    pattern = "*",
    callback = function()
        if not vim.g.format_on_save then
            return
        end
        vim.lsp.buf.format({
            async = false,
            timeout_ms = 1000,
        })
        vim.cmd("retab")
    end,
})

api.nvim_create_user_command("FormatEnable", function()
    vim.g.format_on_save = true
    vim.notify("Format on save: enabled")
end, {})

api.nvim_create_user_command("FormatDisable", function()
    vim.g.format_on_save = false
    vim.notify("Format on save: disabled")
end, {})

api.nvim_create_user_command("FormatToggle", function()
    vim.g.format_on_save = not vim.g.format_on_save
    vim.notify("Format on save: " .. (vim.g.format_on_save and "enabled" or "disabled"))
end, {})

local ftgroup = api.nvim_create_augroup("Indent", { clear = true })
api.nvim_create_autocmd("FileType", {
    group = ftgroup,
    pattern = {
        "javascriptreact",
        "svelte",
        "javascript",
        "vue",
        "html",
        "css",
        "yaml",
        "dart",
        "typescript",
        "json",
    },
    callback = function()
        vim.opt_local.tabstop = 2
        vim.opt_local.shiftwidth = 2
        vim.opt_local.softtabstop = 0
        vim.opt_local.expandtab = true
    end,
})
api.nvim_create_autocmd("FileType", {
    group = ftgroup,
    pattern = "text",
    callback = function()
        vim.opt_local.cindent = false
    end,
})
api.nvim_create_autocmd("FileType", {
    group = ftgroup,
    pattern = { "c", "cpp" },
    callback = function()
        -- C, C++ switch case indent, see: https://stackoverflow.com/questions/3444696/how-to-disable-vims-indentation-of-switch-case
        vim.opt_local.cinoptions = "l1"
    end,
})
api.nvim_create_autocmd("FileType", {
    group = ftgroup,
    pattern = "javascript",
    callback = function()
        vim.bo.filetype = "javascriptreact"
    end,
})
api.nvim_create_autocmd({ "BufNewFile", "BufRead" }, {
    group = ftgroup,
    pattern = "*.json5",
    callback = function()
        vim.bo.filetype = "json5"
    end,
})
