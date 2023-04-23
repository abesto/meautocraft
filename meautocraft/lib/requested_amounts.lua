local expect = (require "cc.expect").expect

local SETTINGS = require 'lib.SETTINGS'
local ioutils = require 'lib.ioutils'


---@return {[string]: number} | nil
local function load()
    if not fs.exists(SETTINGS.requested_amounts_path()) then
        return {}
    end

    local raw = ioutils.read_file(SETTINGS.requested_amounts_path())
    if not raw then
        return
    end

    local data = textutils.unserialize(raw)
    if not data then
        printError("Failed to parse requested amounts")
    end
    return data
end

---@param item string
---@param amount number
local function set(item, amount)
    expect(1, item, "string")
    expect(2, amount, "number")

    local data = load()
    if not data then
        return false
    end

    if amount == 0 then
        data[item] = nil
    else
        data[item] = amount
    end

    return ioutils.write_file(SETTINGS.requested_amounts_path(), textutils.serialize(data))
end

return {
    load = load,
    set = set,
}
