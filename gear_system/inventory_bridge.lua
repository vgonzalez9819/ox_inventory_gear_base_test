local InventoryBridge = {}

function AddItemToPlayer(source, item, amount)
    if Config.InventorySystem == 'ox' then
        exports.ox_inventory:AddItem(source, item, amount)
    elseif Config.InventorySystem == 'qb' then
        local Player = QBCore and QBCore.Functions.GetPlayer(source)
        if Player then Player.Functions.AddItem(item, amount) end
    end
end

function RemoveItemFromPlayer(source, item, amount)
    if Config.InventorySystem == 'ox' then
        exports.ox_inventory:RemoveItem(source, item, amount)
    elseif Config.InventorySystem == 'qb' then
        local Player = QBCore and QBCore.Functions.GetPlayer(source)
        if Player then Player.Functions.RemoveItem(item, amount) end
    end
end

function PlayerHasItem(source, item)
    if Config.InventorySystem == 'ox' then
        return exports.ox_inventory:Search(source, 'count', item) > 0
    elseif Config.InventorySystem == 'qb' then
        local Player = QBCore and QBCore.Functions.GetPlayer(source)
        if Player then
            local count = Player.Functions.GetItemByName(item)
            return count ~= nil
        end
    end
    return false
end

return InventoryBridge
