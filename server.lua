--[[
    Vehicle Spawner v2.0
    Author: choda
]]

RegisterNetEvent('vehiclespawner:requestOpen', function()
    local src = source

    if not Config.UsePermissions then
        TriggerClientEvent('vehiclespawner:openMenu', src)
        return
    end

    if IsPlayerAceAllowed(src, Config.Permission) then
        TriggerClientEvent('vehiclespawner:openMenu', src)
    else
        TriggerClientEvent('vehiclespawner:notify', src, 'You do not have permission to use the vehicle spawner.', 'error')
    end
end)
