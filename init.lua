--[[ LICENSE HEADER
  
  MIT Licensing
  
  Copyright © 2017 Jordan Irwin
  
  See: LICENSE.txt
--]]


ownables = {}
ownables.modname = minetest.get_current_modname()
ownables.modpath = minetest.get_modpath(ownables.modname)
ownables.debug = minetest.settings:get_bool('enable_debug') -- Default disabled

function ownables.log(level, msg)
	if level == 'debug' then
		if not ownables.debug then return end
		
		msg = 'DEBUG: ' .. msg
		level = 'verbose'
	end
	
	minetest.log(level, '[' .. ownables.modname .. '] ' .. msg)
end


local scripts = {
	'api',
	'register',
	'lasso',
	'chat',
}

for index, script in ipairs(scripts) do
	dofile(ownables.modpath .. '/' .. script .. '.lua')
end
