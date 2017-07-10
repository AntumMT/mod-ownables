--[[ LICENSE HEADER
  
  MIT Licensing
  
  Copyright © 2017 Jordan Irwin
  
  See: LICENSE.txt
--]]


ownedmob = {}
ownedmob.modname = minetest.get_current_modname()
ownedmob.modpath = minetest.get_modpath(ownedmob.modname)
ownedmob.debug = minetest.settings:get_bool('enable_debug') -- Default disabled


local scripts = {
	'register',
}

for index, script in ipairs(scripts) do
	dofile(ownedmob.modpath .. '/ ' .. script .. '.lua')
end
