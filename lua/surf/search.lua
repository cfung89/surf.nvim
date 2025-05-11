local actions = require("telescope.actions")

local config = require("surf.config")
local ui = require("surf.ui")
local utils = require("surf.utils")

local M = {}

M.search_history = {}

M.surf_on = false

---@param opts table | nil --opts for custom picker
M.surf_toggle = function(opts)
	opts = opts or {}
	if M.surf_on then
		local ok = pcall(actions.close, ui.last_prompt_bufnr)
		if ok then
			M.surf_on = false
			ui.last_prompt_bufnr = -1
			return
		end
	end
	M.surf_on = true
	ui.custom_picker(opts, M.search_history, M.browse)
end

---@param prompt string
M.browse = function(prompt)
	prompt = vim.fn.trim(prompt)
	if prompt ~= "" and not utils.array_contains(M.search_history, prompt) then
		table.insert(M.search_history, 1, prompt)
	end
	local url, q = M.parse_bang(prompt)
	local query = q:gsub(" ", "+")

	M.open_url(string.format(url, query))
end

---@param prompt string
---@return string
---@return string
M.parse_bang = function(prompt)
	local t = utils.string_split(prompt, " ")
	if t[1]:sub(1, 1) ~= "!" then
		return config.get_default_search_link(), prompt
	end
	local url = config.bangs[t[1]:sub(2)]
	if not url then
		return config.get_default_search_link(), prompt
	end
	local new_prompt = ""
	for i = 2, #t do
		new_prompt = new_prompt .. t[i]
	end
	return url, new_prompt
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
