--[[
==========================================================
 FiveM Equipment Gear System - Configuration File
==========================================================

\u{1F4E6} INSTALLATION:

1. Put this script folder inside your server's resources folder, preferably:
    resources/[standalone]/gear_system

2. Make sure the following lines are in your server.cfg:

    ensure ox_lib
    ensure ox_inventory
    ensure gear_system

3. Customize your gear slots, items, and stats below.
You do not need to know Lua — this file is beginner-friendly.
Each section is fully explained.
==========================================================
]]

Config = {}

--[[
\u{1F6E1}\uFE0F Gear Slots:
These are the locations players can equip gear in.
You define each slot with:
  label         = name shown in the UI
  allowMultiple = true/false (can multiple items be equipped in this slot?)
  showInUI      = true/false (does this appear in the left-side panel?)
]]
Config.GearSlots = {
    helmet = {
        label = "Helmet",
        allowMultiple = false,
        showInUI = true
    },
    chest = {
        label = "Armor",
        allowMultiple = false,
        showInUI = true
    },
    ring1 = {
        label = "Ring (L)",
        allowMultiple = false,
        showInUI = true
    },
    ring2 = {
        label = "Ring (R)",
        allowMultiple = false,
        showInUI = true
    },
    backpack = {
        label = "Backpack",
        allowMultiple = false,
        showInUI = true
    }
}

--[[
\u{1F4DD} Equipment Items:
Each entry represents a real inventory item that can be equipped by players.

Each item must have:
  slot   = the gear slot it fits into
  label  = name shown in UI
  rarity = one of: "common", "uncommon", "rare", "epic", "legendary"
  stats  = list of bonuses this item gives (see STAT BONUSES section)
]]
Config.EquipmentItems = {
    ["military_helmet"] = {
        slot = "helmet",
        label = "Military Helmet",
        rarity = "rare",
        stats = {
            maxHealth = { type = "flat", value = 25 },
            critChance = { type = "percent", value = 0.10 }
        }
    },
    ["ring_of_fire"] = {
        slot = "ring1",
        label = "Ring of Fire",
        rarity = "epic",
        stats = {
            damagePercent = { type = "percent", value = 0.15 },
            staminaRecovery = { type = "flat", value = 5 }
        }
    },
    ["kevlar_vest"] = {
        slot = "chest",
        label = "Kevlar Vest",
        rarity = "uncommon",
        stats = {
            maxArmor = { type = "flat", value = 50 }
        }
    },
    ["hiking_pack"] = {
        slot = "backpack",
        label = "Hiking Pack",
        rarity = "common",
        stats = {
            maxStamina = { type = "flat", value = 15 }
        }
    },
    ["steel_ring"] = {
        slot = "ring2",
        label = "Steel Ring",
        rarity = "common",
        stats = {
            meleeDamage = { type = "percent", value = 0.1 }
        }
    }
}

--[[
\u{1F4CA} Stat Bonuses:
Each stat must define:
  type  = "flat" (adds a number directly) or "percent" (multiplies a value)
  value = the amount (number)

Supported stat keys:
  maxHealth       - increases max HP
  maxArmor        - increases max armor
  critChance      - chance to critically hit (0.10 = 10%)
  critDamage      - bonus damage on crit (0.25 = +25%)
  flatDamage      - raw extra damage added
  damagePercent   - multiplies all outgoing damage
  speedPercent    - increases movement speed (0.1 = 10% faster)
  staminaRecovery - boosts stamina regen
  maxStamina      - increases stamina pool
  meleeDamage     - bonus to melee/unarmed attacks
]]

--[[
\u{1F308} Rarity System:
Each item can be marked with a rarity. Rarity affects:
  - Background color in the UI
  - A multiplier applied to the item's stats
]]
Config.RarityTiers = {
    common = {
        label = "Common",
        color = "#808080", -- gray
        statMultiplier = 1.0
    },
    uncommon = {
        label = "Uncommon",
        color = "#00ff00", -- green
        statMultiplier = 1.1
    },
    rare = {
        label = "Rare",
        color = "#007bff", -- blue
        statMultiplier = 1.25
    },
    epic = {
        label = "Epic",
        color = "#a64ca6", -- purple
        statMultiplier = 1.4
    },
    legendary = {
        label = "Legendary",
        color = "#ff4444", -- red
        statMultiplier = 1.6
    }
}

--[[
\u{1F3A8} UI Settings:
Customize the look of the gear panel and interaction feedback.
]]
Config.UI = {
    backgroundColor = "#1a1a1a", -- panel background
    textColor = "#ffffff",
    borderColor = "#3e8ed0",
    highlightColor = "#00ff00",
    font = "Arial",
    fontSize = 14,
    iconSize = 48,

    hoverPreview = {
        enabled = true,
        position = "right" -- or "below"
    },

    equipAnimation = {
        enabled = true,
        type = "glow", -- options: "none", "pulse", "glow", "slide"
        color = "#00ff88",
        duration = 300 -- milliseconds
    },

    sounds = {
        onEquip = "gear_equip.wav",
        onUnequip = "gear_unequip.wav",
        volume = 0.3
    },

    statOverlay = {
        enabled = true,
        style = "minimal", -- "minimal", "detailed", or "icons"
        showStats = { "maxHealth", "flatDamage", "critChance" }
    },

    toggleButton = {
        enabled = true,
        icon = "\u{1F6E1}",
        position = { bottom = 30, left = 20 }
    }
}

--[[
\u{2699}\uFE0F Script Features:
Control what the script does. Disable anything you don't want to use.
]]
Config.Features = {
    allowStatEffects = true,       -- If false, stats won't apply
    openWithInventory = true,      -- Gear UI auto-opens with inventory
    commandAccess = true,          -- Enables /gear command
    persistGear = true,            -- Save/load gear on player login
    showStatPreviewOnHover = true, -- Hovering shows stat effects
    showTooltipDescriptions = true -- Explains each slot in UI
}

--[[
\u{1F522} Stat Scaling:
Modify these numbers to globally scale all item stats. Useful if numbers
feel too strong or too weak without editing every item.
]]
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

-- utility debug print
define = define or function(k,v) _G[k]=v end
function Debug(...)
    if Config.Debug then print('[GearSystem]', ...) end
end
