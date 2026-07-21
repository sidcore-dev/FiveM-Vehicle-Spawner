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

-- Master switch for the permission system. If false, every category is
-- open to everyone and the per-category `permission` fields below are ignored.
-- If true, a category is restricted only when it has a `permission` set;
-- categories with no `permission` field stay open to everyone.
--
-- Grant a category's permission in server.cfg, e.g.:
--   add_ace group.admin vehiclespawner.emergency allow
--   add_principal identifier.license:xxxx group.admin
Config.UsePermissions = false

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
--
-- Each category is a table with:
--   permission = optional ace permission string. Only checked when
--                Config.UsePermissions is true. Leave nil (or omit it)
--                to keep the category open to everyone.
--   vehicles   = list of { label, model } entries.
--                label = what's displayed, model = the spawn code (vehicle name/hash string).
--
-- Add, remove, or rename as many categories/vehicles as you want — new
-- categories are picked up automatically, no other code changes needed.
Config.Vehicles = {
    ['Sports'] = {
        permission = nil, -- open to everyone
        vehicles = {
            { label = 'Adder',       model = 'adder' },
            { label = 'Zentorno',    model = 'zentorno' },
            { label = 'Entity XF',   model = 'entityxf' },
            { label = 'Cheetah',     model = 'cheetah' },
        },
    },
    ['SUVs'] = {
        permission = nil,
        vehicles = {
            { label = 'Baller',      model = 'baller' },
            { label = 'Granger',     model = 'granger' },
            { label = 'Patriot',     model = 'patriot' },
        },
    },
    ['Off-Road'] = {
        permission = nil,
        vehicles = {
            { label = 'Sandking',    model = 'sandking' },
            { label = 'Bifta',       model = 'bifta' },
            { label = 'Dune Buggy',  model = 'dune' },
        },
    },
    ['Motorcycles'] = {
        permission = nil,
        vehicles = {
            { label = 'Akuma',       model = 'akuma' },
            { label = 'Bati 801',    model = 'bati' },
            { label = 'PCJ-600',     model = 'pcj' },
        },
    },
    ['Aircraft'] = {
        permission = nil,
        vehicles = {
            { label = 'Buzzard',     model = 'buzzard2' },
            { label = 'Mammatus',    model = 'mammatus' },
            { label = 'Velum',       model = 'velum' },
        },
    },
    ['Emergency'] = {
        -- Example of a restricted category: only checked if Config.UsePermissions = true.
        -- Grant with: add_ace group.police vehiclespawner.emergency allow
        permission = 'vehiclespawner.emergency',
        vehicles = {
            { label = 'Police Cruiser', model = 'police' },
            { label = 'Ambulance',      model = 'ambulance' },
            { label = 'Fire Truck',     model = 'firetruk' },
        },
    },
    ['Utility'] = {
        permission = nil,
        vehicles = {
            { label = 'Delete My Vehicle', model = 'delete' }, -- special entry, handled in client.lua
        },
    },
}
