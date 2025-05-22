Config = {}

--[[
==========================================================
 FiveM Gear System - Configuration File
==========================================================

This file controls every aspect of the equipment script. All
options include sane defaults so you can simply edit what you
need. If you update from an older version, any new fields are
optional.

==========================================================
]]

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
-- UI related options. If you previously used PanelPosition,
-- you can still keep it as-is; panelPosition is preferred.
Config.UI = Config.UI or {}

-- Where the equipment panel appears on screen (pixels).
Config.UI.panelPosition = Config.UI.panelPosition or {
    top = 200,
    left = 50
}
-- Backwards compatibility
Config.PanelPosition = Config.UI.panelPosition

-- When hovering an item show its stats in a small popup.
Config.UI.hoverPreview = Config.UI.hoverPreview or {
    enabled = true,
    background = '#111',
    textColor = '#fff',
    position = 'right' -- 'right' or 'below'
}

-- Slot animation after equipping an item.
Config.UI.equipAnimation = Config.UI.equipAnimation or {
    enabled = true,
    type = 'pulse', -- 'none', 'pulse', 'glow', 'slide'
    color = '#00ff88',
    duration = 300
}

-- Sounds played when equipping or removing items.
Config.UI.sounds = Config.UI.sounds or {
    onEquip = 'gear_equip.wav',
    onUnequip = 'gear_unequip.wav',
    volume = 0.3
}

-- Preview stat changes while dragging an item over a slot.
Config.UI.dragPreview = Config.UI.dragPreview or {
    enabled = true,
    showStatDifference = true
}

-- Tooltip text when a slot is locked by level or job.
Config.UI.lockedSlotTooltip = Config.UI.lockedSlotTooltip or {
    enabled = true,
    text = 'Requires level {{level}} or job: {{job}}'
}

-- Small stats bar at the bottom of the panel.
Config.UI.statOverlay = Config.UI.statOverlay or {
    enabled = true,
    style = 'minimal', -- 'minimal', 'detailed', 'icons'
    showStats = { 'maxHealth', 'maxArmor', 'flatDamage', 'critChance' }
}

-- Mobile friendly button for toggling the gear panel.
Config.UI.toggleButton = Config.UI.toggleButton or {
    enabled = true,
    icon = '🛡️',
    position = { bottom = 30, left = 20 }
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
    weaponmod = {
        label = 'Weapon Mod',
        allowedItems = { 'laser_sight', 'scope_mod' },
        locked = true,               -- Example locked slot
        requiredLevel = 5,           -- Minimum player level
        requiredJob = 'police'       -- Allowed job
    }
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
    },
    boots_of_speed = {
        speedPercent = 0.1,
        maxStamina = 10
    },
    ring_of_might = {
        damageFlat = 5,
        critDamage = 0.2
    },
    berserker_gloves = {
        meleeDamage = 0.2
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
