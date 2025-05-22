fx_version 'cerulean'
lua54 'yes'
game 'gta5'

name 'gear_system'
author 'Codex'
description 'Standalone Gear & Stat System'
version '1.0.0'

ui_page 'html/ui.html'

files {
    'html/ui.html',
    'html/style.css',
    'html/app.js'
}

shared_script 'config.lua'
client_script 'client.lua'
server_scripts {
    'inventory_bridge.lua',
    'server.lua'
}
