---@diagnostic disable:undefined-global
-- totally not taken from /bin/pastebin.lua
-- Encodes an URL to be used in a string. (like " " -> "%20")
---@param code string URL to be encoded
---@return string
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
---@param code string The URL to be decoded
---@return string
function t.url.decode(code)
	if code then
		code = string.gsub(code, "(%%[A-Fa-f0-9][A-Fa-f0-9])", function(c)
			return string.char(tonumber(string.sub(c, 2), 16))
		end)
		code = string.gsub(code, "+", " ")
	end
	return code
end