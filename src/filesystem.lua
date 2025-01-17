---@diagnostic disable:undefined-global
local filesystem = require("filesystem")
-- Creates an iterator going over the chunks of a file, also has a block argument in the iterator
-- specifying how many blocks the file has.
function t.filesystem.chunk_iterate(self, path)
	local h = io.open(path, "r")
	local size = filesystem.size(path)
	local blocks = math.ceil(size / self.blockSize)
	-- local i = 0
	return function ()
		return h:read(self.blockSize), blocks
	end
end
-- Reads an entire file into RAM.
-- Returns an string.
function t.filesystem.readfile(self, path)
	local payload = ""
	for chunk in self:chunk_iterate(path)
	do
		payload = payload .. chunk
	end
	return payload
end
-- Copy a file from `originPath` to `destPath` (destination path).
function t.filesystem.cp(self, originPath, destPath)
	local sh = io.open(originPath, "r")
	local dh = io.open(destPath, "w")
	local size = filesystem.size(sh)
	local blocks = math.ceil(size / self.blockSize)
	for i = 1, blocks, 1
	do
		local chunk = sh:read(self.blockSize)
		dh:write(chunk)
	end
	sh:close()
	dh:close()
	return true
end