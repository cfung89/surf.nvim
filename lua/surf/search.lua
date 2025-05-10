local config = require("surf.config")
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
	prompt = vim.fn.trim(prompt)
	if prompt ~= "" and not utils.array_contains(M.search_history, prompt) then
		table.insert(M.search_history, 1, prompt)
	end
	local query = prompt:gsub(" ", "+")

	M.open_url(string.format(M.parse_bang(), query))
end

M.parse_bang = function()
	return config.get_default_search_link()
end

---@param url string
M.open_url = function(url)
	local os = config.os
	if os == "Windows_NT" or os == "Windows" or os == "WSL" then
		vim.fn.jobstart({ "cmd.exe", "/c", "start", url }, { detach = true })
	else
		vim.ui.open(url)
	end
end

return M
