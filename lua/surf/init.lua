local config = require("surf.config")

local M = {}

M.setup = function(opts)
	config.set(opts)

	vim.api.nvim_create_user_command(config.defaults.cmd, require("surf.ui").toggle_window, {})
end

return M
