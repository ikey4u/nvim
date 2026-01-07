local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
    local lazyrepo = "https://github.com/folke/lazy.nvim.git"
    local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
    if vim.v.shell_error ~= 0 then
        vim.api.nvim_echo({
            { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
            { out, "WarningMsg" },
            { "\nPress any key to exit..." },
        }, true, {})
        vim.fn.getchar()
        os.exit(1)
    end
end
vim.opt.rtp:prepend(lazypath)

-- These options are required by lazy.nvim
vim.g.mapleader = "\\"
vim.g.maplocalleader = "\\"

require("lazy").setup({
    change_detection = {
        enabled = false,
        notify = false,
    },
    spec = {
        {
            "preservim/nerdcommenter",
            config = function()
                vim.g.NERDSpaceDelims = 1
            end,
        },
        {
            "mattn/emmet-vim",
            ft = { "html", "css", "javascript", "typescript", "vue", "svelte" },
        },
        {
            "majutsushi/tagbar",
            cmd = "TagbarToggle",
        },
        {
            "mhinz/vim-startify",
            config = function()
                vim.g.startify_files_number = 20
            end,
        },
        {
            "nvim-tree/nvim-web-devicons",
            opts = {},
        },
        {
            "nvim-tree/nvim-tree.lua",
            after = "nvim-web-devicons",
            dependencies = {
                "nvim-tree/nvim-web-devicons",
            },
            config = function()
                vim.g.loaded_netrw = 1
                vim.g.loaded_netrwPlugin = 1
                vim.opt.termguicolors = true
                vim.keymap.set("n", "<leader>r", function()
                    vim.cmd("NvimTreeFindFile!")
                end, { noremap = true, silent = true })

                local function on_attach(bufnr)
                    local api = require("nvim-tree.api")
                    api.config.mappings.default_on_attach(bufnr)

                    local function opts(desc)
                        return {
                            desc = "nvim-tree: " .. desc,
                            buffer = bufnr,
                            noremap = true,
                            silent = true,
                            nowait = true,
                        }
                    end
                    vim.keymap.set("n", "u", api.tree.change_root_to_parent, opts("Up"))
                    vim.keymap.set("n", "?", api.tree.toggle_help, opts("Help"))
                    vim.keymap.set("n", "i", api.node.open.horizontal, opts("Open split"))
                    vim.keymap.set("n", "s", api.node.open.vertical, opts("Open vsplit"))
                    vim.keymap.set("n", "C", api.tree.change_root_to_node, opts("Change root"))
                end
                require("nvim-tree").setup({
                    on_attach = on_attach,
                    sort = {
                        sorter = "case_sensitive",
                    },
                    view = {
                        width = 30,
                    },
                    git = {
                        enable = false,
                    },
                    filters = {
                        dotfiles = true,
                        custom = {
                            "^.git$",
                            "node_modules",
                            "target",
                            "dist",
                            ".build",
                            ".cache",
                            "*.egg-info",
                            "*.lock",
                            "*.pyc",
                            "*.o",
                            "*.obj",
                            "*.svn",
                            "*.swp",
                            "*.class",
                            "*.hg",
                            "*.DS_Store",
                            "*.min.*",
                            "*__pycache__*",
                            "*.db",
                            "*.xcodeproj",
                        },
                    },
                    filesystem_watchers = {
                        enable = false,
                    },
                })
            end,
        },
        {
            "jiangmiao/auto-pairs",
            lazy = false,
            event = "InsertEnter",
        },
        {
            "ojroques/vim-oscyank",
            config = function()
                vim.g.oscyank_max_length = 1000000
                vim.g.oscyank_term = "default"
                vim.g.oscyank_silent = true
                vim.api.nvim_create_autocmd("TextYankPost", {
                    callback = function(event)
                        if event.operator == "y" and event.regname == "" then
                            vim.cmd('OSCYankRegister "')
                        end
                    end,
                })
            end,
        },
        { import = "plugins/specs" },
    },
})
