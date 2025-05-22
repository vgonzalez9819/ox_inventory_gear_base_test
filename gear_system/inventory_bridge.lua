-- Inventory bridge utility for gear_system

local function log(...)
    if Config.InventoryBridgeDebug then
        print('[InventoryBridge]', ...)
    end
end

function AddItemToPlayer(source, item, count)
    count = count or 1
    if Config.InventorySystem == 'ox' then
        log('using ox_inventory AddItem', source, item, count)
        return exports.ox_inventory:AddItem(source, item, count)
    elseif Config.InventorySystem == 'qb' then
        local Player = QBCore and QBCore.Functions.GetPlayer(source)
        if Player then
            log('using qb-inventory AddItem', source, item, count)
            return Player.Functions.AddItem(item, count)
        end
        return false
    else
        print('[InventoryBridge] Invalid Config.InventorySystem:', Config.InventorySystem)
        return false
    end
end

function RemoveItemFromPlayer(source, item, count)
    count = count or 1
    if Config.InventorySystem == 'ox' then
        log('using ox_inventory RemoveItem', source, item, count)
        return exports.ox_inventory:RemoveItem(source, item, count)
    elseif Config.InventorySystem == 'qb' then
        local Player = QBCore and QBCore.Functions.GetPlayer(source)
        if Player then
            local ok = Player.Functions.RemoveItem(item, count)
            log('using qb-inventory RemoveItem', source, item, count, ok)
            return ok
        end
        return false
    else
        print('[InventoryBridge] Invalid Config.InventorySystem:', Config.InventorySystem)
        return false
    end
end

function PlayerHasItem(source, item)
    if Config.InventorySystem == 'ox' then
        return (exports.ox_inventory:GetItemCount(source, item) or 0) > 0
    elseif Config.InventorySystem == 'qb' then
        local Player = QBCore and QBCore.Functions.GetPlayer(source)
        if Player then
            local it = Player.Functions.GetItemByName(item)
            return it and it.amount > 0
        end
        return false
    else
        print('[InventoryBridge] Invalid Config.InventorySystem:', Config.InventorySystem)
        return false
    end
end
