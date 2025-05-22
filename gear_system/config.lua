--[[
==========================================================
 FiveM Equipment Gear System - Configuration File
==========================================================

This file controls every aspect of the gear system. Each
section is fully documented so you can customise behaviour
without touching any Lua code.
==========================================================
]]

Config = {}

-- Framework selection: 'auto', 'esx', 'qbcore' or 'none'.
-- When set to 'auto' the script will attempt to detect
-- ESX or QBCore automatically.
Config.Framework = 'auto'

-- Inventory system used to give and remove items.
-- 'ox' = ox_inventory (recommended)
-- 'qb' = qb-inventory
Config.InventorySystem = 'ox'

-- Print which inventory bridge is used when moving items
-- between inventory and gear slots.
Config.InventoryBridgeDebug = false

-- Enable general debug prints to console.
Config.Debug = false

---------------------------------------------------------------------
-- GEAR SLOTS
---------------------------------------------------------------------
-- Define the available equipment slots. The order here will be the
-- order shown in the UI. Set showInUI to false if you wish to hide
-- a slot from the gear panel.
Config.GearSlots = {
    head     = { label = 'Head',     allowMultiple = false, showInUI = true },
    chest    = { label = 'Chest',    allowMultiple = false, showInUI = true },
    legs     = { label = 'Legs',     allowMultiple = false, showInUI = true },
    feet     = { label = 'Feet',     allowMultiple = false, showInUI = true },
    hands    = { label = 'Hands',    allowMultiple = false, showInUI = true },
    neck     = { label = 'Neck',     allowMultiple = false, showInUI = true },
    ring1    = { label = 'Ring 1',   allowMultiple = false, showInUI = true },
    ring2    = { label = 'Ring 2',   allowMultiple = false, showInUI = true },
    trinket1 = { label = 'Trinket',  allowMultiple = false, showInUI = true },
    trinket2 = { label = 'Trinket 2',allowMultiple = false, showInUI = true }
}

---------------------------------------------------------------------
-- EQUIPMENT ITEMS
---------------------------------------------------------------------
-- Each item here represents an inventory item that can be equipped.
-- slot  : Which gear slot it fits into
-- label : Display name in the UI
-- rarity: One of the keys defined in Config.RarityTiers
-- stats : Table of stat bonuses granted when equipped
Config.EquipmentItems = {
    military_helmet = {
        slot = 'head',
        label = 'Military Helmet',
        rarity = 'uncommon',
        stats = {
            maxHealth  = { type = 'flat',    value = 25 },
            critChance = { type = 'percent', value = 0.10 }
        }
    },

    ring_of_fire = {
        slot = 'ring1',
        label = 'Ring of Fire',
        rarity = 'rare',
        stats = {
            damagePercent   = { type = 'percent', value = 0.15 },
            staminaRecovery = { type = 'flat',    value = 5 }
        }
    },

    kevlar_vest = {
        slot = 'chest',
        label = 'Kevlar Vest',
        rarity = 'common',
        stats = {
            maxArmor = { type = 'flat', value = 50 }
        }
    },

    iron_greaves = {
        slot = 'legs',
        label = 'Iron Greaves',
        rarity = 'uncommon',
        stats = {
            maxStamina = { type = 'flat', value = 20 }
        }
    },

    ring_of_shadows = {
        slot = 'ring2',
        label = 'Ring of Shadows',
        rarity = 'epic',
        stats = {
            critChance = { type = 'percent', value = 0.12 },
            critDamage = { type = 'percent', value = 0.30 }
        }
    },

    trinket_mystic_core = {
        slot = 'trinket1',
        label = 'Mystic Core',
        rarity = 'rare',
        stats = {
            meleeDamage = { type = 'percent', value = 0.15 },
            flatDamage  = { type = 'flat',    value = 3 }
        }
    },

    silver_amulet = {
        slot = 'neck',
        label = 'Silver Amulet',
        rarity = 'uncommon',
        stats = {
            speedPercent = { type = 'percent', value = 0.08 }
        }
    },

    leather_boots = {
        slot = 'feet',
        label = 'Leather Boots',
        rarity = 'common',
        stats = {
            speedPercent    = { type = 'percent', value = 0.03 },
            staminaRecovery = { type = 'flat',    value = 2 }
        }
    },

    powered_gloves = {
        slot = 'hands',
        label = 'Powered Gloves',
        rarity = 'epic',
        stats = {
            meleeDamage     = { type = 'percent', value = 0.25 },
            staminaRecovery = { type = 'flat',    value = 4 }
        }
    },

    ember_trinket = {
        slot = 'trinket2',
        label = 'Ember Trinket',
        rarity = 'legendary',
        stats = {
            damagePercent = { type = 'percent', value = 0.25 },
            critDamage    = { type = 'percent', value = 0.35 }
        }
    }
}

---------------------------------------------------------------------
-- RARITY TIERS
---------------------------------------------------------------------
-- Rarity tiers modify item colouring in the UI and provide a
-- multiplier applied to the item's stats.
Config.RarityTiers = {
    common = {
        label = 'Common',
        color = '#808080',    -- grey
        statMultiplier = 1.0
    },
    uncommon = {
        label = 'Uncommon',
        color = '#00ff00',    -- green
        statMultiplier = 1.1
    },
    rare = {
        label = 'Rare',
        color = '#007bff',    -- blue
        statMultiplier = 1.25
    },
    epic = {
        label = 'Epic',
        color = '#a64ca6',    -- purple
        statMultiplier = 1.4
    },
    legendary = {
        label = 'Legendary',
        color = '#ff4444',    -- red
        statMultiplier = 1.6
    }
}

---------------------------------------------------------------------
-- UI SETTINGS
---------------------------------------------------------------------
Config.UI = {
    backgroundColor = '#1a1a1a',
    textColor       = '#ffffff',
    borderColor     = '#3e8ed0',
    highlightColor  = '#00ff00',
    font            = 'Arial',
    fontSize        = 14,
    iconSize        = 48,

    hoverPreview = {
        enabled    = true,
        background = '#111111',
        textColor  = '#ffffff',
        position   = 'right' -- 'right' or 'below'
    },

    equipAnimation = {
        enabled  = true,
        type     = 'glow', -- 'none', 'pulse', 'glow', 'slide'
        color    = '#00ff88',
        duration = 300
    },

    dragPreview = {
        enabled            = true,
        showStatDifference = true
    },

    lockedSlotTooltip = {
        enabled = true,
        text    = 'Requires level {{level}} or job: {{job}}'
    },

    statOverlay = {
        enabled   = true,
        style     = 'minimal',
        showStats = { 'maxHealth', 'maxArmor', 'flatDamage', 'critChance' }
    },

    toggleButton = {
        enabled  = true,
        icon     = '\xF0\x9F\x9B\xA1', -- shield emoji
        position = { bottom = 30, left = 20 }
    }
}

---------------------------------------------------------------------
-- SCRIPT FEATURE TOGGLES
---------------------------------------------------------------------
Config.Features = {
    allowStatEffects        = true,  -- If false, gear gives no bonuses
    openWithInventory       = true,  -- Open panel when inventory opens
    commandAccess           = true,  -- Enables /gear commands
    persistGear             = true,  -- Save gear between sessions
    showStatPreviewOnHover  = true,  -- Show stat effects on hover
    showTooltipDescriptions = true   -- Show slot help text in UI
}

---------------------------------------------------------------------
-- DEBUG TOOLS
---------------------------------------------------------------------
Config.DebugTools = {
    enableVerboseLogs      = false,
    logStatCalculations    = false,
    logItemLookup          = false,
    showInvalidItems       = true,
    showInvalidSlots       = true,
    printStatTotalsOnEquip = false,
    notifyOnEquip          = false,
    debugCommandEnabled    = true
}

---------------------------------------------------------------------
-- STAT SCALING
---------------------------------------------------------------------
-- Global multipliers applied to all item stats when equipped.
Config.StatScaling = {
    maxHealth       = 1.0,
    maxArmor        = 1.0,
    critChance      = 1.0,
    critDamage      = 1.0,
    flatDamage      = 1.0,
    damagePercent   = 1.0,
    speedPercent    = 1.0,
    staminaRecovery = 1.0,
    maxStamina      = 1.0,
    meleeDamage     = 1.0
}

---------------------------------------------------------------------
-- UTILITY DEBUG PRINT FUNCTION
---------------------------------------------------------------------
function Debug(...)
    if Config.Debug or (Config.DebugTools and Config.DebugTools.enableVerboseLogs) then
        print('[GearSystem]', ...)
    end
end

