---@diagnostic disable:undefined-global
function t.vec2.new(px, py)
	local x, y = px, py
	if type(px) == "table" then
		x = px[1] or px.x
		y = px[2] or px.y
	end
	local v = {
		x = x,
		y = y
	}
	setmetatable(v, {
		__tostring = function(self)
			return "vec2(" .. tostring(self.x) .. ", " .. tostring(self.y) .. ")"
		end,
		__len = function(self) return 2 end,
		__unm = function(self)
			return t.vec2.new(-self.x, -self.y)
		end,
		__add = function(self, a) -- todo: add typechecking
			if type(a) == "number" then
				return t.vec2.new(self.x + a, self.y + a)
			end
			return t.vec2.new(self.x + a.x, self.y + a.y)
		end,
		__sub = function(self, a)
			if type(a) == "number" then
				return t.vec2.new(self.x - a, self.y - a)
			end
			return t.vec2.new(self.x - a.x, self.y - a.y)
		end,
		__mul = function(self, a)
			if type(a) == "number" then
				return t.vec2.new(self.x * a, self.y * a)
			end
			return t.vec2.new(self.x * a.x, self.y * a.y)
		end,
		__div = function(self, a)
			if type(a) == "number" then
				return t.vec2.new(self.x / a, self.y / a)
			end
			return t.vec2.new(self.x / a.x, self.y / a.y)
		end,
		__idiv = function(self, a)
			if type(a) == "number" then
				return t.vec2.new(self.x // a, self.y // a)
			end
			return t.vec2.new(self.x // a.x, self.y // a.y)
		end,
		__pow = function(self, a)
			if type(a) == "number" then
				return t.vec2.new(self.x ^ a, self.y ^ a)
			end
			return t.vec2.new(self.x ^ a.x, self.y ^ a.y)
		end, -- todo: bitwise operations
		__eq = function(self, a)
			if type(a) == "number" then
				return self.x == a and self.y == a
			end
			return self.x == a.x and self.y == a.y
		end,
		__lt = function(self, a)
			if type(a) == "number" then
				return self.x < a and self.y < a
			end
			return self.x < a.x and self.y < a.y
		end,
		__le = function(self, a)
			if type(a) == "number" then
				return self.x <= a and self.y <= a
			end
			return self.x <= a.x and self.y <= a.y
		end

	})
	return v
end