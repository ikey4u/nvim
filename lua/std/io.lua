local M = {}

function M.echo(msg, hl)
	vim.api.nvim_echo({ { msg, hl or "WarningMsg" } }, true, {})
end

return M
