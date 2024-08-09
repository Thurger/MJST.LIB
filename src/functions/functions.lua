if not SMODS then sendErrorMessage("[MJST.LIB](src/functions/functions.lua line 1): ERROR - SMODS missing", "MJST.LIB") return end
if not G then sendErrorMessage("[MJST.LIB](src/functions/functions.lua line 2): ERROR - G missing", "MJST.LIB") return end
if not NFS then sendErrorMessage("[MJST.LIB](src/functions/functions.lua line 3): ERROR - NFS missing", "MJST.LIB") return end

G.mjst_lib = G.mjst_lib or {}
G.mjst_lib.functions = G.mjst_lib.functions or {}

--- This function returns the ret value after inserting valid values from data.
--- Different values from data will be added to already set data from ret.
--- nil values from ret will be set from data to ret.
--- Numbers will be added to each other.
--- String will be set from data to ret.
--- Boolean will be set from data to ret.
--- Functions will be set from data to ret.
--- Tables will be inspected with same rules (default maximum depth 3).
--- Added by MJST.LIB mod.
---@param ret table Receiver of the data. Can be nil.
---@param data table Data table to add.
---@param max_depth number maximum depth the function can go into a table. Default 3.
---@return table
function G.mjst_lib.functions.add_data_to_ret(ret, data, max_depth)
    if type(ret) ~= "table" then return data or {} end
    if type(data) ~= "table" then return ret end
    if type(max_depth) ~= "number" then max_depth = 3 end

    for key, value in pairs(data) do
        if !ret[key] then ret[key] = value
        elseif type(ret[key]) ~= type(value) then
            sendWarnMessage("[MJST.LIB](src/functions/functions.lua line 29): WARN - Tried to add data[" .. key .. "] of type \"" .. type(value) .. "\" to ret[" .. key .. "] of type \"" .. type(ret[key]) .. "\".", "MJST.LIB")
        else
            if type(value) == "number" then
                ret[key] = ret[key] + value
            elseif type(value) == "string" then
                ret[key] = value
            elseif type(value) == "boolean" then
                ret[key] = value
            elseif type(value) == "table" then
                if max_depth > 0 then
                    ret[key] = G.mjst_lib.functions.add_data_to_ret(ret[key], value, max_depth - 1)
                end
            elseif type(value) == "function" then
                ret[key] = value
            else
                sendWarnMessage("[MJST.LIB](src/functions/functions.lua line 42): WARN - Tried to add data[" .. key .. "] of type \"" .. type(value) .. "\" to ret[" .. key .. "] of type \"" .. type(ret[key]) .. "\" but this function can't handle that.", "MJST.LIB")
            end
        end
    end

    return ret
end

--- This function returns the ret value after setting values from data.
--- Tables will be inspected with same rules (default maximum depth 3).
--- Added by MJST.LIB mod.
---@param ret table Receiver of the data. Can be nil.
---@param data table Data table to set
---@param max_depth number maximum depth the function can go into a table. Default 3.
---@return table
function G.mjst_lib.functions.set_data_to_ret(ret, data, max_depth)
    return ret
end

--- This function returns the key_table with the values replaced by the values of the value_table.
--- Exemple: key_table = {_name = "name_key", _age = "age_key"}; value_table = {name_key = "Jimbo", age_key = "Unknown"}; ret = nil; ==> ret = {_name = "Jimbo", _age = "Unknown"}
--- @param value_table table Table with the values
--- @param key_table table Table with the keys to go match with @value_table
--- @param ret table|nil Receiver of the data. Can be nil.
--- @param max_depth number maximum depth the function can go into a table. Default 3.
--- @return table
function G.mjst_lib.functions.get_value_table_from_key_table(value_table, key_table, ret, max_depth)
    ret = ret or {}

    for key, value in pairs(key_table) do
        if type(value) == "table" then
            ret[key] = G.mjst_lib.functions.get_value_table_from_key_table(value_table[key], key_table[key], ret);
        elseif type(value) == "number" or type(value) == "string" then
            ret[key] = value_table[value]
        end
    end

    return ret
end
