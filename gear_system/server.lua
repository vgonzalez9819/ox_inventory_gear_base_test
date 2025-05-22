local GearData = {}
local PlayerStats = {}
local framework = {}

local function loadData()
    local data = LoadResourceFile(GetCurrentResourceName(), 'gear_data.json')
    if data then
        GearData = json.decode(data)
    end
end

local function saveData()
    SaveResourceFile(GetCurrentResourceName(), 'gear_data.json', json.encode(GearData), -1)
end

local function detectFramework()
    if Config.Framework ~= 'auto' then return Config.Framework end
    if GetResourceState('es_extended') ~= 'missing' then return 'esx' end
    if GetResourceState('qb-core') ~= 'missing' then return 'qbcore' end
    return nil
end

local function initFramework()
    framework.name = detectFramework()
    if framework.name == 'esx' then
        framework.obj = exports['es_extended']:getSharedObject()
        framework.getPlayer = function(src) return framework.obj.GetPlayerFromId(src) end
        framework.identifier = function(player) return player.identifier end
        framework.addItem = function(player, name)
            player.addInventoryItem(name, 1)
        end
        framework.removeItem = function(player, name)
            local item = player.getInventoryItem(name)
            if item.count < 1 then return false end
            player.removeInventoryItem(name, 1)
            return true
        end
    elseif framework.name == 'qbcore' then
        framework.obj = exports['qb-core']:GetCoreObject()
        framework.getPlayer = function(src) return framework.obj.Functions.GetPlayer(src) end
        framework.identifier = function(player) return player.PlayerData.citizenid end
        framework.addItem = function(player, name)
            player.Functions.AddItem(name, 1)
        end
        framework.removeItem = function(player, name)
            local item = player.Functions.GetItemByName(name)
            if not item or item.amount < 1 then return false end
            player.Functions.RemoveItem(name, 1)
            return true
        end
    end
end

local function getIdentifier(src)
    local player = framework.getPlayer(src)
    if not player then return nil end
    return framework.identifier(player)
end


local function calculateStats(equipped)
    local stats = {}
    for slot, itemName in pairs(equipped) do
        local item = Config.EquipmentItems[itemName]
        if item and item.stats then
            local rarity = Config.RarityTiers[item.rarity] or { statMultiplier = 1.0 }
            for stat, data in pairs(item.stats) do
                local val = (data.value or 0) * (rarity.statMultiplier or 1)
                val = val * (Config.StatScaling[stat] or 1)
                stats[stat] = (stats[stat] or 0) + val
            end
        end
    end
    return stats
end

local function updatePlayerStats(src)
    local identifier = getIdentifier(src)
    if not identifier then return end

    local equipped = GearData[identifier] or {}
    local stats = calculateStats(equipped)
    PlayerStats[src] = stats
    TriggerClientEvent('gear_system:applyStats', src, stats)
    TriggerClientEvent('gear_system:setGear', src, equipped)
    TriggerEvent('gear_system:statsUpdated', src, stats)
end

RegisterNetEvent('gear_system:equip', function(slot, item)
    local src = source
    if not Config.GearSlots[slot] then return end
    if not item then return end

    local def = Config.EquipmentItems[item]
    if not def or def.slot ~= slot then
        if Config.DebugTools and Config.DebugTools.showInvalidItems then
            Debug('Invalid item equip attempt:', slot, item)
        end
        return
    end

    if not RemoveItemFromPlayer(src, item, 1) then return end

    local identifier = getIdentifier(src)
    if not identifier then return end
    GearData[identifier] = GearData[identifier] or {}

    local old = GearData[identifier][slot]
    if old then
        AddItemToPlayer(src, old, 1)
    end

    GearData[identifier][slot] = item
    saveData()
    updatePlayerStats(src)
end)

RegisterNetEvent('gear_system:unequip', function(slot)
    local src = source
    if not Config.GearSlots[slot] then return end
    local identifier = getIdentifier(src)
    if not identifier then return end

    local item = GearData[identifier] and GearData[identifier][slot]
    if item then
        AddItemToPlayer(src, item, 1)
        GearData[identifier][slot] = nil
        saveData()
        updatePlayerStats(src)
    end
end)

AddEventHandler('playerDropped', function()
    local src = source
    PlayerStats[src] = nil
end)

exports('GetPlayerStats', function(src)
    return PlayerStats[src] or {}
end)

AddEventHandler('onResourceStart', function(res)
    if res ~= GetCurrentResourceName() then return end
    initFramework()
    loadData()
end)

AddEventHandler('onResourceStop', function(res)
    if res ~= GetCurrentResourceName() then return end
    saveData()
end)

-- framework player loaded events
RegisterNetEvent('esx:playerLoaded', function(id)
    if framework.name ~= 'esx' then return end
    local src = id or source
    updatePlayerStats(src)
end)

RegisterNetEvent('QBCore:Server:PlayerLoaded', function(id)
    if framework.name ~= 'qbcore' then return end
    local src = id or source
    updatePlayerStats(src)
end)
