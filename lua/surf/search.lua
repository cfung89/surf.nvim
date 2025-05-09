local ui = require("surf.ui")
local utils = require("surf.utils")

local M = {}

M.search_history = {}

---@param opts table | nil --opts for custom picker
M.surf_search = function(opts)
	opts = opts or {}

	ui.custom_picker(opts, M.search_history, M.browse)
end

---@param prompt string
M.browse = function(prompt)
	table.insert(M.search_history, 1, prompt)
	local query = prompt:gsub(" ", "+")
	vim.ui.open(string.format("https://search.brave.com/search?q=%s&source=desktop", query))
end

return M
