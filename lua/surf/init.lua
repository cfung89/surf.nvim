local config = require("surf.config")
local utils = require("surf.utils")
local search = require("surf.search")

local M = {}

---@param opts table | nil
M.setup = function(opts)
	local found, _ = pcall(require, "telescope")
	assert(found, "Assertion Error: Telescope not found.")

	config.set(opts)

	local ok, history = utils.load_text_file(utils.search_history_path)
	if not ok then
		utils.clear_search_history(utils.search_history_path)
	end
	search.search_history = history

	if config.opts.keymaps.search then
		vim.keymap.set("n", config.opts.keymaps.search, require("surf.search").surf_toggle)
	end

	vim.api.nvim_create_user_command("Surf", require("surf.search").surf_toggle, {})
	vim.api.nvim_create_user_command("SurfClear", function() search.search_history = {} end, {})

	vim.api.nvim_create_autocmd("VimLeavePre", {
		callback = function()
			utils.write_text_file(utils.search_history_path, search.search_history, config.opts.search_history_limit)
		end
	})
end

return M
