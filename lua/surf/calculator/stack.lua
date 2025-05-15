---@class Stack
---@field array any[]
local Stack = {}
Stack.__index = Stack

---@return Stack
function Stack:new()
	local obj = { array = {} }
	setmetatable(obj, self)
	return obj
end

---@param value any
function Stack:push(value)
	table.insert(self.array, value)
end

---@return any
function Stack:pop()
	return table.remove(self.array)
end

---@return any
function Stack:peek()
	return self.array[#self.array]
end

---@return boolean
function Stack:is_empty()
	return #self.array == 0
end

return Stack
