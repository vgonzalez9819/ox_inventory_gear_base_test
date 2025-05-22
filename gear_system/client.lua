local gear = {}
local uiOpen = false

local function notify(msg)
    if lib and lib.notify then
        lib.notify({ description = msg })
    else
        TriggerEvent('chat:addMessage', { args = { msg } })
    end
end

local function toggleUI(state)
    SetNuiFocus(state, state)
    SetNuiFocusKeepInput(state)
    SendNUIMessage({ action = 'setVisible', state = state, slots = gear, config = Config })
    uiOpen = state
end

RegisterNUICallback('close', function(_, cb)
    toggleUI(false)
    cb(true)
end)

RegisterNUICallback('equipItem', function(data, cb)
    TriggerServerEvent('gear:serverEquip', data)
    cb(true)
end)

RegisterNUICallback('unequipItem', function(data, cb)
    TriggerServerEvent('gear:serverUnequip', data)
    cb(true)
end)

RegisterNetEvent('gear:clientUpdate', function(data)
    gear = data
    if uiOpen then
        SendNUIMessage({ action = 'update', slots = gear })
    end
end)

local function openCommand()
    if uiOpen then
        toggleUI(false)
    else
        TriggerServerEvent('gear:serverRequest')
        toggleUI(true)
    end
end

if Config.Features.commandAccess then
    RegisterCommand('gear', openCommand)
    if Config.DebugTools and Config.DebugTools.debugCommandEnabled then
        RegisterCommand('gearstatus', function()
            TriggerServerEvent('gear:serverStatus')
        end)
    end
    RegisterCommand('gearreset', function()
        TriggerServerEvent('gear:serverReset')
    end)
    RegisterCommand('gearreload', function()
        TriggerServerEvent('gear:serverReload')
    end, true)
end

RegisterNetEvent('ox_inventory:openInventory', function()
    if Config.Features.openWithInventory and not uiOpen then
        openCommand()
    end
end)

-- When resource starts, request gear if persist enabled
AddEventHandler('onClientResourceStart', function(res)
    if res == GetCurrentResourceName() and Config.Features.persistGear then
        TriggerServerEvent('gear:serverRequest')
    end
end)

RegisterNetEvent('gear:applyStats', function(stats)
    local ped = PlayerPedId()
    if stats.maxHealth then
        SetEntityMaxHealth(ped, 100 + stats.maxHealth)
    end
    if stats.maxArmor then
        SetPedArmour(ped, stats.maxArmor)
    end
end)
