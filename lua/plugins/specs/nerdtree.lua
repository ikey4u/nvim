return {
    "preservim/nerdtree",
    config = function()
        vim.keymap.set("n", "<leader>r", function()
            vim.cmd("NERDTreeFind")
          end, { noremap = true, silent = true }
        )

        vim.opt.wildignore:append({
          "*.pyc", "*.o", "*.obj", "*.svn", "*.swp", "*.class",
          "*.hg", "*.DS_Store", "*.min.*", "*__pycache__*", "*.db", "*.xcodeproj"
        })
        vim.g.NERDTreeRespectWildIgnore = 1
    end
}
