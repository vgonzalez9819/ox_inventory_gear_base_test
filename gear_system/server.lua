local Inventory = require 'inventory_bridge'
local gearPlayers = {}

local function getFramework()
    if Config.Framework == 'esx' then return 'esx' end
    if Config.Framework == 'qbcore' then return 'qbcore' end
    if Config.Framework == 'auto' then
        if ESX then return 'esx' end
        if QBCore then return 'qbcore' end
    end
    return nil
end

local function getIdentifier(source)
    local fw = getFramework()
    if fw == 'esx' then
        local x = ESX.GetPlayerFromId(source)
        return x and x.identifier
    elseif fw == 'qbcore' then
        local p = QBCore.Functions.GetPlayer(source)
        return p and p.PlayerData.citizenid
    else
        local id = GetPlayerIdentifier(source, 0)
        return id
    end
end

local function saveGear(id, data)
    if not Config.Features.persistGear then return end
    if not id then return end
    SetResourceKvp('gear_' .. id, json.encode(data))
end

local function loadGear(id)
    if not Config.Features.persistGear then return {} end
    if not id then return {} end
    local data = GetResourceKvpString('gear_' .. id)
    return data and json.decode(data) or {}
end

local function calculateStats(gear)
    local totals = {}
    for slot,item in pairs(gear) do
        local def = Config.EquipmentItems[item]
        if def then
            local rarity = Config.RarityTiers[def.rarity]
            local mult = rarity and rarity.statMultiplier or 1.0
            for stat,info in pairs(def.stats) do
                local val = info.value * mult * (Config.StatScaling[stat] or 1.0)
                totals[stat] = (totals[stat] or 0) + val
            end
        end
    end
    return totals
end

local function applyStats(source, stats)
    if not Config.Features.allowStatEffects then return end
    TriggerClientEvent('gear:applyStats', source, stats)
end

local function sendUpdate(src)
    TriggerClientEvent('gear:clientUpdate', src, gearPlayers[src] or {})
    applyStats(src, calculateStats(gearPlayers[src] or {}))
end

AddEventHandler('playerDropped', function()
    local src = source
    local id = getIdentifier(src)
    if gearPlayers[src] then
        saveGear(id, gearPlayers[src])
        gearPlayers[src] = nil
    end
end)

AddEventHandler('playerJoining', function()
    local src = source
    local id = getIdentifier(src)
    gearPlayers[src] = loadGear(id)
end)

RegisterServerEvent('gear:serverRequest', function()
    local src = source
    if not gearPlayers[src] then
        local id = getIdentifier(src)
        gearPlayers[src] = loadGear(id)
    end
    sendUpdate(src)
end)

RegisterServerEvent('gear:serverEquip', function(data)
    local src = source
    local item = data.item
    local slot = data.slot
    local def = Config.EquipmentItems[item]
    if not def then
        if Config.DebugTools.showInvalidItems then
            print('[GearSystem] Invalid item: ' .. tostring(item))
        end
        return
    end
    if def.slot ~= slot then
        if Config.DebugTools.showInvalidSlots then
            print('[GearSystem] Item ' .. item .. ' does not fit slot ' .. slot)
        end
        return
    end
    if not gearPlayers[src] then gearPlayers[src] = {} end
    if gearPlayers[src][slot] then
        -- slot occupied
        Inventory.AddItem(src, gearPlayers[src][slot], 1)
    end
    if Inventory.RemoveItem(src, item, 1) then
        gearPlayers[src][slot] = item
        sendUpdate(src)
    else
        print('[GearSystem] Unable to remove item from inventory: ' .. item)
    end
end)

RegisterServerEvent('gear:serverUnequip', function(data)
    local src = source
    local slot = data.slot
    if gearPlayers[src] and gearPlayers[src][slot] then
        local item = gearPlayers[src][slot]
        if Inventory.AddItem(src, item, 1) then
            gearPlayers[src][slot] = nil
            sendUpdate(src)
        else
            print('[GearSystem] Unable to give item back: ' .. item)
        end
    end
end)

RegisterServerEvent('gear:serverReset', function()
    local src = source
    if gearPlayers[src] then
        for slot,item in pairs(gearPlayers[src]) do
            Inventory.AddItem(src, item, 1)
        end
    end
    gearPlayers[src] = {}
    sendUpdate(src)
end)

RegisterServerEvent('gear:serverReload', function()
    if IsPlayerAceAllowed(source, 'gearsystem.admin') then
        print('[GearSystem] Reloading config')
        dofile('config.lua')
    end
end)

RegisterServerEvent('gear:serverStatus', function()
    local src = source
    local stats = calculateStats(gearPlayers[src] or {})
    TriggerClientEvent('chat:addMessage', src, { args = { 'Gear Status: ' .. json.encode(stats) } })
end)
