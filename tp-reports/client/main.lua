ESX = nil
fontId = nil

local loadedPlayer = false

local guiEnabled, isDead = false, false
local myIdentity = {}
local isWhitelisted = false
local uiType = 'enableui'

Citizen.CreateThread(function()
  while ESX == nil do
    TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
    Citizen.Wait(5)
  end

	ESX.PlayerData = ESX.GetPlayerData()

	Wait(1500)

	ESX.TriggerServerCallback("tp-reports:fetchUserGroup", function(playerGroup)
        if Config.WhitelistedGroups[playerGroup] then
			isWhitelisted = true
		end
	end)
  
end)

AddEventHandler('esx:onPlayerDeath', function(data)
	isDead = true

	if guiEnabled then
		EnableGui(false, uiType)
	end
end)

AddEventHandler('playerSpawned', function(spawn)
	isDead = false
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
  Citizen.Wait(1000)

  ESX.PlayerData = xPlayer

end)

RegisterNetEvent('tp-reports:teleportUser')
AddEventHandler('tp-reports:teleportUser', function(x, y, z)
	SetEntityCoords(PlayerPedId(), x, y, z)
end)

function EnableGui(state, ui)
	SetNuiFocus(state, state)
	guiEnabled = state

	SendNUIMessage({
		type = ui,
		enable = state
	})

end

RegisterCommand('report', function(source, args) 
  CancelEvent()
  if args and #args > 0 then
 
    TriggerEvent('chat:addMessage', {color = { 255, 0, 0},multiline = true,args = {Config.ServerPrefix, " Please, use - /report to submit a report."}})
    return
  end

  if not isDead then

	EnableGui(true, "enableui")

	uiType = "enableui"
  end
  
end, false)

RegisterCommand('reports', function(source, args) 
	CancelEvent()

	if not isWhitelisted then
		ESX.ShowNotification('~r~You do not have sufficient permissions to perform this action.')
		return
	end

	if args and #args > 0 then
	  TriggerEvent('chat:addMessage', {color = { 255, 0, 0},multiline = true,args = {Config.ServerPrefix, " Please, use - /reports to submit a report."}})
	  return
	end
  
	if not isDead then
  
	  local inProgress = 0

	    ESX.TriggerServerCallback('tp-reports:getReports', function(cb_reports)
			ESX.TriggerServerCallback('tp-reports:getSolvedReports', function(solvedReports)
				Wait(500)

				for k,v in pairs(cb_reports)do
					SendNUIMessage({
						action = 'addReport',
						reports_det = v,
						reports_id  = k,
					})		
	
					if v.currentState == "INPROGRESS" then
						inProgress = inProgress + 1
					end
				end
	
				Wait(500)
		
				uiType = "enablereportsui"
	
				SendNUIMessage({
					action = 'addReportInformation',
					currentReports = #cb_reports,
					inProgress = #cb_reports,
					solvedReports = solvedReports,
				})		
	
				EnableGui(true, uiType)
		
			end)
		end)
	end
	
end, false)

RegisterNUICallback('closeNUI', function()
	EnableGui(false, uiType)
end)

RegisterNUICallback('teleportTo', function(table)
	local _source = table.source

	SendNUIMessage({
		action = 'clearReports',
	})	
	EnableGui(false, uiType)
	Wait(500)
	
	TriggerServerEvent("tp-reports:teleportTo", _source)

end)

RegisterNUICallback('changeStatus', function(table)

	TriggerServerEvent("tp-reports:setElementAsSolved", table.reportId)

	SendNUIMessage({
		action = 'clearReports',
	})	

	EnableGui(false, uiType)
end)



RegisterNUICallback('submitReport', function(data, cb)
	local reason = ""
	myIdentity = data

	for theData, value in pairs(myIdentity) do

		if theData == "description" then

			if value == "" or value == " " or value == nil or value == "invalid" then
				data.description = "N/A"
			end


		elseif theData == 'reason' then

			if value == " " or value == nil or value == "invalid" or value == "Select A Reason" then
				reason = "~r~Reason / Report type not selected."
				break
			end

		end

	end

	if data.descriptionLength > 298 then
		reason = "~r~Report description is too long."
	end
	
	if reason == "" then

		TriggerServerEvent("tp-reports:submitReport", data.reason, data.description)

	else
		ESX.ShowNotification(reason)
	end
	EnableGui(false, uiType)
end)



function firstToUpper(str)
  return (str:gsub("^%l", string.upper))
end


Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)

		if guiEnabled then


			DisableControlAction(0, 1,   true) -- LookLeftRight
			DisableControlAction(0, 2,   true) -- LookUpDown
			DisableControlAction(0, 106, true) -- VehicleMouseControlOverride
			DisableControlAction(0, 142, true) -- MeleeAttackAlternate
			DisableControlAction(0, 30,  true) -- MoveLeftRight
			DisableControlAction(0, 31,  true) -- MoveUpDown
			DisableControlAction(0, 21,  true) -- disable sprint
			DisableControlAction(0, 24,  true) -- disable attack
			DisableControlAction(0, 25,  true) -- disable aim
			DisableControlAction(0, 47,  true) -- disable weapon
			DisableControlAction(0, 58,  true) -- disable weapon
			DisableControlAction(0, 263, true) -- disable melee
			DisableControlAction(0, 264, true) -- disable melee
			DisableControlAction(0, 257, true) -- disable melee
			DisableControlAction(0, 140, true) -- disable melee
			DisableControlAction(0, 141, true) -- disable melee
			DisableControlAction(0, 143, true) -- disable melee
			DisableControlAction(0, 75,  true) -- disable exit vehicle
			DisableControlAction(27, 75, true) -- disable exit vehicle
		else
			Citizen.Wait(1000)
		end
	end
end)

function miid(x, y, width, height, scale, text)
  SetTextFont(4)
  SetTextProportional(0)
  SetTextScale(scale, scale)
  SetTextColour( 0,0,0, 255 )
  SetTextDropShadow(0, 0, 0, 0,255)
  SetTextEdge(1, 0, 0, 0, 255)
  SetTextDropShadow()
  SetTextOutline()
  SetTextEntry("STRING")
  AddTextComponentString(text)
  DrawText(x - width/2, y - height/2 + 0.005)
 end 

function sendNotification(message, messageType, messageTimeout)
	TriggerEvent("pNotify:SendNotification", {
		text = message,
		type = messageType,
		queue = "warnings_notification",
		timeout = messageTimeout,
		layout = "bottomLeft"
	})
end