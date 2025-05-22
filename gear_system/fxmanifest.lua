fx_version 'cerulean'
game 'gta5'

author 'Codex Gear System'
description 'Standalone equipment/gear system with stat bonuses'

shared_script 'config.lua'
client_script 'client.lua'
server_script 'server.lua'
server_script 'inventory_bridge.lua'

ui_page 'html/ui.html'

files {
    'html/ui.html',
    'html/style.css',
    'html/app.js'
}

lua54 'yes'
