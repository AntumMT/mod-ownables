--[[ LICENSE HEADER
  
  MIT Licensing
  
  Copyright © 2017 Jordan Irwin
  
  See: LICENSE.txt
--]]


-- Chat commands for 'ownmob' mod

-- Override 'clearobjects' command
core.unregister_chatcommand('clearobjects')
core.register_chatcommand('clearobjects', {
	params = '[full | quick | force]',
	description = 'Clear all objects in world',
	privs = {server=true},
	func = function(name, param)
		local options = {}
		options.force = false
		if string.split(param, ' ')[1] == 'force' then
			options.force = true
			options.mode = string.split(param, ' ')[2]
		end
		if param == '' or param == 'full' then
			options.mode = 'full'
		elseif param == 'quick' then
			options.mode = 'quick'
		else
			return false, 'Invalid usage, see /help clearobjects.'
		end

		core.log('action', name .. ' clears all objects ('
				.. options.mode .. ' mode).')
		core.chat_send_all('Clearing all objects.  This may take long.'
				.. '  You may experience a timeout.  (by '
				.. name .. ')')
		if options.force then
			core.clear_objects(options)
		else
			-- TODO: Manually clear all objects except
		end
		core.log('action', 'Object clearing done.')
		core.chat_send_all('*** Cleared all objects.')
	end,
})
