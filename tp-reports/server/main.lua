ESX = nil

CurrentReportsTable = {}

local solvedReports   = 0

TriggerEvent('esx:getSharedObject', function(obj) 
    ESX = obj 
end)


ESX.RegisterServerCallback('tp-reports:getReports', function(source,cb)
	cb(CurrentReportsTable)
end)

ESX.RegisterServerCallback('tp-reports:getSolvedReports', function(source,cb)
	cb(solvedReports)
end)

RegisterServerEvent('tp-reports:setElementAsSolved')
AddEventHandler('tp-reports:setElementAsSolved', function(_reportId, _currentState)

	CurrentReportsTable[tonumber(_reportId)] = nil

	TriggerClientEvent('esx:showNotification', source, "~b~Report has been set as solved, removing from list.", true)

	solvedReports = solvedReports + 1
end)

RegisterServerEvent('tp-reports:submitReport')
AddEventHandler('tp-reports:submitReport', function(reason, description)

    local _source = source
    local identifier = GetPlayerIdentifiers(_source)[1]

	time = os.date("*t") 
	local currentDate, currentTime = table.concat({time.day, time.month, "2022"}, "/"), table.concat({time.hour, time.min}, ":")

	table.insert(CurrentReportsTable,{
		source          = _source,
		name            = GetPlayerName(_source),
		reason          = reason,
		description     = description,
		currentDateTime = currentTime .. ' '.. currentDate,
		currentState    = "INPROGRESS",
	})

	if Config.STORE_IN_SQL then
		MySQL.Async.execute('INSERT INTO user_reports (identifier, name, reason, description, dnt) VALUES (@identifier, @name, @reason, @description, @dnt)',
		{
			["@identifier"] = identifier, 
			["@name"] = GetPlayerName(_source),
			["@reason"] = reason,
			["@description"] = description,
			["@dnt"] = currentTime .. " " .. currentDate,
	
		},function()
		end)
	end

	if Config.USE_WEBHOOK then
		sendToDiscord(Config.WEBHOOK, GetPlayerName(source), "**The referred player submitted a new report:** \n\n**Reason:** ".. reason .. "\n\n**Description:**\n\n".. description .. "\n\n**Source ID:**\n\n".. _source)
	end

	TriggerClientEvent('esx:showNotification', source, "~g~You successfully submitted a new report.", true)

end)


RegisterServerEvent('tp-reports:teleportTo')
AddEventHandler('tp-reports:teleportTo', function(target_source)
    local _source = source

    if GetPlayerName(target_source) == nil then
		TriggerClientEvent('esx:showNotification', _source, "~r~The selected player is not online to perform this action.", true)
		return
	end

	local destPed = GetPlayerPed(target_source)
	local coords = GetEntityCoords(destPed)

	TriggerClientEvent('tp-reports:teleportUser', _source, coords.x,coords.y, coords.z)

end)


ESX.RegisterServerCallback("tp-reports:fetchUserGroup", function(source, cb)
	local player = ESX.GetPlayerFromId(source)
  
	if player then
		local playerGroup = player.getGroup()
  
		if playerGroup then 
			cb(playerGroup)
		else
			cb("user")
		end
	else
		cb("user")
	end
end)

-- METHOD FOR SENDING MESSAGES ON CHANNELS
function sendToDiscord(webhook, name, message, color)
	local connect = {
		  {
			  ["color"] = color,
			  ["title"] = "**".. name .."**",
			  ["description"] = message,
			  ["footer"] = {
			  ["text"] = Config.DISCORD_FOOTER,
		  },
	  }
  }
  PerformHttpRequest(webhook, function(err, text, headers) end, 'POST', json.encode({username = DISCORD_NAME, embeds = connect, avatar_url = DISCORD_IMAGE}), { ['Content-Type'] = 'application/json' })
end