local t = {
--!ifndef NO_STRING
	string = {},
--!end
--!ifndef NO_TABLE
	table = {},
--!end
--!ifndef NO_FILESYSTEM
	filesystem = {
		blockSize = 4096
	},
--!end
--!ifndef NO_URL
	url = {},
--!end
--!ifndef NO_BYTES
	bytes = {},
--!end
--!ifndef NO_VEC2
	vec2 = {},
--!end
--!ifndef NO_VEC3
	vec3 = {},
--!end
--!ifndef NO_SWITCH
	switch = {}
--!end
}

--!ifndef NO_STRING
--%include("./src/string.lua")
--!end
--!ifndef NO_TABLE
--%include("./src/table.lua")
--!end
--!ifndef NO_FILESYSTEM
--%include("./src/filesystem.lua")
--!end
--!ifndef NO_URL
--%include("./src/url.lua")
--!end
--!ifdef INCL_FSTR
--%include("./src/fstr.lua")
--!end
--!ifndef NO_BYTES
--%include("./src/bytes.lua")
--!end

--!ifndef NO_VEC2
--%include("./src/vec2.lua")
--!end

--!ifndef NO_VEC3
--%include("./src/vec3.lua")
--!end

--!ifndef NO_ENUM
function t.enum(tab)
	local retv = {}

	for k, v in pairs(tab)
	do
		retv[k] = v
		retv[v] = k
	end

	return retv
end
--!end

--!ifndef NO_SWITCH
--%include("./src/switch.lua")
--!end

--!ifndef NO_NOOP
function t.noop() end -- does literally nothing
--!end

--!ifndef NO_RET
return t
--!end
