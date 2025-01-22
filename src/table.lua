---@diagnostic disable:undefined-global
-- Checks if a table has a specified key.
---@return boolean
function t.table.has_key(tab, key)
	for k, v in pairs(tab)
	do
		if k == key then return true end
	end
	return false
end
-- Checks if a table has a specific value. (`val`)
---@return boolean
function t.table.has_value(tab, val)
	for k, value in pairs(tab)
	do
		if value == val then return true end
	end
	return false
end
-- Creates a iterator going over the values of a table.
---@return fun(): any
function t.table.itval(tab)
	local i = 1
	return function ()
		if i > #tab then return nil end
		i = i + 1
		return tab[i - 1]
	end
end
-- Creates a table from an iterator (`it`).
-- Returns a table array.
---@return any[]
function t.table.from_iterator(it)
	local tab = {}
	for value in it
	do
		table.insert(tab, value)
	end
	return tab
end

--- Gets a value from a table at `p`, accepts negative values
---@param tab any[]
---@param p integer
function t.table.at(tab, p)
	if p > 0 then
		return tab[p]
	else
		return tab[#tab + (p + 1)] -- i hate 1-based indexingi hate 1-based indexedi hate-
	end
end
-- yes this will overflow the stack if the tables are too nested
function t.table.deep_equal(s1, s2)
	for k, v in pairs(s1)
	do
		if type(s1[k]) ~= type(s2[k]) then
			return false
		end
		if type(s1[k]) == "table" then
			if not t.table.deep_equal(s1[k], s2[k]) then
				return false
			end
		elseif s1[k] ~= s2[k] then
			return false
		end
	end

	for k, v in pairs(s2)
	do
		if type(s1[k]) ~= type(s2[k]) then
			return false
		end
		if type(s2[k]) == "table" then
			if not t.table.deep_equal(s1[k], s2[k]) then
				return false
			end
		elseif s1[k] ~= s2[k] then
			return false
		end
	end
	
	return true
end

function t.table.size(tab)
	local i = 1
    for k, v in pairs(t)
    do
        i = i + 1
    end
    return i
end

function t.table.slice(tbl, first, last, step)
    local sliced = {}

    for i = first or 1, last or #tbl, step or 1 do
        --sliced[#sliced+1] = tbl[i]
        table.insert(sliced, tbl[i])
    end

    return sliced
end