--[[ LICENSE HEADER
  
  MIT Licensing
  
  Copyright © 2017 Jordan Irwin
  
  See: LICENSE.txt
--]]


-- *** TABLES ***

local registered_entities = {}


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

-- Retrieves table of registered aliases
function ownables.get_registered_aliases()
	return registered_aliases
end


-- Retrieves table of registered entities
function ownables.get_registered_entities()
	return registered_entities
end


-- Lists registered ownable entities
function ownables.list_entities(player)
	if player == nil then
		ownables.log('info', 'Ownable entitites (total: ' .. #registered_entities .. '):')
		for i, name in ipairs(registered_entities) do
			ownables.log('info', '\t- ' .. name)
		end
		
		return
	end
	
	-- FIXME: Send message to player
	ownables.log('warning', 'Called "ownables.list" with "player" parameter but code is unfinished')
end


-- Retrieves entity definition by name
function ownables.get_def(name)
	local def = nil
	
	if contains(registered_entities, name) then
		def = minetest.registered_entities[name]
	end
	
	if not def then
		ownables.log('warning', 'Attempt to retrieve definition for unregistered ownable entity "' .. name .. '"')
	end
	
	return def
end


-- Registers an entity type as an ownable entity
function ownables.register(old_name)
	ownables.log('debug', 'Registering "' .. old_name .. '" as ownable entity ...')
	
	local entity_def = minetest.registered_entities[old_name]
	
	if entity_def then
		-- Add 'owner' attribute
		entity_def.owner = {}
		
		table.insert(registered_entities, old_name)
		
		local registered = contains(registered_entities, old_name)
		
		if registered then
			ownables.log('verbose', 'Registered "' .. old_name .. '" as ownable')
		else
			ownables.log('error', 'Could not register "' .. old_name .. '" as ownable')
		end
		
		return registered
	end
	
	return false
end


--[[ Adds a new owner to entity
  FIXME: Needs to work on entity instances

  @return
    boolean: 'true' if owner was added
]]
function ownables.add_owner(entity, owner)
	entity = to_def(entity)
	if entity and not contains(entity.owner, owner) then
		table.insert(entity.owner, owner)
		
		return contains(entity.owner, owner)
	end
	
	return false
end


--[[ Removes an owner from entity
  FIXME: Needs to work on entity instances
]]
function ownables.remove_owner(entity, owner)
	entity = to_def(entity)
	if entity and contains(entity.owner, owner) then
		table.remove(entity.owner, get_index(entity.owner, owner))
		
		return not contains(entity.owner, owner)
	end
	
	return false
end


-- Checks if entity has owner(s)
function ownables.has_owner(entity)
	if entity and entity.owner ~= nil then
		if type(entity.owner) == 'string' then return true end
		if type(entity.owner) == 'table' and #entity.owner then return true end
	end
	
	return false
end


-- Checks if an entity can be player-owned
function ownables.is_ownable(name)
	return contains(registered_entities, name)
end
