Config = {}

-- Framework selection: 'auto', 'esx', or 'qbcore'
-- When set to 'auto', the script will attempt to detect which
-- framework is running by checking common resources.
Config.Framework = 'auto'

-- If you use ox_inventory with ESX/QBCore set this to true to use its
-- add/remove item exports when equipping gear.
Config.UseOxInventory = true

-- Enable debug prints in the server/clientside consoles.
Config.Debug = false

-- UI position for the gear panel (CSS top/left in pixels)
Config.PanelPosition = {
    top = 200,
    left = 50
}

-- Gear slots available for players. Each entry defines the slot name,
-- the label displayed in the UI, and which inventory items are allowed
-- to be equipped in that slot.
Config.GearSlots = {
    helmet = { label = 'Helmet', allowedItems = { 'military_helmet', 'iron_helmet' } },
    chest = { label = 'Armor', allowedItems = { 'kevlar_vest', 'leather_armor' } },
    pants = { label = 'Pants', allowedItems = { 'combat_pants', 'jeans' } },
    gloves = { label = 'Gloves', allowedItems = { 'tactical_gloves' } },
    boots = { label = 'Boots', allowedItems = { 'army_boots', 'leather_boots' } },
    ring1 = { label = 'Ring (L)', allowedItems = { 'ring_of_fire', 'ring_of_life' } },
    ring2 = { label = 'Ring (R)', allowedItems = { 'ring_of_power' } },
    backpack = { label = 'Backpack', allowedItems = { 'hiking_pack', 'military_pack' } },
    weaponmod = { label = 'Weapon Mod', allowedItems = { 'laser_sight', 'scope_mod' } }
}

-- Stat bonuses granted by equipping items. All values are additive.
-- maxHealth and maxArmor modify the player's maximum health/armor.
-- critChance and critDamage increase critical hit stats.
-- damageFlat adds flat damage, damagePercent is a multiplier.
-- speedPercent increases running speed, staminaRecovery affects
-- regen rate, maxStamina increases stamina pool and meleeDamage
-- scales unarmed/melee damage.
Config.ItemStats = {
    military_helmet = {
        maxHealth = 20,
        critChance = 0.05,
        meleeDamage = 0.1
    },
    ring_of_fire = {
        damagePercent = 0.15,
        staminaRecovery = 5
    },
    kevlar_vest = {
        maxArmor = 50
    }
}

-- Scaling applied to stats before being given to the player.
-- Useful if your base numbers need adjusting without editing
-- each item individually.
Config.StatScaling = {
    maxHealth = 1.0,
    maxArmor = 1.0,
    critChance = 1.0,
    critDamage = 1.0,
    damageFlat = 1.0,
    damagePercent = 1.0,
    speedPercent = 1.0,
    staminaRecovery = 1.0,
    maxStamina = 1.0,
    meleeDamage = 1.0
}

-- Utility function for debug printing
function Debug(...)
    if Config.Debug then
        print('[GearSystem]', ...)
    end
end
