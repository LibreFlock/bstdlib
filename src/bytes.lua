---@diagnostic disable:undefined-global
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
	local last = ""
	for ch in t.string.chars(str)
	do
		if last == "" then
			last = ch
			goto cont
		end
		local hxb = last .. ch

		out = out .. string.char(tonumber(hxb, 16))
		last = ""
		::cont::
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