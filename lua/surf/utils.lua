local M = {}

M.data_path = vim.fn.stdpath("data") .. "/surf"
M.search_history_path = M.data_path .. "/search_history.txt"

vim.fn.mkdir(M.data_path, "p")

M.unpack = unpack or table.unpack

---@param path string
---@return boolean
M.file_exists = function(path)
	local f = io.open(path, "r")
	if f then f:close() end
	return f ~= nil
end

---@param path string
---@return boolean, table
M.load_text_file = function(path)
	if not M.file_exists(path) then return false, {} end
	local lines = {}
	for l in io.lines(path) do
		local line = vim.fn.trim(l)
		table.insert(lines, 1, line)
	end
	return true, lines
end

---@param path string
---@return boolean, any
M.load_json_file = function(path)
	local f = io.open(path, "r")
	if not f then return false, {} end
	local data = f:read("*a")
	f:close()
	return true, vim.fn.json_decode(data)
end

---@param path string
---@param data string[]
---@param limit integer | nil
---@return boolean
M.write_text_file = function(path, data, limit)
	local f = io.open(path, "w")
	if not f then return false end
	local len = #data
	if limit ~= nil and limit < len then len = limit end
	for i = len, 1, -1 do
		f:write(data[i] .. "\n")
	end
	f:close()
	return true
end

---@param path string
---@param data table
---@return boolean
M.write_json_file = function(path, data)
	local f = io.open(path, "w")
	if not f then return false end
	f:write(vim.fn.json_encode(data))
	f:close()
	return true
end

---@param array string[]
---@param value string
---@return boolean
M.array_contains = function(array, value)
	for _, n in ipairs(array) do
		if n == value then
			return true
		end
	end
	return false
end

M.string_split = function(str, sep)
	if sep == nil then
		sep = "%s"
	end
	local t = {}
	for s in string.gmatch(str, "([^" .. sep .. "]+)") do
		table.insert(t, s)
	end
	return t
end

---Copyright (c) 2022 Lalit Kumar
---Source: https://github.com/lalitmee/browse.nvim/tree/main
---License: MIT (see LICENSE file)
---@return string
M.get_os_name = function()
	if string.find(vim.fn.systemlist("uname -r")[1] or "", "WSL") ~= nil then
		return "WSL"
	else
		return vim.loop.os_uname().sysname
	end
end

return M
