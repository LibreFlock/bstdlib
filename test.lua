local bstd = require("bstdduck")
print("bstdlib test runner")
local function suite(text, func)
	io.write(string.format("* %s", text))
	if not bstd[text] then
		io.write(" - skipped\n")
		return false
	end
	io.write("\n")
	func()
	return true
end
local function test(text, func)
	io.write(string.format("  - %s ... ", text))
	local r = func()
	if r then
		io.write("ok\n")
	else
		io.write("fail\n")
	end
end
local function table_equals(s1, s2)
	for k, v in pairs(s1)
	do
		if s2[k] ~= s1[k] then
			return false
		end
	end
	for k, v in pairs(s2)
	do
		if s2[k] ~= s1[k] then
			return false
		end
	end
	return true
end
local function ResultStore()
	return {
		results = {},
		add = function(self, a)
			table.insert(self.results, a)
		end,
		check = function(self)
			for i = 1, #self.results, 1
			do
				local r = self.results[i]
				if r == false then return false end
			end
			return true
		end
	}
end

local function table_debug(tab)
	for k, v in pairs(tab)
	do
		print(k, '=', v)
	end
end

suite('string', function()
	test('split simple', function()
		return table_equals(
			bstd.string.split("hey/duck/sus", "/"),
			{ "hey", "duck", "sus" }
		)
	end)
	test('split separator at start', function()
		return table_equals(
			bstd.string.split("/hey/suss/aaaaa", "/"),
			{ "", "hey", "suss", "aaaaa" }
		)
	end)
end)
table_debug(bstd.string.split("/hey/suss/aaaaa", "/"))
-- local b = bstd.string.split("hey/duck/sus", "/")
-- print(tostring(table_equals(b, d)))

