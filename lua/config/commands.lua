local api = vim.api

api.nvim_create_user_command("Note", function()
    vim.cmd("sp ~/.vimnotes.txt")
end, {})
