local SETTINGS = {}

---@param key string
---@param definition { description: string, default: string, type: "string" }
---@return fun(): string
local function define_string(key, definition)
    settings.define(key, definition)
    return function()
        return settings.get(key)
    end
end

---@param key string
---@param definition { description: string, default: number, type: "number" }
---@return fun(): number
local function define_number(key, definition)
    settings.define(key, definition)
    return function()
        return settings.get(key)
    end
end

SETTINGS.keys = {
    requested_amounts_path = "meautocraft.requested_amounts_path",
    craftables_cache_path = "meautocraft.craftables_cache_path",
    monitor = "meautocraft.monitor",
    threshold = "meautocraft.threshold",
    interval = "meautocraft.interval",
}

SETTINGS.requested_amounts_path = define_string(SETTINGS.keys.requested_amounts_path,
    { description = "Path to the config file", default = "/meautocraft.data/requested_amounts", type = "string" })

SETTINGS.craftables_cache_path = define_string(SETTINGS.keys.craftables_cache_path,
    { description = "File path to cache of craftable items", default = "meautocraft.data/craftables", type = "string" })

SETTINGS.monitor = define_string(SETTINGS.keys.monitor,
    { description = "The monitor to use for the display", default = "right", type = "string" })

SETTINGS.threshold = define_number(SETTINGS.keys.threshold,
    { description = "Schedule crafting items if existingCount < wantedCount * threshold", default = 0.95, type = "number" })

SETTINGS.interval = define_number(SETTINGS.keys.interval,
    { description = "Interval between checks (seconds)", default = 3, type = "number" })

return SETTINGS
