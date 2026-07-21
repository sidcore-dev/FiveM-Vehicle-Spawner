--[[
    Vehicle Spawner v2.0
    Author: choda
]]

-- Returns the list of category names this player is allowed to see,
-- honoring each category's optional per-category `permission` field.
local function GetAllowedCategories(src)
    local allowed = {}

    for category, data in pairs(Config.Vehicles) do
        if not Config.UsePermissions or not data.permission or IsPlayerAceAllowed(src, data.permission) then
            allowed[#allowed + 1] = category
        end
    end

    table.sort(allowed)
    return allowed
end

RegisterNetEvent('vehiclespawner:requestOpen', function()
    local src = source
    local allowedCategories = GetAllowedCategories(src)

    if #allowedCategories == 0 then
        TriggerClientEvent('vehiclespawner:notify', src, 'You do not have permission to use the vehicle spawner.', 'error')
        return
    end

    TriggerClientEvent('vehiclespawner:openMenu', src, allowedCategories)
end)
