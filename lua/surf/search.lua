local config = require("surf.config")
local ui = require("surf.ui")

local M = {}

M.search_history = {}

---@param opts table | nil --opts for custom picker
M.surf_search = function(opts)
	opts = opts or {}

	ui.custom_picker(opts, M.search_history, M.browse)
end

---@param prompt string
M.browse = function(prompt)
	local p = prompt:match("^%s*(.-)%s*$")
	if p ~= "" then
		table.insert(M.search_history, 1, p)
	end
	local query = p:gsub(" ", "+")
	vim.ui.open(string.format(config.get_default_search_link(), query))
end

return M
