--[[
Inventory Bridge
Handles giving, removing and checking items for supported inventory systems.
Currently supports 'ox' (ox_inventory) and 'qb' (qb-inventory).
]]

local function warnInvalid()
    print(('^1[GearSystem] Invalid Config.InventorySystem: %s^0'):format(tostring(Config.InventorySystem)))
end

function AddItemToPlayer(src, item, count)
    count = count or 1
    if Config.InventorySystem == 'ox' then
        return exports.ox_inventory:AddItem(src, item, count)
    elseif Config.InventorySystem == 'qb' then
        local QBCore = exports['qb-core']:GetCoreObject()
        local Player = QBCore.Functions.GetPlayer(src)
        if Player then
            return Player.Functions.AddItem(item, count)
        end
    else
        warnInvalid()
    end
end

function RemoveItemFromPlayer(src, item, count)
    count = count or 1
    if Config.InventorySystem == 'ox' then
        return exports.ox_inventory:RemoveItem(src, item, count)
    elseif Config.InventorySystem == 'qb' then
        local QBCore = exports['qb-core']:GetCoreObject()
        local Player = QBCore.Functions.GetPlayer(src)
        if Player then
            return Player.Functions.RemoveItem(item, count)
        end
    else
        warnInvalid()
    end
    return false
end

function PlayerHasItem(src, item)
    if Config.InventorySystem == 'ox' then
        return exports.ox_inventory:Search(src, 'count', item) > 0
    elseif Config.InventorySystem == 'qb' then
        local QBCore = exports['qb-core']:GetCoreObject()
        local Player = QBCore.Functions.GetPlayer(src)
        if Player then
            local itm = Player.Functions.GetItemByName(item)
            return itm and itm.amount > 0
        end
    else
        warnInvalid()
    end
    return false
end

