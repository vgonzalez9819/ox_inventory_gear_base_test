local PlayerData = {}
local equipped = {}

local function applyStats(stats)
    -- Example stat application. You can expand this to handle more.
    if stats.maxHealth then
        local ped = PlayerPedId()
        local base = GetEntityMaxHealth(ped)
        local new = 200 + stats.maxHealth -- default max health is 200
        if new ~= base then
            SetEntityMaxHealth(ped, new)
            if GetEntityHealth(ped) > new then
                SetEntityHealth(ped, new)
            end
        end
    end

    if stats.maxArmor then
        local ped = PlayerPedId()
        SetPedArmour(ped, math.min(100, stats.maxArmor))
    end
end

RegisterNetEvent('gear_system:applyStats', function(stats)
    applyStats(stats)
end)

RegisterNetEvent('gear_system:setGear', function(data)
    equipped = data
    SendNUIMessage({action = 'setGear', gear = data, slots = Config.GearSlots})
end)

RegisterNetEvent('gear_system:slotLocked', function(slot, info)
    if uiOpen then
        SendNUIMessage({action = 'slotLocked', slot = slot, info = info})
    end
end)

local uiOpen = false

local function toggleUI(state)
    uiOpen = state
    SetNuiFocus(state, state)
    SendNUIMessage({
        action = state and 'open' or 'close',
        gear = equipped,
        slots = Config.GearSlots,
        pos = (Config.UI and Config.UI.panelPosition) or Config.PanelPosition,
        ui = Config.UI,
        stats = Config.ItemStats
    })
end

RegisterNUICallback('equip', function(data, cb)
    TriggerServerEvent('gear_system:equip', data.slot, data.item)
    cb(true)
end)

RegisterNUICallback('unequip', function(data, cb)
    TriggerServerEvent('gear_system:unequip', data.slot)
    cb(true)
end)

RegisterNUICallback('close', function(_, cb)
    toggleUI(false)
    cb(true)
end)

RegisterNUICallback('button', function(_, cb)
    toggleUI(not uiOpen)
    cb(true)
end)

RegisterCommand('gear', function()
    toggleUI(true)
end)

AddEventHandler('onResourceStop', function(res)
    if res == GetCurrentResourceName() and uiOpen then
        SetNuiFocus(false, false)
    end
end)

RegisterNetEvent('ox_inventory:openInventory', function()
    toggleUI(true)
end)

RegisterNetEvent('ox_inventory:closeInventory', function()
    toggleUI(false)
end)
