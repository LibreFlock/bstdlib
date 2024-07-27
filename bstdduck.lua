local t = {
	string = {},
	table = {},
	url = {},
	bytes = {}
}

-- Split a string, using Lua patterns
-- `str` is the string to split
-- `sp` is the separator
-- returns an iterator
function t.string.isplit(str, sp)
	if sp == nil then
		sp = "%s"
	end
	local mstr = "\0" .. str .. "\0" -- TODO: make sure a space gets added if the input *starts or ends* with the separator
	return string.gmatch(str, "([^" .. sp .. "]+)")
end
-- Safe version of string.isplit, doesn't use Lua patterns
-- Use this if you can't trust the `sp` argument (if you are passing user input to it or something)
-- Arguments are the same as isplit
function t.string.isplit_s(str, sp)
	local opos = 1
	local size = #sp
	local buf = ""
	return function()
		repeat
			local oend = opos + size
			local subs = string.sub(str, opos, oend)
			if subs == sp then
				local duck = buf
				buf = ""
				return duck
			else
				buf = buf .. subs
			end
		until opos + size >= #str
	end
end

-- Non-iterator version of isplit. Returns a table array
function t.string.split(str, sp)
	return t.table.from_iterator(t.string.isplit(str, sp))
end
-- Non-iterator version of isplit_s. Returns a table array
function t.string.split_s(str, sp)
	return t.table.from_iterator(t.string.isplit_s(str, sp))
end

-- Checks if a string (`str`) starts with another (`s`)
function t.string.starts_with(str, s)
	return string.sub(str, 1, #s) == s
end

-- Checks if a string (`str`) ends with another (`s`)
function t.string.ends_with(str, s)
	return string.sub(str, #str-#s+1, #str) == s
end

-- Creates an iterator going over every character on a string.
function t.string.chars(str)
	local i = 1
	return function()
		local res = string.sub(str, i, i)
		if res == "" or i > #str then return nil end
		i = i + 1
		return res
	end
end
-- Checks if a table has a specified key.
-- Returns a boolean.
function t.table.has_key(tab, key)
	for k, v in pairs(tab)
	do
		if k == key then return true end
	end
	return false
end
-- Checks if a table has a specific value. (`val`)
-- Returns a boolean
function t.table.has_value(tab, val)
	for value in t.table.itval(tab)
	do
		if value == val then return true end
	end
	return false
end
-- Creates a iterator going over the values of a table.
function t.table.itval(tab)
	local i = 1
	return function ()
		if i >= #tab then return nil end
		i = i + 1
		return tab[i - 1]
	end
end
-- Creates a table from an iterator (`it`).
-- Returns a table array.
function t.table.from_iterator(it)
	local tab = {}
	for value in it
	do
		table.insert(tab, value)
	end
	return tab
end

function t.table.at(tab, p)
	if p > 0 then
		return tab[p]
	else
		return tab[#tab - p]
	end
end
-- totally not taken from /bin/pastebin.lua
-- Encodes an URL to be used in a string. (like " " -> "%20")
function t.url.encode(code)
	if code then
		code = string.gsub(code, "([^%w ])", function(c)
			return string.format("%%%02X", string.byte(c))
		end)
		code = string.gsub(code, " ", "+")
	end
	return code
end
-- Decodes an URL. (like "%20" -> " ")
function t.url.decode(code)
	if code then
		code = string.gsub(code, "(%%[A-Fa-f0-9][A-Fa-f0-9])", function(c)
			return string.char(tonumber(string.sub(c, 2), 16))
		end)
		code = string.gsub(code, "+", " ")
	end
	return code
end
-- Creates an iterator going over the bytes of a string. Each iteration has a number argument.
function t.bytes.string(str)
	local it = t.string.chars(str)
	return function ()
		local ch = it()
		if ch == nil then return nil end
		return string.byte(ch)
	end
end

-- TODO: rewrite these as iterators and replace the originals with t.table.from_iterator stuff
-- Converts a hex string back into a normal string.
function t.bytes.from_hex(str)
	local out = ""
	for ch in t.string.chars(str)
	do
		out = out .. string.char(ch)
	end
	return out
end

-- Converts a string into a hex string.
function t.bytes.to_hex(str)
	local out = ""
	for ch in t.bytes.string(str)
	do
		out = out .. string.format("%x", ch)
	end
	return out
end

return t

