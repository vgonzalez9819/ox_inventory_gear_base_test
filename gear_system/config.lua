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

3. If using ESX or QBCore, make sure it's properly set up before using this script.

4. This config file allows you to fully customize:
    - What items can be equipped
    - What gear slots exist
    - What stat bonuses gear items give
    - How stats are scaled
    - UI behavior and slot rules

You DO NOT need to know Lua to use this script. Just follow the examples and comments.
==========================================================
]]

Config = {}

--///////////////////////////////////////////////////////////////
-- General Settings
--///////////////////////////////////////////////////////////////

-- Framework selection:
--  "auto"   - automatically detect ESX or QBCore
--  "esx"    - force ESX
--  "qbcore" - force QBCore
Config.Framework = 'auto'

-- Set to true if you use ox_inventory so gear items are added/removed using
-- the ox_inventory exports. Set to false to use the framework's inventory.
Config.UseOxInventory = true

-- Enable to print debug information to the server/clientside consoles.
Config.Debug = false

-- Position of the equipment panel on screen (in pixels).
Config.PanelPosition = {
    top = 200,   -- distance from top of the screen
    left = 50    -- distance from left of the screen
}

--///////////////////////////////////////////////////////////////
-- Gear Slot Definitions
--///////////////////////////////////////////////////////////////
-- Each slot represents a place where the player can equip an item.
--  label        : Text shown in the UI for this slot.
--  allowMultiple: If true, this slot could accept multiple items (not used by
--                  the basic script but kept for future expansion).
--  showInUI     : Should this slot appear in the drag-and-drop panel?
Config.GearSlots = {
    helmet = {
        label = 'Helmet',
        allowMultiple = false,
        showInUI = true
    },
    chest = {
        label = 'Body Armor',
        allowMultiple = false,
        showInUI = true
    },
    pants = {
        label = 'Pants',
        allowMultiple = false,
        showInUI = true
    },
    gloves = {
        label = 'Gloves',
        allowMultiple = false,
        showInUI = true
    },
    boots = {
        label = 'Boots',
        allowMultiple = false,
        showInUI = true
    },
    ring1 = {
        label = 'Ring (L)',
        allowMultiple = false,
        showInUI = true
    },
    ring2 = {
        label = 'Ring (R)',
        allowMultiple = false,
        showInUI = true
    },
    backpack = {
        label = 'Backpack',
        allowMultiple = false,
        showInUI = true
    },
    weaponmod = {
        label = 'Weapon Mod',
        allowMultiple = false,
        showInUI = true
    }
}

--///////////////////////////////////////////////////////////////
-- Equipment Item Definitions
--///////////////////////////////////////////////////////////////
-- Each entry links an existing inventory item to a gear slot and describes
-- the stat bonuses it grants when equipped.
--  slot  : Which gear slot this item can occupy.
--  label : Friendly name shown in the UI when equipped.
--  stats : Table of stat bonuses. Each stat has:
--          type  - "flat" for a direct value, or "percent" for a multiplier.
--          value - Number applied to the player when this gear is equipped.
Config.EquipmentItems = {
    -- Helmet that increases health and crit chance
    military_helmet = {
        slot = 'helmet',
        label = 'Military Helmet',
        stats = {
            maxHealth = { type = 'flat', value = 25 },
            critChance = { type = 'percent', value = 0.10 }
        }
    },

    -- Heavy kevlar vest providing additional armour
    kevlar_vest = {
        slot = 'chest',
        label = 'Kevlar Vest',
        stats = {
            maxArmor = { type = 'flat', value = 50 }
        }
    },

    -- Ring that boosts damage and stamina recovery
    ring_of_fire = {
        slot = 'ring1',
        label = 'Ring of Fire',
        stats = {
            damagePercent = { type = 'percent', value = 0.15 },
            staminaRecovery = { type = 'flat', value = 5 }
        }
    },

    -- Gloves increasing flat damage and critical damage
    gloves_of_fury = {
        slot = 'gloves',
        label = 'Gloves of Fury',
        stats = {
            flatDamage = { type = 'flat', value = 5 },
            critDamage = { type = 'percent', value = 0.20 }
        }
    },

    -- Boots that slightly slow you but improve melee damage
    iron_boots = {
        slot = 'boots',
        label = 'Iron Boots',
        stats = {
            speedPercent = { type = 'percent', value = -0.05 },
            meleeDamage = { type = 'percent', value = 0.10 }
        }
    },

    -- Backpack that increases total stamina
    endurance_pack = {
        slot = 'backpack',
        label = 'Endurance Pack',
        stats = {
            maxStamina = { type = 'flat', value = 20 }
        }
    }
}

--///////////////////////////////////////////////////////////////
-- Stat Scaling
--///////////////////////////////////////////////////////////////
-- These multipliers allow you to tweak the overall strength of each stat
-- without editing every item individually. Most servers will leave these at 1.
--  maxHealth       (flat)    Adds directly to the player's maximum health.
--  maxArmor        (flat)    Adds directly to the player's armour points.
--  critChance      (percent) Adds to the player's critical hit chance.
--  critDamage      (percent) Multiplies damage dealt on a critical hit.
--  flatDamage      (flat)    Additional damage added to every attack.
--  damagePercent   (percent) Multiplier applied to all damage dealt.
--  speedPercent    (percent) Percentage increase or decrease to running speed.
--  staminaRecovery (flat)    Extra stamina regenerated per second.
--  maxStamina      (flat)    Adds to the player's total stamina pool.
--  meleeDamage     (percent) Multiplier for unarmed/melee damage.
Config.StatScaling = {
    maxHealth = 1.0,
    maxArmor = 1.0,
    critChance = 1.0,
    critDamage = 1.0,
    flatDamage = 1.0,
    damagePercent = 1.0,
    speedPercent = 1.0,
    staminaRecovery = 1.0,
    maxStamina = 1.0,
    meleeDamage = 1.0
}

--///////////////////////////////////////////////////////////////
-- Utility debug function used internally
--///////////////////////////////////////////////////////////////
function Debug(...)
    if Config.Debug then
        print('[GearSystem]', ...)
    end
end
