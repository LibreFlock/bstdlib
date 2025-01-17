---@diagnostic disable:undefined-global
-- Split a string, using Lua patterns
---@param str string The string to split
---@param sp string Separator
---@return fun(): string iterator Iterator
function t.string.isplit(str, sp)
	if sp == nil then
		sp = "%s"
	end
	local mstr = "\0" .. str .. "\0" -- TODO: make sure a space gets added if the input *starts or ends* with the separator
	return string.gmatch(str, "([^" .. sp .. "]+)")
end
-- Safe version of string.isplit, doesn't use Lua patterns.
-- Use this if you can't trust the `sp` argument (if you are passing user input to it or something).
-- Arguments are the same as isplit, but behaves slightly differently (seems to behave the same as JS's .split())
---@param _str string The string to be split
---@param delim string Separator/delimiter
---@return fun(): string? iterator Iterator
function t.string.isplit_s(_str, delim)
	local currentPos = 1
	local str = _str .. delim -- replicate JS behavior
	return function ()
		-- if currentPos >= #str then return nil end
		local delimStart, delimEnd = string.find(str, delim, currentPos, true)
		-- print(currentPos, delimStart, delimEnd, #str)
		if delimStart == nil or delimEnd == nil then
			if currentPos <= #str then
				local tmp = string.sub(str, currentPos, #str)
				currentPos = currentPos + #delim
				return tmp
			else
				return nil
			end
		end
		local segment = string.sub(str, currentPos, delimStart-1)
		currentPos = delimEnd+1
		return segment
	end
end

-- Non-iterator version of isplit. Returns a table array
---@param str string The string to be split
---@param sp string Separator
---@returns string[]
function t.string.split(str, sp)
	return t.table.from_iterator(t.string.isplit(str, sp))
end
-- Non-iterator version of isplit_s. Returns a table array
---@param str string The string to be split
---@param sp string Separator
---@returns string[]
function t.string.split_s(str, sp)
	return t.table.from_iterator(t.string.isplit_s(str, sp))
end

-- Checks if a string (`str`) starts with another (`s`)
---@param str string
---@param s string
---@return boolean
function t.string.starts_with(str, s)
	return string.sub(str, 1, #s) == s
end

-- Checks if a string (`str`) ends with another (`s`)
---@param str string
---@param s string
---@return boolean
function t.string.ends_with(str, s)
	return string.sub(str, #str-#s+1, #str) == s
end

-- Creates an iterator going over every character on a string.
---@param str string
---@return fun(): string? iterator
function t.string.chars(str)
	local i = 1
	return function()
		local res = string.sub(str, i, i)
		if res == "" or i > #str then return nil end
		i = i + 1
		return res
	end
end
