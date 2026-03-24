fx_version 'cerulean'
game 'gta5'

author 'Logan L'
description 'F9 Panic Button: server broadcast, location, blip + radius, optional sound'
version '1.0.0'

shared_scripts { 'config.lua' }

ui_page 'html/ui.html'
files {
    'html/ui.html',
    'html/ui.js',
    'html/panic.ogg' -- your custom audio file name
}

client_scripts { 'client.lua' }
server_scripts { 'server.lua' }

lua54 'yes'
