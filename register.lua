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

-- Retrieves table of registered aliases
function ownmob.get_registered_aliases()
	return registered_aliases
end


-- Retrieves table of registered entities
function ownmob.get_registered_entities()
	return registered_entities
end


-- Lists registered ownable entities
function ownmob.list_entities(player)
	if player == nil then
		ownmob.log('info', 'Ownable entitites (total: ' .. #registered_entities .. '):')
		for i, name in ipairs(registered_entities) do
			ownmob.log('info', '\t- ' .. name)
		end
		
		return
	end
	
	-- FIXME: Send message to player
	ownmob.log('warning', 'Called "ownmob.list" with "player" parameter but code is unfinished')
end


-- Retrieves entity definition by name
function ownmob.get_def(name)
	local def = nil
	
	if contains(registered_entities, name) then
		def = minetest.registered_entities[name]
	end
	
	if not def then
		ownmob.log('warning', 'Attempt to retrieve definition for unregistered ownable entity "' .. name .. '"')
	end
	
	return def
end


--[[ Registers an alias for a given name
  @return
      boolean: 'true' if alias successfully registered
]]
function ownmob.register_alias(alias, target)
	if not contains(registered_aliases, target) then
		registered_aliases[target] = {}
	end
	
	if not contains(registered_aliases[target], alias) then
		table.insert(registered_aliases[target], alias)
	else
		ownmob.log('warning', 'Attempted to re-register alias "' .. alias '" for "' .. target .. '"')
		return false
	end
	
	local registered = contains(registered_aliases[target], alias)
	if registered then
		ownmob.log('debug', 'Registered alias "' .. alias .. '" for "' .. target .. '"')
	else
		ownmob.log('error', 'Could not register alias "' .. alias .. '" for "' .. target .. '"')
	end
	
	return registered
end


-- Registers an entity type as an ownable entity
function ownmob.register(old_name)
	ownmob.log('debug', 'Registering "' .. old_name .. '" as ownable entity ...')
	
	local entity_def = minetest.registered_entities[old_name]
	
	if entity_def then
		-- Add 'owner' attribute
		entity_def.owner = {}
		
		-- Extract entity's base name & add new prefix
		local new_name = ownmob.modname .. ':' .. string.split(old_name, ':')[2]
		
		local register_name = new_name
		-- For registering from other mods
		if minetest.get_current_modname ~= ownmob.modname then
			register_name = ':' .. register_name
		end
		
		-- Remove old entity & register new ownable one
		-- FIXME: How to unregister/override an entity type
		--minetest.unregister_entity(old_name)
		minetest.register_entity(register_name, entity_def)
		
		table.insert(registered_entities, new_name)
		
		-- FIXME: Check minetest.registered_entities that 'old_name' is removed
		local registered = minetest.registered_entities[new_name] ~= nil -- and not minetest.registered_entities[old_name]
		
		if registered then
			-- Register removed entity as alias of new one
			ownmob.register_alias(old_name, new_name)
			
			ownmob.log('verbose', 'Re-registered "' .. old_name .. '" as ownable mob "' .. new_name .. '"')
		else
			ownmob.log('error', 'Could not register ownable mob "' .. new_name .. '"')
		end
		
		return registered
	end
	
	return false
end


--[[ Adds a new owner to entity

  @return
    boolean: 'true' if owner was added
]]
function ownmob.add_owner(entity, owner)
	entity = to_def(entity)
	if entity and not contains(entity.owner, owner) then
		table.insert(entity.owner, owner)
		
		return contains(entity.owner, owner)
	end
	
	return false
end


-- Removes an owner from entity
function ownmob.remove_owner(entity, owner)
	entity = to_def(entity)
	if entity and contains(entity.owner, owner) then
		table.remove(entity.owner, get_index(entity.owner, owner))
		
		return not contains(entity.owner, owner)
	end
	
	return false
end
