local bstd = require("bstdduck")
print("bstdlib test runner")
local success = 0
local fail = 0
local function expect(name, value)
	return {
		name = name,
		val = value,
		success = true,
		errors = "",
		_add_error = function(self, err)
			self.errors = self.errors .. err .. "\n"
			self.success = false
		end,
		equals_to = function(self, b)
			if self.val ~= b then
				self._add_error(string.format("value '%s' expected to be '%s' but got '%s' instead", self.name, self.val, b))
			end
			return self
		end,
		not_equal_to = function(self, b)
			if self.val == b then
				self._add_error(string.format("value '%s' expected NOT to be '%s' but got it anyway", self.name, b))
			end
			return self
		end,
		is_true = function(self)
			if not self.val then
				self._add_error(string.format("value '%s' expected to be true but it was false.", self.name)
			end
			return self
		end,
		is_false = function(self)
			if self.val then
				self._add_error(string.format("value '%s' expected to be false but it was true.", self.name)
			end
			return self
		end,
		table_equal_to = function(self, b)
			if not table_equals(self.val, b) then
				self._add_error(string.format("table '%s' expected to be %s but got %s instead.", self.name, 'TODO', 'TODO'))
			end
			return self
		end,
		done = function(self)
			if self.success then
				return true
			end
			return self.errors
		end,
	}
end

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

suite('string', function() -- TODO: finish this
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
suite('table', function()
	local kvtarget = { a = 1, b = 2, c = 3, d = 4 }
	test('has_key', function()
		return bstd.table.has_key(kvtarget, "a") and
			bstd.table.has_key(kvtarget, "b") and
			bstd.table.has_key(kvtarget, "c") and
			bstd.table.has_key(kvtarget, "d") and not
			bstd.table.has_key(kvtarget, "duck")
	end)
	test('has_value', function()
		return bstd.table.has_value(kvtarget, 1) and
			bstd.table.has_value(kvtarget, 2) and
			bstd.table.has_value(kvtarget, 3) and
			bstd.table.has_value(kvtarget, 4) and not
			bstd.table.has_value(kvtarget, 5) and not
			bstd.table.has_value(kvtarget, "d")
	end)
	test('at', function ()
		local target = {1, 2, 3, 4}
		return bstd.table.at(target, 1) == 1 and
			bstd.table.at(target, 2) == 2 and
			bstd.table.at(target, 3) == 3 and
			bstd.table.at(target, 4) == 4 and
			bstd.table.at(target, -1) == 4
	end)
end)
suite('filesystem', function()

end)
suite('url', function()
	test('encode', function()
		return bstd.url.encode('Hello world!') == "Hello+world%21"
	end)

	test('decode', function()
		return bstd.url.decode('Hello%20world%21') == "Hello world!" and
			bstd.url.decode('Hello+world%21') == "Hello world!"
	end)
end)
-- table_debug(bstd.string.split("/hey/suss/aaaaa", "/"))
-- local b = bstd.string.split("hey/duck/sus", "/")
-- print(tostring(table_equals(b, d)))

print(string.format("%d succeeded, %d tests failed.", success, fail))
if fail > 0 then
	os.exit(1) -- this will be eventually added into CI/CD so we gotta do this
end

