local map = vim.keymap.set
local opts = { noremap = true, silent = true }

map("n", "<leader>ev", "<cmd>vsplit $MYVIMRC<CR>", opts)
map("n", "<leader>sv", "<cmd>source $MYVIMRC<CR>", opts)

map("n", "<space>j", "<cmd>tabnext<CR>", opts)
map("n", "<space>k", "<cmd>tabprevious<CR>", opts)

map("i", "jk", "<Esc>", { noremap = true })

map("n", "<leader>P", function()
    vim.fn.setreg("+", vim.fn.expand("%:p"))
end, opts)


map("n", "<C-h>", "<cmd>vertical resize +3<CR>", opts)
map("n", "<C-l>", "<cmd>vertical resize -3<CR>", opts)
map("n", "<C-j>", "<cmd>resize +3<CR>", opts)
map("n", "<C-k>", "<cmd>resize -3<CR>", opts)

map("n", "Cs", "<cmd>%s/\\s\\+$//ge<CR>", opts)
map("n", "Cm", "<cmd>%s/\r$//ge<CR><cmd>set fileformat=unix<CR>", opts)
