local Inventory = {}

function Inventory.RemoveItem(source, item, count, metadata)
    if Config.InventorySystem == 'ox' then
        return exports.ox_inventory:RemoveItem(source, item, count, metadata)
    elseif Config.InventorySystem == 'qb' then
        return exports['qb-inventory']:RemoveItem(source, item, count, metadata)
    end
    return false
end

function Inventory.AddItem(source, item, count, metadata)
    if Config.InventorySystem == 'ox' then
        return exports.ox_inventory:AddItem(source, item, count, metadata)
    elseif Config.InventorySystem == 'qb' then
        return exports['qb-inventory']:AddItem(source, item, count, metadata)
    end
    return false
end

return Inventory
