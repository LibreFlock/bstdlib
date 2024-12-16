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
			:done()
	end)
end)
tu.suite('filesystem', function()

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
-- table_debug(bstd.string.split("/hey/suss/aaaaa", "/"))
-- local b = bstd.string.split("hey/duck/sus", "/")
-- print(tostring(table_equals(b, d)))

print(string.format("%d succeeded, %d tests failed.", tu.success, tu.fail))
if tu.fail > 0 then
	os.exit(1) -- this will be eventually added into CI/CD so we gotta do this
end

