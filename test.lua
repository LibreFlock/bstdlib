local bstd = require("bstdduck")
print("bstdlib test runner")
local success = 0
local fail = 0
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
		success = success + 1
	elseif type(r) == "string" then
		io.write("fail\n")
		io.write(r)
		fail = fail + 1
	else
		io.write("fail\n")
		fail = fail + 1
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

local function from_iter(i) -- gotta roll our own implementation, dogfeeding is bad here
	local out = {}
	for ch in i
	do
		table.insert(out, ch)
	end
	return out
end

suite('string', function()
	test('isplit simple', function()
		return table_equals(
			from_iter(bstd.string.isplit("hey/duck/sus", "/")),
			{ "hey", "duck", "sus" }
		)
	end)
	test('split simple', function()
		return table_equals(
			bstd.string.split("hey/duck/sus", "/"),
			{ "hey", "duck", "sus" }
		)
	end)
	test('split separator at start', function()
		return table_equals(
			bstd.string.split("/hey/suss/aaaaa", "/"),
			-- { "", "hey", "suss", "aaaaa" }
			{ "hey", "suss", "aaaaa" }
		)
	end)

	test('starts with', function()
		return bstd.string.starts_with('AMONGUS', 'AMO') and
			bstd.string.starts_with('mo gus', 'mo ') and not
			bstd.string.starts_with('quack', 'k')
	end)

	test('ends with', function()
		return bstd.string.ends_with('inspect', 'ect') and
			bstd.string.ends_with('exe.cute', 'e') and not
			bstd.string.ends_with('is that a bri\'ish person?', 'person')
	end)

	test('chars', function()
		local str = "Hello!"
		local target = {"H", "e", "l", "l", "o", "!"}
		local duck = from_iter(bstd.string.chars(str)) -- not gonna use table.from_iterator, dogfeeding is bad here
		return table_equals(duck, target)
	end)
end)
-- table_debug(bstd.string.split("/hey/suss/aaaaa", "/"))
-- local b = bstd.string.split("hey/duck/sus", "/")
-- print(tostring(table_equals(b, d)))

print(string.format("%d succeeded, %d tests failed.", success, fail))
if fail > 0 then
	os.exit(1) -- this will be eventually added into CI/CD so we gotta do this
end

