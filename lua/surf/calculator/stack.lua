---@class Stack
---@field items any[]
local Stack = {}
Stack.__index = Stack

---@return Stack
function Stack:new()
	local obj = { items = {} }
	setmetatable(obj, self)
	return obj
end

---@param value any
function Stack:push(value)
	table.insert(self.items, value)
end

---@return any
function Stack:pop()
	return table.remove(self.items)
end
