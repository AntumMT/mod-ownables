--[[ LICENSE HEADER
  
  MIT Licensing
  
  Copyright © 2017 Jordan Irwin
  
  See: LICENSE.txt
--]]


local function is_entity(name)
	return minetest.registered_entities[name] ~= nil
end


-- Lasso
minetest.register_craftitem(ownmob.modname .. ':lasso', {
	description = 'Lasso',
	inventory_image = 'ownmob_lasso.png',
	stack_max = 1,
	on_place = function(itemstack, placer, pointed_thing)
		if pointed_thing then
			-- DEBUG:
			--ownmob.log('action', 'Lasso pointing at "' .. pointed_thing.name .. '"')
			
			if pointed_thing.name and is_entity(pointed_thing.name) then
				-- DEBUG:
				ownmob.log('action', '\t"' .. tostring(pointed_thing.name) .. '" is an entity')
			else
				-- DEBUG:
				ownmob.log('action', '\t"' .. tostring(pointed_thing.name) .. '" is not an entity')
			end
		end
	end
})

-- TODO: Register craft for lasso
-- TODO: Override other lassos
