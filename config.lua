--[[
    ===================================================
     Vehicle Spawner v2.0
     Author: choda
     Standalone - no framework required
    ===================================================

    Everything below is meant to be edited freely by the
    server developer. Add/remove categories and vehicles,
    change the keybind, toggle permissions, etc.
]]

Config = {}

-- Default key that opens the menu. Players can still rebind it
-- themselves in FiveM Settings > Key Bindings > FiveM > "Open Vehicle Spawner Menu".
Config.OpenKey = 'F5'

-- If true, players must have the ace permission below to open the menu.
-- Grant it in server.cfg, e.g.:
--   add_ace group.admin vehiclespawner.use allow
--   add_principal identifier.license:xxxx group.admin
Config.UsePermissions = false
Config.Permission = 'vehiclespawner.use'

-- Behavior
Config.DeletePreviousVehicle = true    -- delete the last vehicle this player spawned when spawning a new one
Config.SpawnInVehicle = true           -- warp the player into the driver seat after spawning
Config.SpawnDistance = 3.0             -- distance in front of the player to spawn the vehicle
Config.SetPlate = false                -- give spawned vehicles a custom plate
Config.PlatePrefix = 'CHODA'           -- used only if SetPlate is true

Config.MenuTitle = 'Vehicle Spawner v2.0'

-- How long (ms) mythic_notify notifications stay on screen
Config.NotifyDuration = 5000

-- Categories and vehicles shown in the menu.
-- label = what's displayed, model = the spawn code (vehicle name/hash string).
-- Add or remove as many categories/vehicles as you want.
Config.Vehicles = {
    ['Sports'] = {
        { label = 'Adder',       model = 'adder' },
        { label = 'Zentorno',    model = 'zentorno' },
        { label = 'Entity XF',   model = 'entityxf' },
        { label = 'Cheetah',     model = 'cheetah' },
    },
    ['SUVs'] = {
        { label = 'Baller',      model = 'baller' },
        { label = 'Granger',     model = 'granger' },
        { label = 'Patriot',     model = 'patriot' },
    },
    ['Off-Road'] = {
        { label = 'Sandking',    model = 'sandking' },
        { label = 'Bifta',       model = 'bifta' },
        { label = 'Dune Buggy',  model = 'dune' },
    },
    ['Motorcycles'] = {
        { label = 'Akuma',       model = 'akuma' },
        { label = 'Bati 801',    model = 'bati' },
        { label = 'PCJ-600',     model = 'pcj' },
    },
    ['Aircraft'] = {
        { label = 'Buzzard',     model = 'buzzard2' },
        { label = 'Mammatus',    model = 'mammatus' },
        { label = 'Velum',       model = 'velum' },
    },
    ['Emergency'] = {
        { label = 'Police Cruiser', model = 'police' },
        { label = 'Ambulance',      model = 'ambulance' },
        { label = 'Fire Truck',     model = 'firetruk' },
    },
    ['Utility'] = {
        { label = 'Delete My Vehicle', model = 'delete' }, -- special entry, handled in client.lua
    },
}
