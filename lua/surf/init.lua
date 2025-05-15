local config = require("surf.config")
local utils = require("surf.utils")
local search = require("surf.search")

local M = {}

---@param opts table?
M.setup = function(opts)
	local found, _ = pcall(require, "telescope")
	assert(found, "Assertion Error: Telescope not found.")

	config.set(opts)

	local ok, history = utils.load_text_file(utils.search_history_path)
	if not ok then
		utils.write_text_file(utils.search_history_path, {})
	end
	search.search_history = history

	local calc_ok, calc_history = utils.load_text_file(utils.calculator_history_path)
	if not calc_ok then
		utils.write_text_file(utils.calculator_history_path, {})
	end
	search.calculator_history = calc_history

	if config.opts.keymaps.search then
		vim.keymap.set("n", config.opts.keymaps.search, require("surf.search").surf_toggle)
	end

	vim.api.nvim_create_user_command("Surf", require("surf.search").surf_toggle, {})
	vim.api.nvim_create_user_command("SurfClear", function() search.search_history = {} end, {})
	vim.api.nvim_create_user_command("SurfClearCalc", function() search.calculator_history = {} end, {})

	vim.api.nvim_create_autocmd("VimLeavePre", {
		callback = function()
			utils.write_text_file(utils.search_history_path, search.search_history, config.opts.history_limit)
			utils.write_text_file(utils.calculator_history_path, search.calculator_history, config.opts.history_limit)
		end
	})
end

return M
