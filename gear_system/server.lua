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

local function giveItem(src, name)
    if Config.UseOxInventory then
        exports.ox_inventory:AddItem(src, name, 1)
    else
        local player = framework.getPlayer(src)
        if player then framework.addItem(player, name) end
    end
end

local function takeItem(src, name)
    if Config.UseOxInventory then
        return exports.ox_inventory:RemoveItem(src, name, 1)
    else
        local player = framework.getPlayer(src)
        if player then
            return framework.removeItem(player, name)
        end
    end
    return false
end

local function calculateStats(equipped)
    local stats = {}
    for slot, itemName in pairs(equipped) do
        local item = Config.EquipmentItems[itemName]
        if not item then
            if Config.DebugTools.showInvalidItems then
                Debug('Unknown item in slot '..slot..': '..tostring(itemName))
            end
        else
            local rarity = Config.RarityTiers[item.rarity] or {statMultiplier = 1.0}
            if Config.DebugTools.logItemLookup then
                Debug(('Slot %s item %s rarity %s'):format(slot, itemName, item.rarity or 'none'))
            end
            for stat, info in pairs(item.stats or {}) do
                local base = info.value or 0
                local scaled = base * rarity.statMultiplier * (Config.StatScaling[stat] or 1)
                stats[stat] = (stats[stat] or 0) + scaled
            end
        end
    end
    if Config.DebugTools.logStatCalculations then
        Debug('Calculated stats: '..json.encode(stats))
    end
    return stats
end

local function updatePlayerStats(src)
    local identifier = getIdentifier(src)
    if not identifier then return end

    local equipped = GearData[identifier] or {}
    local stats = calculateStats(equipped)
    PlayerStats[src] = stats

    local displayGear = {}
    for slot, itemName in pairs(equipped) do
        local item = Config.EquipmentItems[itemName]
        if item then
            local rarity = Config.RarityTiers[item.rarity]
            displayGear[slot] = {
                name = itemName,
                label = item.label,
                rarity = item.rarity,
                color = rarity and rarity.color or '#ffffff'
            }
        else
            displayGear[slot] = { name = itemName, label = itemName }
        end
    end

    TriggerClientEvent('gear_system:applyStats', src, stats)
    TriggerClientEvent('gear_system:setGear', src, displayGear)
    TriggerEvent('gear_system:statsUpdated', src, stats)
    if Config.DebugTools.printStatTotalsOnEquip then
        Debug(('Total stats for %s: %s'):format(src, json.encode(stats)))
    end
end

RegisterNetEvent('gear_system:equip', function(slot, item)
    local src = source
    if not Config.GearSlots[slot] then
        if Config.DebugTools.showInvalidSlots then
            Debug('Attempt to equip invalid slot '..tostring(slot))
        end
        return
    end
    if not item then return end

    local allowed = false
    for _, v in pairs(Config.GearSlots[slot].allowedItems) do
        if v == item then allowed = true break end
    end
    if not allowed then
        if Config.DebugTools.logItemLookup then
            Debug(('Item %s not allowed in slot %s'):format(item, slot))
        end
        return
    end

    local itemDef = Config.EquipmentItems[item]
    if not itemDef then
        if Config.DebugTools.showInvalidItems then
            Debug('Cannot equip undefined item '..tostring(item))
        end
        return
    end

    if not takeItem(src, item) then return end

    local identifier = getIdentifier(src)
    if not identifier then return end
    GearData[identifier] = GearData[identifier] or {}

    local old = GearData[identifier][slot]
    if old then
        giveItem(src, old)
    end

    GearData[identifier][slot] = item
    saveData()
    updatePlayerStats(src)
    if Config.DebugTools.notifyOnEquip then
        TriggerClientEvent('gear_system:notify', src, ('Equipped %s'):format(itemDef.label))
    end
end)

RegisterNetEvent('gear_system:unequip', function(slot)
    local src = source
    if not Config.GearSlots[slot] then
        if Config.DebugTools.showInvalidSlots then
            Debug('Attempt to unequip invalid slot '..tostring(slot))
        end
        return
    end
    local identifier = getIdentifier(src)
    if not identifier then return end

    local item = GearData[identifier] and GearData[identifier][slot]
    if item then
        giveItem(src, item)
        GearData[identifier][slot] = nil
        saveData()
        updatePlayerStats(src)
        if Config.DebugTools.notifyOnEquip then
            local itemDef = Config.EquipmentItems[item]
            local label = itemDef and itemDef.label or item
            TriggerClientEvent('gear_system:notify', src, ('Unequipped %s'):format(label))
        end
    end
end)

AddEventHandler('playerDropped', function()
    local src = source
    PlayerStats[src] = nil
end)

exports('GetPlayerStats', function(src)
    return PlayerStats[src] or {}
end)

-- Optional debug command to print current gear and stats
if Config.DebugTools.debugCommandEnabled then
    RegisterCommand('gearstatus', function(src)
        local identifier = getIdentifier(src)
        if not identifier then return end
        local gear = GearData[identifier] or {}
        local stats = PlayerStats[src] or calculateStats(gear)
        Debug(('Gear for %s: %s'):format(src, json.encode(gear)))
        Debug(('Stats for %s: %s'):format(src, json.encode(stats)))
        TriggerClientEvent('gear_system:notify', src, 'Check server console for gear status')
    end, false)

    RegisterCommand('gearreset', function(src)
        local identifier = getIdentifier(src)
        if not identifier then return end
        local current = GearData[identifier]
        if not current then return end
        for slot, item in pairs(current) do
            giveItem(src, item)
            current[slot] = nil
        end
        saveData()
        updatePlayerStats(src)
        TriggerClientEvent('gear_system:notify', src, 'All gear unequipped')
    end, false)
end

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
