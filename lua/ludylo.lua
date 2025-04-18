local M = {}
package.cpath = "./cpp/?.so;" .. package.cpath
local isJit = type(jit) == "table"

--- Loads a native module via FFI or require.
-- @param name      string  The library name (e.g. "mylib" or "./mylib.so")
-- @param functions string|table|nil  C definitions as string or list of strings (only for FFI)
-- @param mode      number  0 = auto (default), 1 = FFI only, 2 = require only
-- @return          userdata|table The loaded module or function table
function M.load(name, functions, mode)
    mode = mode or 0
    local success, lib

    if isJit and functions and mode ~= 2 then
        local ffi = require("ffi")

        local defs
        if type(functions) == "table" then
            defs = table.concat(functions, "\n")
        elseif type(functions) == "string" then
            defs = functions
        else
            error("Invalid 'functions' argument: expected table or string")
        end

        local ok, err = pcall(ffi.cdef, defs)
        if not ok then
            error("FFI cdef failed: " .. err)
        end

        success, lib = pcall(ffi.load, name)
        if success then
            return lib
        end
    end

    if mode ~= 1 then
        success, lib = pcall(require, name)
        if success then
            return lib or nil
        end
    end

end

return M
