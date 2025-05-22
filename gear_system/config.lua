--[[
==========================================================
 FiveM Equipment Gear System - Configuration File
==========================================================

🧩 INSTALLATION INSTRUCTIONS:

1. Place this resource folder in your server's `resources/[standalone]/` directory.
2. Ensure the following lines are in your `server.cfg`:

    ensure ox_lib
    ensure ox_inventory
    ensure gear_system

3. If using ESX or QBCore, make sure it is set up and running before this script.

4. You can fully customize gear slots, items, stats and UI below.
   No Lua knowledge is required — simply edit the examples.
==========================================================
]]

Config = {}

-- Framework selection: 'auto', 'esx', or 'qbcore'
-- When set to 'auto' the script tries to detect which framework is running.
Config.Framework = 'auto'

-- Inventory system used for adding/removing items.
-- 'ox' = ox_inventory (recommended)
-- 'qb' = qb-inventory
Config.InventorySystem = 'ox'

-- Print which inventory system is used when items are moved.
Config.InventoryBridgeDebug = false

-- Enable verbose debug prints in the server and client consoles.
Config.Debug = false

---------------------------------------------------------------------
-- GEAR SLOTS
---------------------------------------------------------------------
-- Define every slot players can equip items in.
-- label        : Name displayed in the UI
-- allowMultiple: Allow more than one item at once (usually false)
-- showInUI     : If false the slot is hidden from the gear panel
Config.GearSlots = {
    head      = { label = 'Head',      allowMultiple = false, showInUI = true },
    chest     = { label = 'Chest',     allowMultiple = false, showInUI = true },
    legs      = { label = 'Legs',      allowMultiple = false, showInUI = true },
    feet      = { label = 'Feet',      allowMultiple = false, showInUI = true },
    hands     = { label = 'Hands',     allowMultiple = false, showInUI = true },
    neck      = { label = 'Neck',      allowMultiple = false, showInUI = true },
    ring1     = { label = 'Ring (L)',  allowMultiple = false, showInUI = true },
    ring2     = { label = 'Ring (R)',  allowMultiple = false, showInUI = true },
    trinket1  = { label = 'Trinket',   allowMultiple = false, showInUI = true },
    trinket2  = { label = 'Trinket 2', allowMultiple = false, showInUI = true }
}

---------------------------------------------------------------------
-- EQUIPMENT ITEMS
---------------------------------------------------------------------
-- Each item here represents a real inventory item that can be equipped.
-- slot   : which gear slot this item fits into
-- label  : display name shown in the UI
-- rarity : one of the keys in Config.RarityTiers
-- stats  : table of stat bonuses (see Config.StatScaling section)
Config.EquipmentItems = {
    military_helmet = {
        slot = 'head',
        label = 'Military Helmet',
        rarity = 'uncommon',
        stats = {
            maxHealth    = { type = 'flat',    value = 25 },
            critChance   = { type = 'percent', value = 0.10 }
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
    }
}

---------------------------------------------------------------------
-- RARITY TIERS
---------------------------------------------------------------------
-- Rarity modifies item display color and the multiplier applied to stats.
Config.RarityTiers = {
    common = {
        label = 'Common',
        color = '#808080',      -- gray
        statMultiplier = 1.0
    },
    uncommon = {
        label = 'Uncommon',
        color = '#00ff00',      -- green
        statMultiplier = 1.1
    },
    rare = {
        label = 'Rare',
        color = '#007bff',      -- blue
        statMultiplier = 1.25
    },
    epic = {
        label = 'Epic',
        color = '#a64ca6',      -- purple
        statMultiplier = 1.4
    },
    legendary = {
        label = 'Legendary',
        color = '#ff4444',      -- red
        statMultiplier = 1.6
    }
}

---------------------------------------------------------------------
-- UI SETTINGS
---------------------------------------------------------------------
Config.UI = {
    backgroundColor = '#1a1a1a', -- panel background
    textColor       = '#ffffff',
    borderColor     = '#3e8ed0',
    highlightColor  = '#00ff00',
    font            = 'Arial',
    fontSize        = 14,
    iconSize        = 48,

    -- Hover preview panel
    hoverPreview = {
        enabled    = true,
        background = '#111111',
        textColor  = '#ffffff',
        position   = 'right'       -- 'right' or 'below'
    },

    -- Slot glow / animation when equipping
    equipAnimation = {
        enabled  = true,
        type     = 'glow',         -- 'none', 'pulse', 'glow', 'slide'
        color    = '#00ff88',
        duration = 300             -- milliseconds
    },

    -- Optional sound feedback on equip / unequip
    sounds = {
        onEquip   = 'gear_equip.wav',
        onUnequip = 'gear_unequip.wav',
        volume    = 0.3
    },

    -- Show stat change preview while dragging
    dragPreview = {
        enabled            = true,
        showStatDifference = true
    },

    -- Tooltip explaining locked slots (if any)
    lockedSlotTooltip = {
        enabled = true,
        text    = 'Requires level {{level}} or job: {{job}}'
    },

    -- Small stat overlay at bottom of panel
    statOverlay = {
        enabled   = true,
        style     = 'minimal',
        showStats = { 'maxHealth', 'maxArmor', 'flatDamage', 'critChance' }
    },

    -- Mobile toggle button to open the panel
    toggleButton = {
        enabled  = true,
        icon     = '🛡️',
        position = { bottom = 30, left = 20 }
    }
}

---------------------------------------------------------------------
-- SCRIPT FEATURE TOGGLES
---------------------------------------------------------------------
Config.Features = {
    allowStatEffects        = true,  -- If false, gear gives no stats
    openWithInventory       = true,  -- Automatically open when inventory opens
    commandAccess           = true,  -- Enables /gear command
    persistGear             = true,  -- Save/load gear between sessions
    showStatPreviewOnHover  = true,  -- Hovering shows stat effects
    showTooltipDescriptions = true   -- Display slot help text in UI
}

---------------------------------------------------------------------
-- DEBUG TOOLS
---------------------------------------------------------------------
Config.DebugTools = {
    enableVerboseLogs      = false, -- Print detailed logs when gear changes
    logStatCalculations    = false, -- Print breakdown of stat math
    logItemLookup          = false, -- Log each item validity check
    showInvalidItems       = true,  -- Warn if an item isn't defined
    showInvalidSlots       = true,  -- Warn if slot name is invalid
    printStatTotalsOnEquip = false, -- Print total stats when gear updates
    notifyOnEquip          = false, -- Send a chat/notify message on equip
    debugCommandEnabled    = true   -- Enables /gearstatus command
}

---------------------------------------------------------------------
-- STAT SCALING
---------------------------------------------------------------------
-- These multipliers are applied to item stats when calculating totals.
-- Adjust them if you want to globally buff or nerf a particular stat.
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

