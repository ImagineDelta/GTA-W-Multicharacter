ESX.RegisterCommand('setslots', 'gameadmin', function(xPlayer, args, showError)
	local slots = MySQL.scalar('SELECT `slots` FROM `multicharacter_slots` WHERE identifier = ?', {
		args.identifier
	})

	if slots == nil then
		MySQL.update('INSERT INTO `multicharacter_slots` (`identifier`, `slots`) VALUES (?, ?)', {
			args.identifier,
			args.slots
		})
		xPlayer.triggerEvent('esx:showNotification', _U('slotsadd', args.slots, args.identifier))
	else
		MySQL.update('UPDATE `multicharacter_slots` SET `slots` = ? WHERE `identifier` = ?', {
			args.slots,
			args.identifier
		})
		xPlayer.triggerEvent('esx:showNotification', _U('slotsedit', args.slots, args.identifier))
	end
end, true, {help = _U('command_setslots'), validate = true, arguments = {
	{name = 'identifier', help = _U('command_identifier'), type = 'string'},
	{name = 'slots', help = _U('command_slots'), type = 'number'}
}})

ESX.RegisterCommand('remslots', 'gameadmin', function(xPlayer, args, showError)
	local slots = MySQL.scalar('SELECT `slots` FROM `multicharacter_slots` WHERE identifier = ?', {
		args.identifier
	})

	if slots ~= nil then
		MySQL.update('DELETE FROM `multicharacter_slots` WHERE `identifier` = ?', {
			args.identifier
		})
		xPlayer.triggerEvent('esx:showNotification', _U('slotsrem', args.identifier))
	end
end, true, {help = _U('command_remslots'), validate = true, arguments = {
	{name = 'identifier', help = _U('command_identifier'), type = 'string'}
}})

--[[ESX.RegisterCommand('enablechar', 'gameadmin', function(xPlayer, args, showError)

	local selectedCharacter = 'char'..args.charslot..':'..args.identifier;
 
	MySQL.update('UPDATE `users` SET `disabled` = 0 WHERE identifier = ?', {
		selectedCharacter
	}, function(result)
		if result > 0 then
			xPlayer.triggerEvent('esx:showNotification', _U('charenabled', args.charslot, args.identifier))
		else
			xPlayer.triggerEvent('esx:showNotification', _U('charnotfound', args.charslot, args.identifier))
		end
	end)

end, true, {help = _U('command_enablechar'), validate = true, arguments = {
	{name = 'identifier', help = _U('command_identifier'), type = 'string'},
	{name = 'charslot', help = _U('command_charslot'), type = 'number'}
}})





--[[ESX.RegisterCommand('disablechar', 'gameadmin', function(xPlayer, args, showError)

	local selectedCharacter = 'char'..args.charslot..':'..args.identifier;
 
	MySQL.update('UPDATE `users` SET `disabled` = 1 WHERE identifier = ?', {
		selectedCharacter
	}, function(result)
		if result > 0 then
			xPlayer.triggerEvent('esx:showNotification', _U('chardisabled', args.charslot, args.identifier))
		else
			xPlayer.triggerEvent('esx:showNotification', _U('charnotfound', args.charslot, args.identifier))
		end
	end)

end, true, {help = _U('command_disablechar'), validate = true, arguments = {
	{name = 'identifier', help = _U('command_identifier'), type = 'string'},
	{name = 'charslot', help = _U('command_charslot'), type = 'number'}
}})]]


RegisterCommand('forcelog', function(source, args, rawCommand)
    -- Check if the player executing the command is an admin
    local xPlayer = ESX.GetPlayerFromId(source) -- Make sure ESX is properly initialized in your environment
    
    -- Function to check if player is in an admin group
    local function IsAdmin(xPlayer)
        local playerGroup = xPlayer.getGroup()
        for _, group in ipairs(Config.AdminGroups) do
            if playerGroup == group then
                return true
            end
        end
        return false
    end

    -- Check if the player is an admin
    if IsAdmin(xPlayer) then
        -- Ensure an argument was provided
        if args[1] then
            local targetId = tonumber(args[1])

            -- Check if the target player is valid
            if GetPlayerName(targetId) then
                local adminName = GetPlayerName(source)
                local playerName = GetPlayerName(targetId)
                -- Kick the target player to force a relog
                TriggerEvent('esx:playerLogout', targetId)
                
                -- Message to the admin
                TriggerClientEvent('chat:addMessage', source, { args = { '^1[AdminCMD]', 'Player ^4' .. playerName .. '^0 has been forced to relog by Admin ^3' .. adminName } })
                
                -- Message to the player
                TriggerClientEvent('chat:addMessage', targetId, { args = { '^1[!]', 'You have been forced to relog by Admin ^3' .. adminName } })
                
                -- Send information to Discord Webhook with Embed
                local discordMessage = {
                    username = "Project-M Logs",
                    embeds = {{
                        title = "Forced Relog",
                        description = string.format("Admin **%s** forced a relog for player **%s**.", adminName, playerName),
                        color = 16711680, -- Hexadecimal for red color
                        timestamp = os.date("!%Y-%m-%dT%H:%M:%S")
                    }}
                }
                PerformHttpRequest(Config.Forcelog, function(err, text, headers) end, 'POST', json.encode(discordMessage), {['Content-Type'] = 'application/json'})
                
            else
                TriggerClientEvent('chat:addMessage', source, { args = { '[!]', 'The player ID entered does not exist.' } })
            end
        else
            TriggerClientEvent('chat:addMessage', source, { args = { '[!]', 'Please provide a Player ID.' } })
        end
    else
        TriggerClientEvent('chat:addMessage', source, { args = { '[!]', 'You do not have permission to use this command.' } })
    end
end, false)
local ESX = exports['es_extended']:getSharedObject()

-- Existing /ck command
RegisterCommand('ck', function(source, args, rawCommand)
    local xPlayer = ESX.GetPlayerFromId(source)
    local adminName = GetPlayerName(source)

    -- Check if the player is in any of the admin groups
    local isAdmin = false
    for _, group in ipairs(Config.AdminGroups) do
        if xPlayer.getGroup() == group then
            isAdmin = true
            break
        end
    end

    -- If the player is not an admin, deny access
    if not isAdmin then
        TriggerClientEvent('chat:addMessage', source, {
            args = { '[!]', "You don't have permission to use this command."}
        })
        return
    end

    -- Check if the player has provided an ID
    if not args[1] then
        TriggerClientEvent('chat:addMessage', source, {
            args = { '[!]', "Usage: /ck <id>"}
        })
        return
    end

    local targetId = tonumber(args[1])
    if not targetId then
        TriggerClientEvent('chat:addMessage', source, {
            args = { '[!]', "Invalid ID."}
        })
        return
    end

    local targetPlayer = ESX.GetPlayerFromId(targetId)
    if not targetPlayer then
        TriggerClientEvent('chat:addMessage', source, {
            args = { '[!]', "Player not found."}
        })
        return
    end

    local characterName = targetPlayer.getName()  -- Use character name instead of player name
    local identifier = targetPlayer.identifier

    -- Execute the SQL query to disable the user based on the identifier
    MySQL.Async.execute('UPDATE `users` SET `disabled` = 1 WHERE identifier = @identifier', {
        ['@identifier'] = identifier
    }, function(affectedRows)
        if affectedRows > 0 then
            TriggerClientEvent('chat:addMessage', source, {
                args = { '[!]', "^1Character disabled."}
            })

            -- Notify all players about the CK
            local message = string.format(Config.CKMessage, characterName, adminName)
            TriggerClientEvent('chat:addMessage', -1, {
                args = {  message}
            })

            TriggerEvent('esx:playerLogout', targetId)

            -- Send information to Discord Webhook with a simple Embed
            local discordMessage = {
                username = "Project-M Logs",
                embeds = {{
                    title = "Character Killed Logs",
                    description = string.format("**Admin:** %s\n**Character:** %s\n**Identifier:**", adminName, characterName, identifier),
                    color = 0xFF0000, -- Red color in hex
                    timestamp = os.date("!%Y-%m-%dT%H:%M:%S")
                }}
            }
            PerformHttpRequest(Config.CK, function(err, text, headers) end, 'POST', json.encode(discordMessage), {['Content-Type'] = 'application/json'})
        else
            TriggerClientEvent('chat:addMessage', source, {
                args = { '[!]', "Character not found or already disabled."}
            })
        end
    end)
end, false)


-- New /cklist command
RegisterCommand('cklist', function(source, args, rawCommand)
    local xPlayer = ESX.GetPlayerFromId(source)

    -- Check if the player is not in any of the admin groups
    local isAdmin = false
    for _, group in ipairs(Config.AdminGroups) do
        if xPlayer.getGroup() == group then
            isAdmin = true
            break
        end
    end

    -- If player is not in any admin group, deny access
    if not isAdmin then
        TriggerClientEvent('chat:addMessage', source, {
            args = { '[!]', "You don't have permission to use this command." }
        })
        return
    end

    -- Query the database for all disabled characters
    MySQL.Async.fetchAll('SELECT identifier, firstname, lastname FROM `users` WHERE `disabled` = 1', {}, function(results)
        if #results > 0 then
            -- Clear the current list of disabled characters
            local disabledCharacters = {}

            -- Create a message string with all disabled characters
            for index, row in ipairs(results) do
                local characterInfo = {
                    identifier = row.identifier,
                    name = row.firstname .. " " .. row.lastname,
                    number = index -- Add a number identifier for each disabled character
                }
                table.insert(disabledCharacters, characterInfo)
                ----
                TriggerClientEvent('chat:addMessage', source, {
                    args = {string.format("^1[Character Killed ID %d] ^0Name: %s,^4 %s", index, characterInfo.name,row.identifier) }
                })
            end

            -- Store the disabled characters for later enablement
            xPlayer.set('disabledCharacters', disabledCharacters)
        else
            -- Notify the admin if there are no disabled characters
            TriggerClientEvent('chat:addMessage', source, {
                args = { '[!]', "No disabled characters found." }
            })
        end
    end)
end, false)
-- Command to enable a specific character (previously /enablechar)
RegisterCommand('unck', function(source, args, rawCommand)
    local xPlayer = ESX.GetPlayerFromId(source)
    local adminName = GetPlayerName(source)

    local isAdmin = false
    for _, group in ipairs(Config.AdminGroups) do
        if xPlayer.getGroup() == group then
            isAdmin = true
            break
        end
    end

    if not isAdmin then
        TriggerClientEvent('chat:addMessage', source, {
            args = { '[!]', "You don't have permission to use this command." }
        })
        return
    end

    if #args ~= 1 then
        TriggerClientEvent('chat:addMessage', source, {
            args = { '[!]', "Usage: /unck [ID]" }
        })
        return
    end

    local disabledCharacters = xPlayer.get('disabledCharacters')
    if not disabledCharacters then
        TriggerClientEvent('chat:addMessage', source, {
            args = { '[!]', "No disabled character list found. Please run /cklist first." }
        })
        return
    end

    local number = tonumber(args[1])
    if not number or number < 1 or number > #disabledCharacters then
        TriggerClientEvent('chat:addMessage', source, {
            args = { '[!]', "Invalid character number." }
        })
        return
    end

    local characterToEnable = disabledCharacters[number]
    MySQL.Async.execute('UPDATE `users` SET `disabled` = 0 WHERE `identifier` = @identifier', {
        ['@identifier'] = characterToEnable.identifier
    }, function(rowsChanged)
        if rowsChanged > 0 then
            TriggerClientEvent('chat:addMessage', source, {
                args = { '[!]', string.format("Character ID %s (%s) has been enabled.", characterToEnable.identifier, characterToEnable.name) }
            })

            table.remove(disabledCharacters, number)
            xPlayer.set('disabledCharacters', disabledCharacters)

            -- Send information to Discord Webhook with embeds
            local discordMessage = {
                username = "Project-M Logs",
                embeds = {{
                    color = 3066993,  -- GREEN color
                    description = string.format("**Admin:** %s\n**Character Enabled:** %s\n**Identifier:** %s", adminName, characterToEnable.name, characterToEnable.identifier),
                    timestamp = os.date("!%Y-%m-%dT%H:%M:%S")
                }}
            }
            PerformHttpRequest(Config.UNCK, function(err, text, headers) end, 'POST', json.encode(discordMessage), {['Content-Type'] = 'application/json'})

        else
            TriggerClientEvent('chat:addMessage', source, {
                args = { '[!]', "Failed to enable character." }
            })
        end
    end)
end, false)