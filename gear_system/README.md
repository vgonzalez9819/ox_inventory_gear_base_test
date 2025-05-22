# Gear System

This resource adds a modular equipment system that allows defining existing inventory items as gear which provide player stats when equipped. It supports ESX and QBCore automatically and can optionally integrate with `ox_inventory` for item management.

Use `/gear` to open the equipment panel or configure it to open when the inventory UI opens. Items defined in `config.lua` can be dragged into gear slots and their stats are applied immediately.

The UI supports hover previews, equip animations and optional sound feedback. All behaviour can be tweaked inside `config.lua` under the `Config.UI` section.
