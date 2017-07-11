--[[ LICENSE HEADER
  
  MIT Licensing
  
  Copyright © 2017 Jordan Irwin
  
  See: LICENSE.txt
--]]


ownmob = {}
ownmob.modname = minetest.get_current_modname()
ownmob.modpath = minetest.get_modpath(ownmob.modname)
ownmob.debug = minetest.settings:get_bool('enable_debug') -- Default disabled

function ownmob.log(level, msg)
	if level == 'debug' then
		if not ownmob.debug then return end
		
		msg = 'DEBUG: ' .. msg
		level = 'verbose'
	end
	
	minetest.log(level, '[' .. ownmob.modname .. '] ' .. msg)
end


local scripts = {
	'register',
	'chat',
}

for index, script in ipairs(scripts) do
	dofile(ownmob.modpath .. '/' .. script .. '.lua')
end
