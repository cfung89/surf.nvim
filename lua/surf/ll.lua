-- Implementation of a doubly linked list

---@class Node
---@field value any
---@field prev Node?
---@field next Node?

---@class LinkedList
---@field head Node?
---@field tail Node?
---@field size integer
local LinkedList = {}
LinkedList.__index = LinkedList

function LinkedList.new()
	return setmetatable({ head = nil, tail = nil, size = 0 }, LinkedList)
end

---Add element to the beginning of the linked list.
---@param value any
function LinkedList:prepend(value)
	local node = { value = value, prev = nil, next = self.head }
	if not self.head then
		self.head = node
		self.tail = node
	else
		self.head.prev = node
		self.head = node
	end
	self.size = self.size + 1
end

---Pops last element of doubly linked list.
---@return any
function LinkedList:pop()
	if not self.tail then return nil end
	local val = self.tail.value

	if self.tail.prev then
		self.tail.prev = self.tail
		self.tail.next = nil
	else
		self.head = nil
		self.tail = nil
	end
	self.size = self.size - 1
	return val
end

function LinkedList:print()
	local current = self.head
	while current do
		vim.print(current.value)
		current = current.next
	end
end

---@return any[]
function LinkedList:to_array()
	local array = {}
	local current = self.head
	while current do
		table.insert(array, current.value)
		current = current.next
	end
	return array
end

return LinkedList
