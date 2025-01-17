#!/usr/bin/env lua
-- local io = require("io")
local debugMode = false
local class = {
    CodeChunk = function(text)
        return { type = "codechunk", text = text }
    end,
    MacroLine = function(code)
        return { type = "macroline", code = code }
    end,
    MacroShortcut = function(code)
       return { type = "macroshortcut", code = code } 
    end
}

local function readfile(fname, _io)
    local h, err = (_io or io).open(fname, "r")
    if h == nil then
        print(err)
        return nil, err
    end
    local data, err = h:read("a")
    if data == nil then
        print(err)
        return nil, err
    end
    h:close()
    return data
end
local function table_size(t)
    local i = 1
    for k, v in pairs(t)
    do
        i = i + 1
    end
    return i
end
local function iter_to_table(it)
    local t = {}
    for v in it do
        table.insert(t, v)
    end
    return t
end
local function table_slice(tbl, first, last, step)
    local sliced = {}

    for i = first or 1, last or #tbl, step or 1 do
        --sliced[#sliced+1] = tbl[i]
        table.insert(sliced, tbl[i])
    end

    return sliced

end

local function parse(text)
    local ast = {}
    local lbuf = ""
    for line in text:gmatch("[^\n]+") do
        if string.sub(line, 1, 3) == "--%" then
            if #lbuf > 0 then
                table.insert(ast, class.CodeChunk(lbuf))
                lbuf = ""
            end
            table.insert(ast, class.MacroLine(string.sub(line, 4)))
        elseif string.sub(line, 1, 3) == "--!" then
            if #lbuf > 0 then
                table.insert(ast, class.CodeChunk(lbuf))
                lbuf = ""
            end
            table.insert(ast, class.MacroShortcut(string.sub(line, 4)))
        else
            lbuf = lbuf .. line .. "\n"
        end
    end
    if #lbuf > 0 then
        table.insert(ast, class.CodeChunk(lbuf))
        lbuf = ""
    end
    return ast
end
local function shortcutToLua(code)
    local split = iter_to_table(string.gmatch(code, "%S+"))
    local cmd = split[1]
    local args = table_slice(split, 2)

    if cmd == "ifdef" then
        return string.format("if defined(%q) then", args[1])
    elseif cmd == "end" then
        return "end"
    elseif cmd == "ifndef" then
        return string.format("if not defined(%q) then", args[1])
    elseif cmd == "define" then
        return string.format("define(%q, %q)", args[1], table.concat(table_slice(args, 2), " "))
    else
        return "-- unknown shortcut: " .. code
    end
end
local function transpile(ast)
    local code = ""

    for i, node in ipairs(ast) do
        if node.type == "codechunk" then
            code = code .. string.gsub(string.format("print(pm(%q))\n", node.text), "\\\n", "\\n")
        end
        if node.type == "macroline" then
            code = code .. node.code .. "\n"
        end
        if node.type == "macroshortcut" then
            code = code .. shortcutToLua(node.code) .. "\n"
        end
    end

    return code
end

local function sandbox_run(code, m)
    local codegen = "local "
    local mvalues = {}
    local i = 1
    local ts = table_size(m)
    for k, v in pairs(m) do
        codegen = codegen .. k
        if i < (ts-1) then
            codegen = codegen .. ","
        end
        table.insert(mvalues, v)
        i = i + 1
    end
    codegen = codegen .. " = ..."
    local loadcode = [[
        io = nil
        require = nil
        debug = nil
        load = nil
    ]] .. codegen .. "\n" .. code
    if debugMode then
        print(loadcode)
        print("----")
    end
    local duck, err = load(loadcode, "=sandbox")
    if duck == nil then
        print(err)
        return
    end
    local io = _G.io
    local require = _G.require
    local debug = _G.debug
    local print = _G.print
    local load = _G.load
    local fcres = table.pack(duck(table.unpack(mvalues)))
    _G.io = io
    _G.require = require
    _G.debug = debug
    _G.print = print
    _G.load = load
    return table.unpack(fcres)
end
local function escape_pattern(text)
    return text:gsub("%W", "%%%1")
end

local function processMacros(file, predef)
    local ast = parse(file)
    local code = transpile(ast)
    local result = ""
    local io = _G.io -- grab io before the sandbox can
    local defined = predef or {}
    local resp = sandbox_run(code, {
        print = function(a)
            result = result .. a
        end,
        defined = function(var)
            for k, v in pairs(defined)
            do
                if k == var then
                    return true
                end
            end
            return false
        end,
        define = function(var, res)
            defined[var] = res
        end,
        pm = function(text)
            local res = text
            for k, v in pairs(defined)
            do
                res = res:gsub(escape_pattern(k), v)
            end
            return res
        end,
        include = function(filename)
            local duck, err = readfile(filename, io)
            if duck == nil then
                result = result .. "-- include failed: " .. err .. "\n"
                return
            end
            result = result .. duck .. "\n"
        end,
        undefine = function(var)
            defined[var] = nil
        end,
        var = function(var)
            return defined[var]
        end
    })
    return result, defined
end

local function parseArguments(...)
    local args = table.pack(...)
    local rargs = {}
    local ropt = {}
    for k, v in ipairs(args)
    do
        if v == "-" then
            table.insert(rargs, v)
        elseif string.sub(v, 1, 1) == "-" then
            local rest = string.sub(v, 2)
            local equalPos = string.find(rest, "=")
            if equalPos ~= nil then
                local name = string.sub(rest, 1, equalPos-1)
                local val = string.sub(rest, equalPos+1, #rest)
                ropt[name] = val
            else
                ropt[rest] = true
            end
        else
            table.insert(rargs, v)
        end
    end
    return rargs, ropt
end
local function run(args, opt)
    local input = args[1]
    local output = args[2]
    --print(input, output)
    local file = readfile(input)
    --print(file)
    local predef = {}

    for k, v in pairs(opt)
    do
        if string.sub(k, 1, 1) == "D" then
            local name = string.sub(k, 2)
            local val = v
            if val == true then
                val = ""
            end
            predef[name] = val
        end
        if k == "-debug" then
            debugMode = true
        end
    end

    local out = processMacros(file, predef)
    if output == "-" then
        io.write(out)
    else
        local h, err = io.open(output, "w")
        if h == nil then
            error(err)
            return
        end
        h:write(out)
        h:close()
    end
end

local args, opt = parseArguments(...)
run(args, opt)
--[[for k, v in ipairs(ast) do
    print(k, v.type, v.text or v.code)
end]]
