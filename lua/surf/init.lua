local config = require("surf.config")

local M = {}

M.setup = function(opts)
	config.set(opts)

	vim.api.nvim_create_user_command(config.defaults.cmd, require("surf.api").surf_search, {})
	vim.keymap.set("n", "<leader>o", require("surf.api").surf_search)
end

M.clear_search_history = function()
	local utils = require("surf.utils")
	utils.clear_search_history(utils.search_history_path)
end

return M
