# Gear System

This resource adds a modular equipment system that allows defining existing inventory items as gear which provide player stats when equipped. It supports ESX and QBCore automatically and can use either **ox_inventory** or **qb-inventory** for item management via a simple setting in `config.lua`.

Use `/gear` to open the equipment panel or configure it to open when the inventory UI opens. Items defined in `config.lua` can be dragged into gear slots and their stats are applied immediately.

## Inventory Choice
Set `Config.InventorySystem` to `'ox'` or `'qb'` in `config.lua` depending on which inventory script your server uses. All item transfers will automatically use the chosen system.
