--[[ LICENSE HEADER
  
  MIT Licensing
  
  Copyright © 2017 Jordan Irwin
  
  See: LICENSE.txt
--]]


ownedmob = {}
ownedmob.modname = minetest.get_current_modname()
ownedmob.modpath = minetest.get_modpath(ownedmob.modname)
ownedmob.debug = minetest.settings:get_bool('enable_debug') -- Default disabled

function ownedmob.log(level, msg)
	if level == 'debug' then
		msg = 'DEBUG: ' .. msg
		level = 'verbose'
	end
	
	minetest.log(level, '[' .. ownedmob.modname .. '] ' .. msg)
end


local scripts = {
	'register',
	'chat',
}

for index, script in ipairs(scripts) do
	dofile(ownedmob.modpath .. '/' .. script .. '.lua')
end
