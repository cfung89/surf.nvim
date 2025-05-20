local actions = require("telescope.actions")

local calculator = require("surf.calculator.calculator")
local config = require("surf.config")
local ui = require("surf.ui")
local utils = require("surf.utils")

local M = {}

M.search_history = {}
M.calculator_history = {}

M.surf_on = false

---@param opts table? --opts for custom picker
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
	ui.custom_picker(opts, M.search_history, M.browse, M.calculator_history, M.calculate)
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
---@return string?
M.calculate = function(prompt)
	local tokens = calculator.parse_equation(prompt)
	if not tokens then return end
	local equation = "= " .. table.concat(tokens, " ")
	if equation ~= "" and not utils.array_contains(M.calculator_history, equation) then
		table.insert(M.calculator_history, 1, equation)
	end
	return calculator.postfix_eval(calculator.infix_to_postfix(tokens))
end

---@param prompt string
---@return string
---@return string
M.parse_bang = function(prompt)
	local t = utils.split_string(prompt, " ")
	if t[1]:sub(1, 1) ~= "!" then
		return config.get_default_search_link(), prompt
	end
	local url = config.bangs[t[1]]
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
