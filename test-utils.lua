local bstd = require("bstdduck")
local t = {
    success = 0,
    fail = 0
}
--local success = 0
--local fail = 0
function t.expect(name, value)
	return {
		name = name,
		val = value,
		success = true,
		errors = "",
		_add_error = function(self, err)
			self.errors = self.errors .. err .. "\n"
			self.success = false
			return self
		end,
		equals_to = function(self, b)
			if self.val ~= b then
				return self:_add_error(string.format("value '%s' expected to be '%s' but got '%s' instead", self.name, b, self.val))
			end
			return self
		end,
		not_equal_to = function(self, b)
			if self.val == b then
				self:_add_error(string.format("value '%s' expected NOT to be '%s' but got it anyway", self.name, b))
			end
			return self
		end,
		is_true = function(self)
			if not self.val then
				self:_add_error(string.format("value '%s' expected to be true but it was false.", self.name))
			end
			return self
		end,
		is_false = function(self)
			if self.val then
				self:_add_error(string.format("value '%s' expected to be false but it was true.", self.name))
			end
			return self
		end,
		table_equal_to = function(self, b)
			if not t.table_equals(self.val, b) then
				self:_add_error(string.format("table '%s' expected to be %s but got %s instead.", self.name, 'TODO', 'TODO'))
			end
			return self
		end,
		done = function(self)
			if self.success then
				return true
			end
			-- print(self.success, #self.errors)
			return self.errors
		end,
		expect = function(self, name, value)
			self.name = name
			self.val = value
			return self
		end
	}
end
function t.strf_util(fstr)
	return function(...)
		return string.format(fstr, ...)
	end
end
function t.suite(text, func)
	io.write(string.format("* %s", text))
	if bstd[text] == nil then
		io.write(" - skipped\n")
		return false
	end
	io.write("\n")
	func()
	return true
end
function t.test(text, func)
	io.write(string.format("  - %s ... ", text))
	local r = func()
	if r == true then
		io.write("ok\n")
		t.success = t.success + 1
	elseif type(r) == "string" then
		io.write("fail\n")
		io.write(r)
		t.fail = t.fail + 1
	else
		io.write("fail\n")
		t.fail = t.fail + 1
	end
end
function t.table_equals(s1, s2)
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
function t.ResultStore()
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

function t.table_debug(tab)
	for k, v in pairs(tab)
	do
		print(k, '=', v)
	end
end

function t.from_iter(i) -- gotta roll our own implementation, dogfeeding is bad here
	local out = {}
	for ch in i
	do
		table.insert(out, ch)
	end
	return out
end

return t