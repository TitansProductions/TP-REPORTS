fx_version 'bodacious'
games { 'gta5' }

author 'Nosmakos'
description 'Titans Productions Reports'
version '1.1.0'

ui_page 'html/index.html'

client_scripts {
    'config.lua',
    'client/main.lua',
}

server_scripts {
    '@mysql-async/lib/MySQL.lua',
    'config.lua',
    'server/main.lua',
}

files {
	'html/index.html',
	'html/js/script.js',
	'html/css/style.css',
	'html/font/Prototype.ttf'
}
