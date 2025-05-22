local PlayerGear = {}

-- framework detection
if Config.Framework == 'auto' then
    if GetResourceState('qb-core') ~= 'missing' then
        Config.Framework = 'qbcore'
        QBCore = exports['qb-core']:GetCoreObject()
    elseif GetResourceState('es_extended') ~= 'missing' then
        Config.Framework = 'esx'
        ESX = exports['es_extended']:getSharedObject()
    else
        Config.Framework = 'standalone'
    end
elseif Config.Framework == 'qbcore' then
    QBCore = exports['qb-core']:GetCoreObject()
elseif Config.Framework == 'esx' then
    ESX = exports['es_extended']:getSharedObject()
else
    Config.Framework = 'standalone'
end

local function debugPrint(msg)
    if Config.DebugTools.verbose then
        print('[GearSystem] ' .. msg)
    end
end

RegisterNetEvent('gear_system:requestGear')
AddEventHandler('gear_system:requestGear', function()
    local src = source
    PlayerGear[src] = PlayerGear[src] or {}
    TriggerClientEvent('gear_system:loadGear', src, PlayerGear[src])
end)

RegisterNetEvent('gear_system:equipItem')
AddEventHandler('gear_system:equipItem', function(from, to)
    local src = source
    PlayerGear[src] = PlayerGear[src] or {}
    local item = PlayerGear[src][from]
    if item then
        PlayerGear[src][from] = nil
        PlayerGear[src][to] = item
        debugPrint(('Moved %s from %s to %s'):format(item, from, to))
    else
        debugPrint(('No item in %s to move'):format(from))
    end
    TriggerClientEvent('gear_system:updateGear', src, PlayerGear[src])
end)

RegisterNetEvent('gear_system:unequipItem')
AddEventHandler('gear_system:unequipItem', function(slot)
    local src = source
    PlayerGear[src] = PlayerGear[src] or {}
    PlayerGear[src][slot] = nil
    debugPrint(('Unequipped %s'):format(slot))
    TriggerClientEvent('gear_system:updateGear', src, PlayerGear[src])
end)

if Config.Features.gearCommand then
    RegisterCommand('gear', function(src)
        TriggerClientEvent('gear_system:toggle', src)
    end)
end

if Config.Features.gearStatusCommand then
    RegisterCommand('gearstatus', function(src)
        local gear = PlayerGear[src]
        print(('^5[GearSystem]^7 Player %s gear: %s'):format(src, json.encode(gear)))
    end)
end

if Config.DebugTools.allowGearReset then
    RegisterCommand('gearreset', function(src)
        PlayerGear[src] = {}
        TriggerClientEvent('gear_system:updateGear', src, PlayerGear[src])
    end)
end
