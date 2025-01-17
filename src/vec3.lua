---@diagnostic disable:undefined-global
function t.vec3.new(px, py, pz)
	local x, y, z = px, py, pz
	if type(px) == "table" then
		x = px[1] or px.x
		y = px[2] or px.y
		z = px[3] or px.z
	end
	local v = {
		x = x,
		y = y,
		z = z
	}
	setmetatable(v, {
		__tostring = function(self)
			return "vec3(" .. tostring(self.x) .. ", " .. tostring(self.y) .. ", " .. tostring(self.z) .. ")"
		end,
		__len = function(self) return 3 end,
		__unm = function(self)
			return t.vec3.new(-self.x, -self.y, -self.z)
		end,
		__add = function(self, a) -- todo: add typechecking
			if type(a) == "number" then
				return t.vec3.new(self.x + a, self.y + a, self.z + a)
			end
			return t.vec3.new(self.x + a.x, self.y + a.y, self.z + a.z)
		end,
		__sub = function(self, a)
			if type(a) == "number" then
				return t.vec3.new(self.x - a, self.y - a, self.z - a)
			end
			return t.vec3.new(self.x - a.x, self.y - a.y, self.z - a.z)
		end,
		__mul = function(self, a)
			if type(a) == "number" then
				return t.vec3.new(self.x * a, self.y * a, self.z * a)
			end
			return t.vec3.new(self.x * a.x, self.y * a.y, self.z * a.z)
		end,
		__div = function(self, a)
			if type(a) == "number" then
				return t.vec3.new(self.x / a, self.y / a, self.z / a)
			end
			return t.vec3.new(self.x / a.x, self.y / a.y, self.z / a.z)
		end,
		__idiv = function(self, a)
			if type(a) == "number" then
				return t.vec3.new(self.x // a, self.y // a, self.z // a)
			end
			return t.vec3.new(self.x // a.x, self.y // a.y, self.z // a.z)
		end,
		__pow = function(self, a)
			if type(a) == "number" then
				return t.vec3.new(self.x ^ a, self.y ^ a, self.z ^ a)
			end
			return t.vec3.new(self.x ^ a.x, self.y ^ a.y, self.z ^ a.z)
		end, -- todo: bitwise operations
		__eq = function(self, a)
			if type(a) == "number" then
				return self.x == a and self.y == a and self.z == a
			end
			return self.x == a.x and self.y == a.y and self.z == a.z
		end,
		__lt = function(self, a)
			if type(a) == "number" then
				return self.x < a and self.y < a and self.z < a
			end
			return self.x < a.x and self.y < a.y and self.z < a.z
		end,
		__le = function(self, a)
			if type(a) == "number" then
				return self.x <= a and self.y <= a and self.z <= a
			end
			return self.x <= a.x and self.y <= a.y and self.z <= a.z
		end

	})
	return v
end