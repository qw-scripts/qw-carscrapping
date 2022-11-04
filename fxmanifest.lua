fx_version 'cerulean'
game 'gta5'

description 'qw-carscrapping'
version '0.1.0'
author 'qwadebot'

server_script {
	'server/*.lua',
}

client_scripts { 
    'client/*.lua',
    '@PolyZone/client.lua',
	'@PolyZone/PolyZone.lua',
}
shared_scripts { 
    'config.lua',
    '@qb-core/shared/locale.lua',
    'locales/en.lua'
}

lua54 'yes'