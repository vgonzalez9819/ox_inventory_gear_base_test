--[[
    Installation:
    1. Place the gear_system folder in your resources directory.
    2. Add `ensure gear_system` to your server.cfg.
    3. Configure the options below as needed.
]]

Config = {}

-- Framework selection: 'auto', 'qbcore', 'esx', or 'standalone'
Config.Framework = 'auto'

-- Inventory system: 'ox' or 'qb'
Config.InventorySystem = 'ox'

-- Rarity tiers define UI color and stat multipliers
Config.RarityTiers = {
    common    = { color = '#ffffff', multiplier = 1.0 },
    uncommon  = { color = '#1eff00', multiplier = 1.1 },
    rare      = { color = '#0070dd', multiplier = 1.2 },
    epic      = { color = '#a335ee', multiplier = 1.4 },
    legendary = { color = '#ff8000', multiplier = 1.6 }
}

-- Gear slot ordering
Config.GearSlots = {
    'head', 'chest', 'legs', 'feet', 'hands',
    'neck', 'ring1', 'ring2', 'trinket1', 'trinket2'
}

-- Example equipment items (add your own)
Config.EquipmentItems = {
    -- ['iron_helmet'] = {
    --     slot = 'head',
    --     rarity = 'common',
    --     stats = {
    --         maxArmor = { type = 'flat', value = 25 }
    --     }
    -- }
}

-- Global stat scaling values
Config.StatScaling = {
    damage       = 1.0,
    health       = 1.0,
    stamina      = 1.0
}

-- UI customization options
Config.UI = {
    colors = {
        background = '#1c1c1c',
        text = '#ffffff',
        border = '#565656'
    },
    font = {
        name = 'Arial',
        size = 14
    },
    hoverPreview = true,
    equipAnimation = true,
    statOverlay = 'right',
    toggleButton = {
        position = 'right',
        icon = 'helmet'
    }
}

-- Feature toggles
Config.Features = {
    allowStatEffects = true,
    autoOpenWithInventory = true,
    gearCommand = true,
    gearStatusCommand = true,
    persistGear = true,
    tooltips = true,
    slotDescriptions = true
}

-- Debug settings
Config.DebugTools = {
    verbose = false,
    statTracing = false,
    warnings = true,
    allowGearReset = false
}
