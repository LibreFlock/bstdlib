local bstd = require("bstdduck")
local tu = require("test-utils")
print("bstdlib test runner v0.2.0")

-- Tests start here
tu.suite('string', function() -- TODO: finish this
	tu.test('isplit simple', function()
		return tu.table_equals(
			tu.from_iter(bstd.string.isplit("hey/duck/sus", "/")),
			{ "hey", "duck", "sus" }
		)
	end)
	tu.test('split simple', function()
		return tu.table_equals(
			bstd.string.split("hey/duck/sus", "/"),
			{ "hey", "duck", "sus" }
		)
	end)
	tu.test('split separator at start', function()
		return tu.table_equals(
			bstd.string.split("/hey/suss/aaaaa", "/"),
			-- { "", "hey", "suss", "aaaaa" }
			{ "hey", "suss", "aaaaa" }
		)
	end)
	tu.test('split safe (one char)', function()
		return tu.table_equals(
			bstd.string.split_s("hey/sus/aaaa", "/"),
			{ "hey", "sus", "aaaa" }
		)
	end)
	tu.test('split safe (two chars)', function()
		return tu.table_equals(
			bstd.string.split_s("hey:/sus:/aaaa", ":/"),
			{ "hey", "sus", "aaaa" }
		)
	end)
	tu.test('split safe (three chars)', function()
		return tu.table_equals(
			bstd.string.split_s("heyXYZsusXYZaaaa", "XYZ"),
			{ "hey", "sus", "aaaa" }
		)
	end)
	

	tu.test('starts with', function()
		return bstd.string.starts_with('AMONGUS', 'AMO') and
			bstd.string.starts_with('mo gus', 'mo ') and not
			bstd.string.starts_with('quack', 'k')
	end)

	tu.test('ends with', function()
		return bstd.string.ends_with('inspect', 'ect') and
			bstd.string.ends_with('exe.cute', 'e') and not
			bstd.string.ends_with('is that a bri\'ish person?', 'person')
	end)

	tu.test('chars', function()
		local str = "Hello!"
		local target = {"H", "e", "l", "l", "o", "!"}
		local duck = tu.from_iter(bstd.string.chars(str)) -- not gonna use table.from_iterator, dogfeeding is bad here
		return tu.table_equals(duck, target)
	end)
end)
tu.suite('table', function()
	local kvtarget = { a = 1, b = 2, c = 3, d = 4 }
	tu.test('has_key', function()
		return bstd.table.has_key(kvtarget, "a") and
			bstd.table.has_key(kvtarget, "b") and
			bstd.table.has_key(kvtarget, "c") and
			bstd.table.has_key(kvtarget, "d") and not
			bstd.table.has_key(kvtarget, "duck")
	end)
	tu.test('has_value dictionary', function()
		local s = tu.strf_util("has_value(kvtarget, %s)")
		return tu.expect(s"1", bstd.table.has_value(kvtarget, 1)):is_true()
			:expect(s"2", bstd.table.has_value(kvtarget, 2)):is_true()
			:expect(s"3", bstd.table.has_value(kvtarget, 3)):is_true()
			:expect(s"4", bstd.table.has_value(kvtarget, 4)):is_true()
			:expect(s"5", bstd.table.has_value(kvtarget, 5)):is_false()
			:expect(s"d", bstd.table.has_value(kvtarget, "d")):is_false()
			:done()
	end)
	tu.test('has_key table array', function()
		local arr = {1, 2, 3, 4}
		local s = tu.strf_util("has_key(arr, %s)")
		return tu.expect(s"1", bstd.table.has_key(arr, 1)):is_true()
			:expect(s"2", bstd.table.has_key(arr, 2)):is_true()
			:expect(s"3", bstd.table.has_key(arr, 3)):is_true()
			:expect(s"4", bstd.table.has_key(arr, 4)):is_true()
			:expect(s"\"d\"", bstd.table.has_key(arr, "d")):is_false()
			:done()
	end)
	tu.test('at', function ()
		local target = {1, 2, 3, 4}
		--return bstd.table.at(target, 1) == 1 and
		--	bstd.table.at(target, 2) == 2 and
		--	bstd.table.at(target, 3) == 3 and
		--	bstd.table.at(target, 4) == 4 and
		--	bstd.table.at(target, -1) == 4
		return tu.expect("at(target, 1)", bstd.table.at(target, 1)):equals_to(1)
			:expect("at(target, 2)", bstd.table.at(target, 2)):equals_to(2)
			:expect("at(target, 3)", bstd.table.at(target, 3)):equals_to(3)
			:expect("at(target, -1)", bstd.table.at(target, -1)):equals_to(4)
			:done()
	end)
	tu.test('from_iterator', function ()
		local i = 0
		local iter = function ()
			if i > 10 then return nil end
			i = i + 1
			return i
		end
		
		return tu.expect("from_iterator(target)", bstd.table.from_iterator(iter))
			:table_equal_to({1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11})
			:done()
	end)
end)
tu.suite('filesystem', function()
	-- Can't be tested outside of OC rn
end)
tu.suite('url', function()
	tu.test('encode', function()
		-- return bstd.url.encode('Hello world!') == "Hello+world%21"
		return tu.expect("encode('Hello world!')", bstd.url.encode('Hello world!'))
			:equals_to("Hello+world%21"):done()
	end)

	tu.test('decode', function()
		--return bstd.url.decode('Hello%20world%21') == "Hello world!" and
		--	bstd.url.decode('Hello+world%21') == "Hello world!"
		return tu.expect("decode('Hello%20world%21')", bstd.url.decode('Hello%20world%21'))
			:equals_to("Hello world!")
			:expect("decode('Hello+world%21')", bstd.url.decode('Hello+world%21'))
			:equals_to("Hello world!"):done()
	end)
end)
tu.suite('bytes', function()
	local target = "hello"
	local t2 = "454647"
	tu.test('string', function()
		local s = "string(target)"
		return tu.expect(s, tu.from_iter(bstd.bytes.string(target))):table_equal_to({104, 101, 108, 108, 111})
		:done()
	end)
	tu.test('from_hex', function()
		local s = "from_hex(t2)"
		return tu.expect(s, bstd.bytes.from_hex(t2)):equals_to("EFG"):done()
	end)
	tu.test('to_hex', function()
		local s = "to_hex('EFG')"
		return tu.expect(s, bstd.bytes.to_hex("EFG")):equals_to(t2):done()
	end)
end)
tu.suite('vec2', function ()
	tu.test('new(x, y)', function ()
		return tu.expect("vec2.new(10, 5)", bstd.vec2.new(10, 5)):table_equal_to({ x = 10, y = 5 })
			:done()
	end)
	tu.test('new({x, y})', function ()
		return tu.expect("vec2.new({10, 5})", bstd.vec2.new({10, 5})):table_equal_to({ x = 10, y = 5 })
			:done()
	end)
	tu.test('new({x=x, y=y})', function ()
		return tu.expect("vec2.new({x = 10, y = 5})", bstd.vec2.new({x = 10, y = 5})):table_equal_to({ x = 10, y = 5 })
			:done()
	end)
	
	tu.test('length', function ()
		return tu.expect("#vec2", #bstd.vec2.new(1, 1)):equals_to(2)
			:done()
	end)
	tu.test('unm', function ()
		return tu.expect("#vec2", -bstd.vec2.new(1, 1)):table_equal_to({ x = -1, y = -1 })
			:done()
	end)
	tu.test('vec2 + x', function ()
		return tu.expect("vec2(1, 1) + 2", bstd.vec2.new(1, 1) + 2):table_equal_to({ x = 3, y = 3 })
			:done()
	end)
	tu.test('vec2 + vec2', function ()
		return tu.expect("vec2(1, 1) + vec2(3, 4)", bstd.vec2.new(1, 1) + bstd.vec2.new(3, 4)):table_equal_to({ x = 4, y = 5 })
			:done()
	end)
	tu.test('vec2 - x', function ()
		return tu.expect("vec2(1, 1) - 2", bstd.vec2.new(1, 1) - 2):table_equal_to({ x = -1, y = -1 })
			:done()
	end)
	tu.test('vec2 - vec2', function ()
		return tu.expect("vec2(1, 1) - vec2(3, 4)", bstd.vec2.new(1, 1) - bstd.vec2.new(3, 4)):table_equal_to({ x = -2, y = -3 })
			:done()
	end)
	tu.test('vec2 * x', function ()
		return tu.expect("vec2(2, 2) * 5", bstd.vec2.new(2, 2) * 5):table_equal_to({ x = 10, y = 10 })
			:done()
	end)
	tu.test('vec2 * vec2', function () -- TODO: operations of vec2 and number
		return tu.expect("vec2(2, 2) * vec2(5, 10)", bstd.vec2.new(2, 2) * bstd.vec2.new(5, 10)):table_equal_to({ x = 10, y = 20 })
			:done()
	end)
	tu.test('vec2 * x', function ()
		return tu.expect("vec2(2, 8) * 5", bstd.vec2.new(2, 8) * 5):table_equal_to({ x = 10, y = 40 })
			:done()
	end)
	tu.test('vec2 / vec2', function ()
		return tu.expect("vec2(100, 100) / vec2(2, 4)", bstd.vec2.new(100, 100) / bstd.vec2.new(2, 4)):table_equal_to({ x = 50, y = 25 })
			:done()
	end)
	tu.test('vec2 / x', function ()
		return tu.expect("vec2(100, 100) / 10", bstd.vec2.new(100, 100) / 10):table_equal_to({ x = 10, y = 10 })
			:done()
	end)
	tu.test('vec2 // vec2', function ()
		return tu.expect("vec2(100, 100) // vec2(6, 4)", bstd.vec2.new(100, 100) // bstd.vec2.new(6, 4)):table_equal_to({ x = 16, y = 25 })
			:done()
	end)
	tu.test('vec2 // x', function ()
		return tu.expect("vec2(90, 40) // 3", bstd.vec2.new(90, 40) // 3):table_equal_to({ x = 30, y = 13 })
			:done()
	end)
	tu.test('vec2 ^ vec2', function ()
		return tu.expect("vec2(2, 2) ^ vec2(16, 8)", bstd.vec2.new(2, 2) ^ bstd.vec2.new(16, 8)):table_equal_to({ x = 65536, y = 256 })
			:done()
	end)
	tu.test('vec2 ^ x', function ()
		return tu.expect("vec2(2, 4) ^ 8", bstd.vec2.new(2, 4) ^ 8):table_equal_to({ x = 256, y = 65536 })
			:done()
	end)
	tu.test('vec2 == vec2', function ()
		return tu.expect("vec2(2, 5) == vec2(2, 5)", bstd.vec2.new(2, 5) == bstd.vec2.new(2, 5)):is_true()
			:expect("vec2(2, 5) != vec2(10, 5)", bstd.vec2.new(2, 5) == bstd.vec2.new(10, 5)):is_false()
			:expect("vec2(2, 5) != vec2(23, 42)", bstd.vec2.new(2, 5) == bstd.vec2.new(23, 42)):is_false()
			:done()
	end)
end)
tu.suite('vec3', function ()
	tu.test('new(x, y, z)', function ()
		return tu.expect("vec2.new(10, 5, 3)", bstd.vec3.new(10, 5, 3)):table_equal_to({ x = 10, y = 5, z = 3 })
			:done()
	end)
	tu.test('new({x, y, z})', function ()
		return tu.expect("vec3.new({10, 5, 3})", bstd.vec3.new({10, 5, 3})):table_equal_to({ x = 10, y = 5, z = 3 })
			:done()
	end)
	tu.test('new({x=x, y=y, z=z})', function ()
		return tu.expect("vec2.new({x = 10, y = 5, z = 3})", bstd.vec3.new({x = 10, y = 5, z = 3})):table_equal_to({ x = 10, y = 5, z = 3 })
			:done()
	end)
	
	tu.test('length', function ()
		return tu.expect("#vec3", #bstd.vec3.new(1, 1, 1)):equals_to(3)
			:done()
	end)
	tu.test('unm', function ()
		return tu.expect("-vec3", -bstd.vec3.new(1, 2, 3)):table_equal_to({ x = -1, y = -2, z = -3 })
			:done()
	end)
	tu.test('vec3 + x', function ()
		return tu.expect("vec3(1, 1, 1) + 2", bstd.vec3.new(1, 1, 1) + 2):table_equal_to({ x = 3, y = 3, z = 3 })
			:done()
	end)
	tu.test('vec3 + vec3', function ()
		return tu.expect("vec3(1, 1, 1) + vec3(3, 4, 5)", bstd.vec3.new(1, 1, 1) + bstd.vec3.new(3, 4, 5)):table_equal_to({ x = 4, y = 5, z =  6 })
			:done()
	end)
	tu.test('vec3 - x', function ()
		return tu.expect("vec3(1, 1, 1) - 2", bstd.vec3.new(1, 1, 1) - 2):table_equal_to({ x = -1, y = -1, z = -1 })
			:done()
	end)
	tu.test('vec3 - vec3', function ()
		return tu.expect("vec3(1, 1, 1) - vec2(3, 4, 5)", bstd.vec3.new(1, 1, 1) - bstd.vec3.new(3, 4, 5)):table_equal_to({ x = -2, y = -3, z = -4 })
			:done()
	end)
	tu.test('vec3 * x', function ()
		return tu.expect("vec3(2, 2, 4) * 5", bstd.vec3.new(2, 2, 4) * 5):table_equal_to({ x = 10, y = 10, z = 20 })
			:done()
	end)
	tu.test('vec3 * vec3', function () -- TODO: operations of vec3 and number
		return tu.expect("vec3(2, 2, 2) * vec2(5, 10, 15)", bstd.vec3.new(2, 2, 2) * bstd.vec3.new(5, 10, 15)):table_equal_to({ x = 10, y = 20, z = 30 })
			:done()
	end)
	tu.test('vec3 * x', function ()
		return tu.expect("vec3(2, 8, 4) * 5", bstd.vec3.new(2, 8, 4) * 5):table_equal_to({ x = 10, y = 40, z = 20 })
			:done()
	end)
	tu.test('vec3 / vec3', function ()
		return tu.expect("vec3(100, 100, 100) / vec3(2, 4, 5)", bstd.vec3.new(100, 100, 100) / bstd.vec3.new(2, 4, 5)):table_equal_to({ x = 50, y = 25, z = 20 })
			:done()
	end)
	tu.test('vec3 / x', function ()
		return tu.expect("vec3(100, 100, 100) / 10", bstd.vec3.new(100, 100, 100) / 10):table_equal_to({ x = 10, y = 10, z = 10 })
			:done()
	end)
	tu.test('vec3 // vec3', function ()
		return tu.expect("vec3(100, 100, 100) // vec3(6, 4, 2)", bstd.vec3.new(100, 100, 100) // bstd.vec3.new(6, 4, 2)):table_equal_to({ x = 16, y = 25, z = 50 })
			:done()
	end)
	tu.test('vec3 // x', function ()
		return tu.expect("vec3(90, 40, 20) // 3", bstd.vec3.new(90, 40, 20) // 3):table_equal_to({ x = 30, y = 13, z = 6 })
			:done()
	end)
	tu.test('vec3 ^ vec3', function ()
		return tu.expect("vec3(2, 2, 2) ^ vec2(16, 8, 32)", bstd.vec3.new(2, 2, 2) ^ bstd.vec3.new(16, 8, 32)):table_equal_to({ x = 65536, y = 256, z = 4294967296 })
			:done()
	end)
	tu.test('vec3 ^ x', function ()
		return tu.expect("vec3(2, 4, 6) ^ 8", bstd.vec3.new(2, 4, 6) ^ 8):table_equal_to({ x = 256, y = 65536, z = 1679616 })
			:done()
	end)
	tu.test('vec3 == vec3', function ()
		return tu.expect("vec3(2, 5, 6) == vec2(2, 5, 6)", bstd.vec3.new(2, 5, 6) == bstd.vec3.new(2, 5, 6)):is_true()
			:expect("vec3(2, 5, 6) != vec3(10, 5, 6)", bstd.vec3.new(2, 5, 6) == bstd.vec3.new(10, 5, 6)):is_false()
			:expect("vec3(2, 5, 60) != vec3(23, 42, 60)", bstd.vec3.new(2, 5, 60) == bstd.vec3.new(23, 42, 60)):is_false()
			:done()
	end)
end)

-- table_debug(bstd.string.split("/hey/suss/aaaaa", "/"))
-- local b = bstd.string.split("hey/duck/sus", "/")
-- print(tostring(table_equals(b, d)))

print(string.format("%d succeeded, %d tests failed.", tu.success, tu.fail))
if tu.fail > 0 then
	os.exit(1) -- this will be eventually added into CI/CD so we gotta do this
end

