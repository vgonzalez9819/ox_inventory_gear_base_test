local gearData = {}

RegisterNetEvent('gear_system:toggle', function()
    SetNuiFocus(true, true)
    SendNUIMessage({ action = 'open', slots = Config.GearSlots, gear = gearData, ui = Config.UI })
end)

RegisterNetEvent('gear_system:loadGear')
AddEventHandler('gear_system:loadGear', function(data)
    gearData = data or {}
    SendNUIMessage({ action = 'update', gear = gearData })
end)

RegisterNetEvent('gear_system:updateGear')
AddEventHandler('gear_system:updateGear', function(data)
    gearData = data or {}
    SendNUIMessage({ action = 'update', gear = gearData })
end)

RegisterNUICallback('close', function(_, cb)
    SetNuiFocus(false, false)
    cb(true)
end)

RegisterNUICallback('equip', function(data, cb)
    TriggerServerEvent('gear_system:equipItem', data.from, data.to)
    cb(true)
end)

RegisterNUICallback('unequip', function(data, cb)
    TriggerServerEvent('gear_system:unequipItem', data.slot)
    cb(true)
end)

-- Request current gear on load
Citizen.CreateThread(function()
    Wait(1000)
    TriggerServerEvent('gear_system:requestGear')
end)

if Config.Features.gearCommand then
    RegisterCommand('gear', function()
        TriggerEvent('gear_system:toggle')
    end)
end
