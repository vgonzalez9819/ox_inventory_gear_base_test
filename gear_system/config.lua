Config = {}

--[[
==========================================================
 FiveM Gear System - Configuration File
==========================================================

INSTALLATION:

1. Place this script in your server's `resources/[standalone]/` folder.
2. Add the following lines to your `server.cfg`:

       ensure ox_lib
       ensure ox_inventory
       ensure gear_system

3. Edit the sections below to customise items, slots and behaviour.
   No Lua knowledge required – follow the examples and comments.
==========================================================
]]

-- Framework selection: 'auto', 'esx', or 'qbcore'
-- When set to 'auto', the script will try to detect your framework.
Config.Framework = 'auto'

-- If true, uses ox_inventory exports to add/remove items when equipping.
Config.UseOxInventory = true

-- General debug messages in server/client consoles.
Config.Debug = false

-- Extra debugging and testing tools. Safe to disable when not needed.
Config.DebugTools = {
    enableVerboseLogs = true,           -- Detailed logging for equip events
    logStatCalculations = true,         -- Print how final stats are calculated
    logItemLookup = true,               -- Log item/slot validation steps
    showInvalidItems = true,            -- Warn if an item is missing from config
    showInvalidSlots = true,            -- Warn if a slot is not defined
    printStatTotalsOnEquip = true,      -- Output total stats when gear changes
    notifyOnEquip = true,               -- In-game notification on equip/unequip
    debugCommandEnabled = true          -- Enables /gearstatus command
}

-- UI position for the gear panel (CSS top/left in pixels)
Config.PanelPosition = {
    top = 200,
    left = 50
}

-- Rarity tiers apply colour coding and stat multipliers.
Config.RarityTiers = {
    common =    { label = 'Common',    color = '#808080', statMultiplier = 1.0 },
    uncommon =  { label = 'Uncommon',  color = '#00ff00', statMultiplier = 1.1 },
    rare =      { label = 'Rare',      color = '#007bff', statMultiplier = 1.25 },
    epic =      { label = 'Epic',      color = '#a64ca6', statMultiplier = 1.4 },
    legendary = { label = 'Legendary', color = '#ff4444', statMultiplier = 1.6 }
}

--[[
Gear Slots: these are the ONLY slots supported by the script.
Each slot lists which item names can be equipped there.
]]
Config.GearSlots = {
    head      = { label = 'Head',      allowedItems = { 'military_helmet', 'iron_helmet' } },
    chest     = { label = 'Chest',     allowedItems = { 'kevlar_vest', 'leather_armor' } },
    legs      = { label = 'Legs',      allowedItems = { 'combat_pants', 'jeans' } },
    feet      = { label = 'Feet',      allowedItems = { 'army_boots', 'leather_boots' } },
    hands     = { label = 'Hands',     allowedItems = { 'tactical_gloves' } },
    neck      = { label = 'Neck',      allowedItems = { 'silver_amulet' } },
    ring1     = { label = 'Ring (L)',  allowedItems = { 'ring_of_fire', 'ring_of_life' } },
    ring2     = { label = 'Ring (R)',  allowedItems = { 'ring_of_power' } },
    trinket1  = { label = 'Trinket 1', allowedItems = { 'ancient_rune' } },
    trinket2  = { label = 'Trinket 2', allowedItems = { 'mystic_charm' } }
}

--[[
Equipment item definitions. Each key is the inventory item name.
  slot   = which gear slot it fits into
  label  = displayed name in the UI
  rarity = affects colour and stat scaling
  stats  = table of stat bonuses (type = 'flat' or 'percent')
]]
Config.EquipmentItems = {
    military_helmet = {
        slot = 'head',
        label = 'Military Helmet',
        rarity = 'common',
        stats = {
            maxHealth = { type = 'flat', value = 20 },
            critChance = { type = 'percent', value = 0.05 }
        }
    },
    kevlar_vest = {
        slot = 'chest',
        label = 'Kevlar Vest',
        rarity = 'uncommon',
        stats = {
            maxArmor = { type = 'flat', value = 50 }
        }
    },
    combat_pants = {
        slot = 'legs',
        label = 'Combat Pants',
        rarity = 'common',
        stats = {
            speedPercent = { type = 'percent', value = 0.05 }
        }
    },
    army_boots = {
        slot = 'feet',
        label = 'Army Boots',
        rarity = 'common',
        stats = {
            speedPercent = { type = 'percent', value = 0.05 }
        }
    },
    tactical_gloves = {
        slot = 'hands',
        label = 'Tactical Gloves',
        rarity = 'rare',
        stats = {
            meleeDamage = { type = 'percent', value = 0.1 }
        }
    },
    silver_amulet = {
        slot = 'neck',
        label = 'Silver Amulet',
        rarity = 'rare',
        stats = {
            staminaRecovery = { type = 'flat', value = 2 }
        }
    },
    ring_of_fire = {
        slot = 'ring1',
        label = 'Ring of Fire',
        rarity = 'epic',
        stats = {
            damagePercent = { type = 'percent', value = 0.15 }
        }
    },
    ring_of_life = {
        slot = 'ring1',
        label = 'Ring of Life',
        rarity = 'rare',
        stats = {
            maxHealth = { type = 'flat', value = 15 }
        }
    },
    ring_of_power = {
        slot = 'ring2',
        label = 'Ring of Power',
        rarity = 'legendary',
        stats = {
            damageFlat = { type = 'flat', value = 5 }
        }
    },
    ancient_rune = {
        slot = 'trinket1',
        label = 'Ancient Rune',
        rarity = 'uncommon',
        stats = {
            critDamage = { type = 'percent', value = 0.2 }
        }
    },
    mystic_charm = {
        slot = 'trinket2',
        label = 'Mystic Charm',
        rarity = 'rare',
        stats = {
            maxStamina = { type = 'flat', value = 10 }
        }
    }
}

-- Scaling applied to stats before they are given to the player.
-- Adjust these numbers to globally increase or reduce effects.
Config.StatScaling = {
    maxHealth       = 1.0,
    maxArmor        = 1.0,
    critChance      = 1.0,
    critDamage      = 1.0,
    damageFlat      = 1.0,
    damagePercent   = 1.0,
    speedPercent    = 1.0,
    staminaRecovery = 1.0,
    maxStamina      = 1.0,
    meleeDamage     = 1.0
}

-- Simple debug print helper
function Debug(...)
    if Config.Debug or (Config.DebugTools.enableVerboseLogs) then
        print('[GearSystem]', ...)
    end
end
