fx_version 'cerulean'
lua54 'yes'
game 'gta5'

name 'gear_system'
author 'Generated'

ui_page 'ui/index.html'

files {
    'ui/index.html',
    'ui/style.css',
    'ui/script.js'
}

shared_scripts {
    'config.lua',
    'inventory_bridge.lua'
}

client_scripts {
    'client.lua'
}

server_scripts {
    'server.lua'
}
