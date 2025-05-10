local config = require("surf.config")
local utils = require("surf.utils")
local search = require("surf.search")

local M = {}

---@param opts table | nil
M.setup = function(opts)
	config.set(opts)

	local ok, history = utils.load_text_file(utils.search_history_path)
	if not ok then
		utils.clear_search_history(utils.search_history_path)
	end
	search.search_history = history

	if config.opts.keymaps.search then
		vim.keymap.set("n", config.opts.keymaps.search, require("surf.search").surf_search)
	end

	if config.opts.commands.search then
		vim.api.nvim_create_user_command(config.opts.commands.search, require("surf.search").surf_search, {})
	end

	if config.opts.commands.clear_history then
		vim.api.nvim_create_user_command(config.opts.commands.clear_history,
			function() search.search_history = {} end, {})
	end

	vim.api.nvim_create_autocmd("VimLeavePre", {
		callback = function()
			utils.write_text_file(utils.search_history_path, search.search_history)
		end
	})
end

return M
