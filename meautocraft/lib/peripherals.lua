local SETTINGS = require "lib.SETTINGS"

---@return unknown
-- "unknown" because I can't find type definitions for Advanced Peripherals
local function me_bridge()
    ---@diagnostic disable-next-line: param-type-mismatch
    local p = peripheral.find("meBridge", function() return true end)
    if not p then
        printError("Could not find an attached ME Bridge")
    end
    return p
end

---@return Monitor|nil
local function monitor()
    ---@type Monitor[]
    local ms = peripheral.find("monitor", function() return true end)
    if not ms then
        printError("Could not find any attached monitors")
        return nil
    end
    if #ms == 1 then
        return ms[1]
    end

    local m = peripheral.wrap(SETTINGS.monitor())
    if not m then
        printError("Found multiple monitors, but no monitor on side " .. SETTINGS.monitor())
        printError("Set the " .. SETTINGS.keys.monitor .. " setting to the side of the monitor.")
        printError("For example, if the monitor is on the back of the computer, run:")
        printError("set " .. SETTINGS.keys.monitor .. " back")
        return nil
    end

    if not peripheral.hasType(m, "monitor") then
        printError("Found multiple monitors, so tried to use " ..
            SETTINGS.monitor() .. " as configured, but it's not a monitor.")
        printError("Set the " .. SETTINGS.keys.monitor .. " setting to the side of the monitor.")
        printError("For example, if the monitor is on the back of the computer, run:")
        printError("set " .. SETTINGS.keys.monitor .. " back")
        return nil
    end

    ---@diagnostic disable-next-line: return-type-mismatch
    return m
end

return {
    me_bridge = me_bridge,
    monitor = monitor,
}
