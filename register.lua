--[[ LICENSE HEADER
  
  MIT Licensing
  
  Copyright © 2017 Jordan Irwin
  
  See: LICENSE.txt
--]]


-- *** TABLES ***

local registered_entities = {}
local registered_aliases = {}


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


-- Checks if a name is already registered as an alias
local function is_alias(name)
	for i, entity_name in ipairs(registered_aliases) do
		if contains(registered_aliases[entity_name], name) then return true end
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


--[[ Registers an alias for a given name
  @return
      boolean: 'true' if alias successfully registered
]]
function ownedmob.register_alias(alias, target)
	if not contains(registered_aliases[target], alias) then
		table.insert(registered_aliases[target], alias)
	else
		ownedmob.log('warning', 'Attempted to re-register alias "' .. alias '" for "' .. target .. '"')
		return false
	end
	
	local registered = contains(registered_aliases[target], alias)
	if registered then
		ownedmob.log('debug', 'Registered alias "' .. alias .. '" for "' .. target .. '"')
	else
		ownedmob.log('error', 'Could not register alias "' .. alias .. '" for "' .. target .. '"')
	end
	
	return registered
end

-- Registers an entity type as an ownable entity
function ownedmob.register(old_name)
	local entity_def = minetest.registered_entities[old_name]
	
	if entity_def then
		-- Add 'owner' attribute
		entity_def.owner = {}
		
		-- Extract entity's base name & add new prefix
		local new_name = ownedmob.modname .. ':' .. string.split(old_name, ':')[2]
		
		-- Remove old entity & register new ownable one
		minetest.unregister_entity(old_name)
		minetest.register_entity(new_name, entity_def)
		
		table.insert(registered_entities, minetest.registered_entities[new_name])
		ownedmob.register_alias(old_name, new_name)
		
		local registered = contains(minetest.registered_entities, new_name)
		
		if registered then
			ownedmob.log('action', 'Registered ownable mob "' .. new_name .. '"')
		else
			ownedmob.log('warning', 'Could not register ownable mob "' .. new_name .. '"')
		end
		
		return registered
	end
	
	return false
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
