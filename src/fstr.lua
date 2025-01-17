---@diagnostic disable:undefined-global
local fstrTable = {}
-- Set arguments for the format string
function t.fset(...)
	fstrTable = table.pack(...)
end
-- bstd format strings  
-- Example:
-- ```lua
-- fset("user", "duck")
-- print(f"Hello {1}, you have a {2}") -- Prints "Hello user, you have a duck"
-- ```
---@param str string The string to be formatted
---@return string
function t.f(str)
	local out = "" -- in case you want to use this instead of string.format for whatever reason
	local pos = 1
	repeat
		local dStart, dEnd = string.find(str, "{%d+}", pos)
		if dStart == nil then break end
		local indexStr = string.sub(str, dStart+1, dEnd-1)
		local index = tonumber(indexStr)
		-- print(indexStr)
		if index == nil or index < 1 then error('Invalid format string index at ' .. dStart) end
		out = out .. string.sub(str, pos, dStart - 1) .. fstrTable[index]
		pos = dEnd+1
	until pos >= #str
	out = out .. string.sub(str, pos, #str)
	return out
end
