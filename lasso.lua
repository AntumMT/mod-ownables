--[[ LICENSE HEADER
  
  MIT Licensing
  
  Copyright © 2017 Jordan Irwin
  
  See: LICENSE.txt
--]]


-- TODO: Override lassos from other mods


local function is_entity(name)
	return minetest.registered_entities[name] ~= nil
end


-- Lasso
minetest.register_craftitem(ownables.modname .. ':lasso', {
	description = 'Lasso',
	inventory_image = 'ownables_lasso.png',
	stack_max = 1,
	on_punch = function(itemstack, placer, pointed_thing)
		if pointed_thing then
			-- DEBUG:
			--ownables.log('action', 'Lasso pointing at "' .. pointed_thing.name .. '"')
			
			if pointed_thing.type == 'object' then
				-- DEBUG:
				ownables.log('action', '\t"' .. pointed_thing.type .. '" is an entity')
			else
				-- DEBUG:
				ownables.log('action', '\t"' .. pointed_thing.type .. '" is not an entity')
			end
		end
	end,
	on_place = on_punch,
})

-- TODO: Register craft for lasso
-- TODO: Override other lassos
