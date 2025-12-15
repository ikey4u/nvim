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
			"ryanoasis/vim-devicons",
			event = "VimEnter",
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
		{ import = "plugins" },
	},
})
