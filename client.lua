--[[
    Vehicle Spawner v2.0
    Author: choda
]]

local menuOpen = false
local currentView = 'categories' -- 'categories' or 'vehicles'
local selectedIndex = 1
local selectedCategory = nil
local lastVehicle = nil

-- ===================== Helpers =====================

local function ShowNotification(msg, notifyType)
    exports['mythic_notify']:SendAlert(notifyType or 'inform', msg, Config.NotifyDuration)
end

local function DrawText2D(x, y, text, scale, r, g, b, a, centered)
    SetTextFont(4)
    SetTextScale(scale, scale)
    SetTextColour(r, g, b, a)
    SetTextOutline()
    SetTextEntry('STRING')
    AddTextComponentString(text)
    SetTextCentre(centered or false)
    DrawText(x, y)
end

local function DrawRect2D(x, y, w, h, r, g, b, a)
    DrawRect(x, y, w, h, r, g, b, a)
end

-- ===================== Vehicle Spawning =====================

local function SpawnVehicle(model)
    local hash = GetHashKey(model)

    if not IsModelInCdimage(hash) or not IsModelAVehicle(hash) then
        ShowNotification('Invalid vehicle model: ' .. model, 'error')
        return
    end

    RequestModel(hash)
    local timeout = 0
    while not HasModelLoaded(hash) and timeout < 5000 do
        Wait(10)
        timeout = timeout + 10
    end

    if not HasModelLoaded(hash) then
        ShowNotification('Failed to load vehicle model: ' .. model, 'error')
        return
    end

    if Config.DeletePreviousVehicle and lastVehicle and DoesEntityExist(lastVehicle) then
        DeleteEntity(lastVehicle)
        lastVehicle = nil
    end

    local ped = PlayerPedId()
    local coords = GetEntityCoords(ped)
    local heading = GetEntityHeading(ped)
    local fwd = GetEntityForwardVector(ped)
    local spawnPos = vector3(
        coords.x + fwd.x * Config.SpawnDistance,
        coords.y + fwd.y * Config.SpawnDistance,
        coords.z
    )

    local veh = CreateVehicle(hash, spawnPos.x, spawnPos.y, spawnPos.z, heading, true, false)
    SetEntityAsMissionEntity(veh, true, true)
    SetVehicleOnGroundProperly(veh)
    SetVehicleHasBeenOwnedByPlayer(veh, true)
    SetVehicleNeedsToBeHotwired(veh, false)
    SetVehicleDoorsLocked(veh, 1)

    if Config.SetPlate then
        SetVehicleNumberPlateText(veh, Config.PlatePrefix .. tostring(math.random(1000, 9999)))
    end

    if Config.SpawnInVehicle then
        TaskWarpPedIntoVehicle(ped, veh, -1)
    end

    lastVehicle = veh
    SetModelAsNoLongerNeeded(hash)
    ShowNotification('Vehicle spawned: ' .. model, 'success')
end

local function DeleteCurrentVehicle()
    local ped = PlayerPedId()
    local veh = GetVehiclePedIsIn(ped, false)

    if veh ~= 0 then
        DeleteEntity(veh)
        ShowNotification('Vehicle deleted.', 'success')
    elseif lastVehicle and DoesEntityExist(lastVehicle) then
        DeleteEntity(lastVehicle)
        lastVehicle = nil
        ShowNotification('Vehicle deleted.', 'success')
    else
        ShowNotification('No vehicle to delete.', 'error')
    end
end

-- ===================== Menu =====================

local function OpenMenu()
    menuOpen = true
    currentView = 'categories'
    selectedIndex = 1
end

local function CloseMenu()
    menuOpen = false
end

local function GetCategoryList()
    local list = {}
    for category, _ in pairs(Config.Vehicles) do
        list[#list + 1] = category
    end
    table.sort(list)
    return list
end

local function GetVehicleList(category)
    local list = {}
    for _, v in ipairs(Config.Vehicles[category]) do
        list[#list + 1] = v.label
    end
    return list
end

local function RenderMenu()
    local x = 0.85
    local startY = 0.30
    local rowHeight = 0.032
    local width = 0.20

    local entries = (currentView == 'categories') and GetCategoryList() or GetVehicleList(selectedCategory)

    DrawRect2D(x, startY - 0.028, width + 0.02, 0.045, 10, 10, 10, 210)
    DrawText2D(x, startY - 0.043, Config.MenuTitle, 0.38, 255, 255, 255, 255, true)

    for i, label in ipairs(entries) do
        local y = startY + (i - 1) * rowHeight
        local r, g, b = 255, 255, 255
        if i == selectedIndex then
            DrawRect2D(x, y, width + 0.02, rowHeight - 0.002, 255, 255, 255, 130)
            r, g, b = 0, 0, 0
        else
            DrawRect2D(x, y, width + 0.02, rowHeight - 0.002, 20, 20, 20, 170)
        end
        DrawText2D(x, y - 0.011, label, 0.3, r, g, b, 255, true)
    end

    DrawText2D(x, startY + (#entries * rowHeight) + 0.012, '~g~ENTER~s~ Select    ~r~BACKSPACE~s~ Back/Close', 0.26, 255, 255, 255, 255, true)

    return entries
end

local function HandleSelect(entries)
    local label = entries[selectedIndex]
    if not label then return end

    if currentView == 'categories' then
        selectedCategory = label
        currentView = 'vehicles'
        selectedIndex = 1
    else
        local vehData = nil
        for _, v in ipairs(Config.Vehicles[selectedCategory]) do
            if v.label == label then
                vehData = v
                break
            end
        end

        if vehData then
            if vehData.model == 'delete' then
                DeleteCurrentVehicle()
            else
                SpawnVehicle(vehData.model)
            end
        end

        CloseMenu()
    end
end

local function HandleBack()
    if currentView == 'vehicles' then
        currentView = 'categories'
        selectedIndex = 1
    else
        CloseMenu()
    end
end

-- ===================== Input / Open Command =====================

RegisterKeyMapping('vehiclespawner', 'Open Vehicle Spawner Menu', 'keyboard', Config.OpenKey)

RegisterCommand('vehiclespawner', function()
    if menuOpen then
        CloseMenu()
        return
    end
    TriggerServerEvent('vehiclespawner:requestOpen')
end, false)

RegisterNetEvent('vehiclespawner:openMenu', function()
    OpenMenu()
end)

RegisterNetEvent('vehiclespawner:notify', function(msg, notifyType)
    ShowNotification(msg, notifyType)
end)

-- Frontend controls (up/down/accept/cancel) used to drive the menu
local CONTROL_UP = 172
local CONTROL_DOWN = 173
local CONTROL_ACCEPT = 176
local CONTROL_CANCEL = 177

CreateThread(function()
    while true do
        if menuOpen then
            DisableControlAction(0, CONTROL_UP, true)
            DisableControlAction(0, CONTROL_DOWN, true)
            DisableControlAction(0, CONTROL_ACCEPT, true)
            DisableControlAction(0, CONTROL_CANCEL, true)

            local entries = RenderMenu()

            if IsDisabledControlJustPressed(0, CONTROL_UP) then
                selectedIndex = selectedIndex - 1
                if selectedIndex < 1 then selectedIndex = #entries end
            elseif IsDisabledControlJustPressed(0, CONTROL_DOWN) then
                selectedIndex = selectedIndex + 1
                if selectedIndex > #entries then selectedIndex = 1 end
            elseif IsDisabledControlJustPressed(0, CONTROL_ACCEPT) then
                HandleSelect(entries)
            elseif IsDisabledControlJustPressed(0, CONTROL_CANCEL) then
                HandleBack()
            end

            Wait(0)
        else
            Wait(200)
        end
    end
end)

CreateThread(function()
    print('^2[vehiclespawner]^7 Vehicle Spawner v2.0 by ^3choda^7 loaded. Default key: ' .. Config.OpenKey)
end)
