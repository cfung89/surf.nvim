local Stack = require("surf.calculator.stack")

local M = {}

local precedence = {
	["^"] = 4,
	["*"] = 3,
	["/"] = 3,
	["+"] = 2,
	["-"] = 2,
	["("] = 1,
}

---@param equation string
---@return string[]?
M.parse_equation = function(equation)
	local trimmed = equation:match("^=*(.*)")
	trimmed = vim.fn.trim(trimmed)
	local out = {}
	local num = ""
	for s in string.gmatch(trimmed, ".") do
		if s == " " then
			goto continue
		elseif s:match("^[%d%.]$") then
			if s == "." and num == "" then
				num = num .. "0"
			end
			num = num .. s
		elseif s:match("^[%+%-%*/%^%(%)]$") then
			if num ~= "" then table.insert(out, num) end
			table.insert(out, s)
			num = ""
		else
			return nil
		end
		::continue::
	end
	if num ~= "" then table.insert(out, num) end
	return out
end

---@param a number?
---@param b number?
---@param op string?
---@return number?
M.do_math = function(a, b, op)
	if not a or not b then return end
	if op == "+" then
		return a + b
	elseif op == "-" then
		return a - b
	elseif op == "*" then
		return a * b
	elseif op == "/" then
		return a / b
	elseif op == "^" then
		return math.pow(a, b)
	else
		-- invalid operator
		return nil
	end
end

---@param tokens string[]
---@return string[]?
M.infix_to_postfix = function(tokens)
	local operator_stack = Stack:new()
	local output = {}

	for _, n in ipairs(tokens) do
		if string.match(n, "^%d+%.?%d*$") ~= nil then
			table.insert(output, n)
		elseif n == "(" then
			operator_stack:push(n)
		elseif n == ")" then
			local top = operator_stack:pop()
			while top ~= "(" do
				table.insert(output, top)
				top = operator_stack:pop()
			end
		else
			if not precedence[n] then return nil end
			while (not operator_stack:is_empty()) and (precedence[operator_stack:peek()] >= precedence[n]) do
				table.insert(output, operator_stack:pop())
			end
			operator_stack:push(n)
		end
	end
	while not operator_stack:is_empty() do
		table.insert(output, operator_stack:pop())
	end
	return output
end

---@param postfix string[]?
---@return number?
M.postfix_eval = function(postfix)
	if not postfix then return end
	local operand_stack = Stack:new()
	for _, n in ipairs(postfix) do
		local num = tonumber(n)
		if num then
			operand_stack:push(tonumber(n))
		else
			local b = operand_stack:pop()
			local a = operand_stack:pop()
			local result = M.do_math(a, b, n)
			if not result then return end
			operand_stack:push(result)
		end
	end
	return operand_stack:pop()
end

return M
