local api = vim.api

-- :Note
api.nvim_create_user_command("Note", function()
    vim.cmd("sp ~/.vimnotes.txt")
end, {})

local gitTree = {
    active = false,
    previous = nil,
}

local function gitTreeCwd()
    local name = api.nvim_buf_get_name(0)
    if name ~= "" then
        local dir = vim.fn.fnamemodify(name, ":p:h")
        if vim.fn.isdirectory(dir) == 1 then
            return dir
        end
    end
    return vim.fn.getcwd()
end

local function gitTreeRoot()
    local result = vim.system({ "git", "rev-parse", "--show-toplevel" }, {
        cwd = gitTreeCwd(),
        text = true,
    }):wait()
    if result.code ~= 0 then
        vim.notify("GitTree: not in a git repository", vim.log.levels.WARN)
        return nil
    end
    return vim.trim(result.stdout or "")
end

local function gitTreeHasChanges(root)
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

local function gitTreeCore()
    local ok, core = pcall(require, "nvim-tree.core")
    if ok then
        return core
    end
    return nil
end

local function gitTreeSetFilter(name, enabled)
    local core = gitTreeCore()
    if not core then
        return
    end
    local explorer = core.get_explorer()
    if not explorer or not explorer.filters or explorer.filters.state[name] == enabled then
        return
    end

    local treeApi = require("nvim-tree.api")
    local toggles = {
        git_clean = treeApi.tree.toggle_git_clean_filter,
        dotfiles = treeApi.tree.toggle_hidden_filter,
    }
    if toggles[name] then
        toggles[name]()
    end
end

local function gitTreeSaveState()
    local core = gitTreeCore()
    local explorer = core and core.get_explorer()
    local filters = explorer and explorer.filters and explorer.filters.state or {}
    gitTree.previous = {
        root = core and core.get_cwd() or nil,
        git_clean = filters.git_clean,
        dotfiles = filters.dotfiles,
    }
end

local function gitTreeDisable(treeApi)
    if gitTree.previous and gitTree.previous.root then
        treeApi.tree.open({ path = gitTree.previous.root, focus = true })
        treeApi.tree.change_root(gitTree.previous.root)
    else
        treeApi.tree.open({ focus = true })
    end

    local gitClean = false
    local dotfiles = true
    if gitTree.previous then
        if gitTree.previous.git_clean ~= nil then
            gitClean = gitTree.previous.git_clean
        end
        if gitTree.previous.dotfiles ~= nil then
            dotfiles = gitTree.previous.dotfiles
        end
    end

    gitTreeSetFilter("git_clean", gitClean)
    gitTreeSetFilter("dotfiles", dotfiles)
    treeApi.tree.reload()
    gitTree.active = false
    gitTree.previous = nil
end

local function gitTreeShow()
    local ok, treeApi = pcall(require, "nvim-tree.api")
    if not ok then
        vim.notify("GitTree: nvim-tree is not available", vim.log.levels.ERROR)
        return
    end

    if gitTree.active then
        gitTreeDisable(treeApi)
        return
    end

    local root = gitTreeRoot()
    if not root then
        return
    end

    local hasChanges = gitTreeHasChanges(root)
    if hasChanges == nil then
        return
    end

    if not hasChanges then
        treeApi.tree.close()
        vim.notify("GitTree: no changed files")
        return
    end

    gitTreeSaveState()
    treeApi.tree.open({ path = root, focus = true })
    treeApi.tree.change_root(root)
    gitTreeSetFilter("git_clean", true)
    gitTreeSetFilter("dotfiles", false)
    treeApi.tree.reload()
    treeApi.tree.expand_all()
    gitTree.active = true
end

api.nvim_create_user_command("GitTree", gitTreeShow, {})

local function gitHelpShow()
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

api.nvim_create_user_command("GitHelp", gitHelpShow, {})

local colorSchemeGroup = api.nvim_create_augroup("extrahighlight", { clear = true })
api.nvim_create_autocmd("ColorScheme", {
    group = colorSchemeGroup,
    command = "highlight colorcolumn ctermbg=238",
})

vim.g.format_on_save = false

local formatOnSaveGroup = api.nvim_create_augroup("LspFormatOnSave", { clear = true })
api.nvim_create_autocmd("BufWritePre", {
    group = formatOnSaveGroup,
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
