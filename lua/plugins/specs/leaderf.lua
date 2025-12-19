return {
    "Yggdroot/LeaderF",
    tag = "v1.24",
    config = function()
        vim.g.Lf_ShortcutF = ""

        vim.g.Lf_UseCache = 0
        vim.g.Lf_UseVersionControlTool = 0
        vim.g.Lf_RecurseSubmodules = 1
        vim.g.Lf_ShowHidden = 1

        vim.g.Lf_RootMarkers = { ".vimroot", ".git" }
        vim.g.Lf_WorkingDirectoryMode = "Ac"

        vim.g.Lf_WildIgnore = {
            dir = { ".svn", ".git", ".hg", ".cache" },
            file = { "*.sw?", "~$*", "*.bak", "*.exe", "*.o", "*.so", "*.py[co]" },
        }

        if vim.fn.executable("exctags") == 1 then
            vim.g.Lf_Ctags = "exctags"
        end

        if vim.fn.executable("rg") == 1 then
            vim.g.Lf_DefaultExternalTool = "rg"
            vim.cmd([[
                command! Lfn   :LeaderfFunction
                command! Lcs   :LeaderfColorscheme
                command! Lmru  :LeaderfMru
                command! Lf    :Leaderf file --no-auto-preview
                command! Lff   :Leaderf file --no-auto-preview --case-insensitive
                command! Lfff  :Leaderf file --no-auto-preview --case-insensitive --no-ignore
                command! -nargs=+ -complete=command Lr   :Leaderf rg -M 1000 -e <q-args>
                command! -nargs=+ -complete=command Lrr  :Leaderf rg --ignore-case -M 1000 -e <q-args>
                command! -nargs=+ -complete=command Lrrr :Leaderf rg --ignore-case --no-ignore -M 1000 -e <q-args>
                command! -nargs=+ -complete=command Lw   :Leaderf rg -M 1000 <q-args>
                command! -nargs=+ -complete=command Lww  :Leaderf rg --ignore-case -M 1000 <q-args>
                command! -nargs=+ -complete=command Lwww :Leaderf rg --ignore-case --no-ignore -M 1000 <q-args>
            ]])

            vim.keymap.set("n", "<leader>Fb", function()
                vim.cmd([[Leaderf buffer ""]])
            end, { noremap = true, silent = true })

            vim.keymap.set("n", "<leader>w", function()
                local word = vim.fn.expand("<cword>")
                vim.cmd(string.format("Leaderf rg --ignore-case -M 1000 -e %s", word))
            end, { noremap = true, silent = true })

            vim.keymap.set("n", "<leader>fw", function()
                local word = vim.fn.expand("<cword>")
                vim.cmd(string.format("Leaderf rg --hidden --ignore-case --no-ignore -M 1000 -e %s", word))
            end, { noremap = true, silent = true })
        end
    end,
}
