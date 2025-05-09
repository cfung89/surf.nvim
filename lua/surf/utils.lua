local M = {}

M.data_path = vim.fn.stdpath("data") .. "/surf"
M.search_history_path = M.data_path .. "/search_history.txt"

vim.fn.mkdir(M.data_path, "p")

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
		local line = l:match("^%s*(.-)%s*$")
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
---@return boolean
M.clear_search_history = function(path)
	local f = io.open(path, "w")
	if not f then return false end
	f:close()
	return true
end

---@param path string
---@param data string[]
---@return boolean
M.write_text_file = function(path, data)
	local f = io.open(path, "w")
	if not f then return false end
	for i = #data, 1, -1 do
		f:write(data[i] .. "\n")
	end
	f:close()
	return true
end

---@param path string
---@param data string
---@return boolean
M.append_text_file = function(path, data)
	local f = io.open(path, "a")
	if not f then return false end
	local nl = data .. "\n"
	f:write(nl)
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

---@param arr table
---@return table
M.reverse_array = function(arr)
	for i = 1, math.floor(#arr / 2) do
		arr[i], arr[#arr - i + 1] = arr[#arr - i + 1], arr[i]
	end
	return arr
end

return M
