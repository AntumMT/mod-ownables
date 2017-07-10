--[[ LICENSE HEADER
  
  MIT Licensing
  
  Copyright © 2017 Jordan Irwin
  
  See: LICENSE.txt
--]]


-- *** LOCAL FUNCTIONS ***

-- Retrieves table index
local function get_index(tbl, value)
	local index = 0
	for i, v in ipairs(tbl) do
		index = index + 1
		if v == value then return index end
	end
	
	return nil
end


-- Checks a table for a given string value
local function contains(tbl, value)
	if type(tbl) == 'table' then
		for i, v in ipairs(tbl) do
			if v == value then return true end
		end
	end
	
	return false
end


-- Converts entity name to table definition
local function to_def(entity)
	if type(entity) ~= 'table' then
		entity = minetest.registered_entities[entity]
	end
	
	return entity
end


-- Checks if an entity is ownable
local function is_ownable(entity)
	entity = to_def(entity)
	
	-- Check for 'owner' attribute
	if entity and entity.owner ~= nil then
		return true
	end
	
	return false
end


-- *** GLOBAL FUNCTIONS ***

-- Registers an entity type as an ownable entity
function ownedmob.register(old_name)
	local entity = minetest.registered_entities[old_name]
	
	if entity then
		-- Add 'owner' attribute
		entity.owner = {}
		
		-- Extract entity's base name & add new prefix
		local new_name = ownedmob.modname .. ':' .. split(old_name, ':')[2]
		
		-- Remove old entity & register new ownable one
		minetest.unregister_entity(old_name)
		minetest.register_entity(new_name, entity)
	end
end


--[[ Adds a new owner to entity

  @return
    boolean: 'true' if owner was added
]]
function ownedmob.add_owner(entity, owner)
	entity = to_def(entity)
	if entity and not contains(entity.owner, owner) then
		table.insert(entity.owner, owner)
		
		return contains(entity.owner, owner)
	end
	
	return false
end


-- Removes an owner from entity
function ownedmob.remove_owner(entity, owner)
	entity = to_def(entity)
	if entity and contains(entity.owner, owner) then
		table.remove(entity.owner, get_index(entity.owner, owner))
		
		return not contains(entity.owner, owner)
	end
	
	return false
end
