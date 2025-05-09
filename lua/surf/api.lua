local ui = require("surf.ui")
local utils = require("surf.utils")

local M = {}

M.search_history = {}

---@param opts table | nil
M.surf_search = function(opts)
	opts = opts or {}
	local ok, history = utils.load_text_file(utils.search_history_path)
	if not ok then
		utils.clear_search_history(utils.search_history_path)
	end
	M.search_history = history
	vim.print(M.search_history)
	utils.reverse_array(history)

	ui.custom_picker(opts, history, M.browse)
end

---@param prompt string
M.browse = function(prompt)
	local query = prompt:gsub(" ", "+")
	vim.ui.open(string.format("https://search.brave.com/search?q=%s&source=desktop", query))
end

local on_exit = function()
	utils.write_text_file(utils.search_history_path, M.search_history)
end

vim.api.nvim_create_autocmd("VimLeavePre", {
	callback = on_exit
})

return M
