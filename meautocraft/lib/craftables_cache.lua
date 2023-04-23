local cc_expect = require "cc.expect"
local field = cc_expect.field

local SETTINGS = require "lib.SETTINGS"
local ioutils = require "lib.ioutils"

---@class Craftable
---@field item table The raw Minecraft item table
---@field is_fluid boolean
local Craftable = {}
local Craftable_mt = { __metatable = {}, __index = Craftable }

---@param params { item: table, is_fluid: boolean }
function Craftable:new(params)
    local o = setmetatable({}, Craftable_mt)
    o.item = params.item
    o.is_fluid = field(params, "is_fluid", "boolean")
    return o
end

---@return string
function Craftable:name()
    return field(self.item, "name", "string")
end

---@return string
function Craftable:display_name()
    return self.item.displayName or self:name()
end

---@return { [string]: Craftable} | nil
local function load()
    local raw = ioutils.read_file(SETTINGS.craftables_cache_path())
    if not raw then
        return
    end

    local data = textutils.unserialize(raw)
    if not data then
        printError("Failed to parse craftables cache")
        return
    end

    for _, craftable in pairs(data) do
        setmetatable(craftable, Craftable_mt)
    end

    return data
end

---@return { [string]: Craftable } | nil
local function update(me_bridge)
    local data = {}
    for _, raw in ipairs(me_bridge.listCraftableItems() or {}) do
        data[field(raw, "name", "string")] = Craftable:new { item = raw, is_fluid = false }
    end
    for _, raw in ipairs(me_bridge.listCraftableFluid() or {}) do
        data[field(raw, "name", "string")] = Craftable:new { item = raw, is_fluid = true }
    end

    local path = SETTINGS.craftables_cache_path()
    local content = textutils.serialize(data, { allow_repetitions = true })
    if not ioutils.write_file(path, content) then
        return nil
    end
    return data
end

---@return { [string]: Craftable } | nil
local function get(me_bridge)
    local data = load()
    if not data then
        data = update(me_bridge)
    end
    return data
end

---@param craftables { [string]: Craftable }
---@return { [string]: Craftable }
local function pivot_by_display_name(craftables)
    local by_display_name = {}
    for _, craftable in pairs(craftables) do
        if by_display_name[craftable:display_name()] then
            printError("Duplicate craftable displayName in ME: " ..
                craftable:display_name() ..
                " (" .. craftable:name() .. ", " .. by_display_name[craftable:display_name()]:name() .. ")")
            printError("Using " .. craftable:name())
        end
        by_display_name[craftable:display_name()] = craftable
    end
    return by_display_name
end

return {
    get = get,
    pivot_by_display_name = pivot_by_display_name,
    update = update,
    Craftable = Craftable
}
