--%if not defined("TARGET") then
--%  define("TARGET", "standalone")
--%end
--%local enabled = {}
--%local function enable(text)
--%  if defined("NO_" .. string.upper(text)) then return end
--%  define("INCLUDE." .. string.upper(text), "")
--%  table.insert(enabled, text)
--%end
--%enable("string")
--%enable("table")
--%enable("url")
--%enable("bytes")
--%enable("vec2")
--%enable("vec3")
--%enable("switch")
--%enable("noop")
--%enable("enum")
--%enable("json")
--%if var("TARGET") ~= "Embedded" and var("EMBED_FILE") ~= nil then enable("ret") end
--%if var("TARGET") == "OpenOS" then
--%  enable("filesystem")
--%end
local t = {
--!ifdef INCLUDE.FILESYSTEM
	filesystem = {
		blockSize = 4096
	},
--!end
--%for k, v in pairs(enabled)
--%do
--%  if v ~= "filesystem" then print("\t" .. v .. " = {},\n") end
--%end

}

--!ifdef INCLUDE.STRING
--%include("./src/string.lua")
--!end
--!ifdef INCLUDE.TABLE
--%include("./src/table.lua")
--!end
--!ifdef INCLUDE.FILESYSTEM
--%include("./src/filesystem.lua")
--!end
--!ifdef INCLUDE.URL
--%include("./src/url.lua")
--!end
--!ifdef INCL_FSTR
--%include("./src/fstr.lua")
--!end
--!ifdef INCLUDE.BYTES
--%include("./src/bytes.lua")
--!end

--!ifdef INCLUDE.VEC2
--%include("./src/vec2.lua")
--!end

--!ifdef INCLUDE.VEC3
--%include("./src/vec3.lua")
--!end

--!ifdef INCLUDE.ENUM
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

--!ifdef INCLUDE.SWITCH
--%include("./src/switch.lua")
--!end

--!ifdef INCLUDE.NOOP
function t.noop() end -- does literally nothing
--!end

--!ifdef INCLUDE.JSON
local function init_json() -- workaround while the bundler isn't written
--%include("./src/json.lua/json.lua")
end
t.json = init_json();
--!end

--%if var("TARGET") == "Embedded" and defined("EMBED_FILE") then
--%include(var"EMBED_FILE")
--%end

--!ifdef INCLUDE.RET
return t
--!end
