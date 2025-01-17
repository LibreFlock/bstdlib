---@diagnostic disable:undefined-global
function t.switch.create(var)
	return function (tab)
		local found = false -- to replicate the behavior of JS's switch()
		for k, v in ipairs(tab)
		do
			if var == v.match or found then
				local retv = v.func()
				local mt = getmetatable(retv)
				if mt ~= nil then
					if mt.__bstd_switch_case_action == "break" then
						-- break
						return retv
					end
				end
				found = true
			end
		end
	end
end
function t.switch.case(matcher)
	return function (fc)
		return { match = matcher, func = fc }
	end
end
function t.switch.stop(tab)
	local duck = {}
	if type(tab) == "table" then
		duck = tab
	end
	setmetatable(duck, {
		__bstd_switch_case_action = "break"
	})
	return duck
end

function t.case(...) -- shortcut
	return t.switch.case(...)
end
function t.stop(...) -- shortcut
	return t.switch.stop(...)
end

setmetatable(t.switch, {
	__call = function (self, ...)
		return self.create(...)
	end
})
