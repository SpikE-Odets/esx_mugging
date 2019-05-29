ESX                           = nil
lastrobbed = 0
local robbing = false
local currentrobbing = false
local giveableItems = {
    'weed_pooch',
	'water',
	'bread',
	'lighter',
	'coke_pooch',
	'vodka',
	'lsd_pooch',
	'soda'
}


Citizen.CreateThread(function()

	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
    ESX.PlayerData = ESX.GetPlayerData()
end)


Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        if robbing then

        else  
        if IsPlayerFreeAiming(PlayerId()) then
            local aiming, targetPed = GetEntityPlayerIsFreeAimingAt(PlayerId())
                if IsPedArmed(GetPlayerPed(-1), 7) and IsPedArmed(GetPlayerPed(-1), 4) and ESX.PlayerData.job.name ~= 'police' and not IsPedAPlayer(targetPed)  then
                    if aiming then
                    local playerPed = GetPlayerPed(-1)
                    local pCoords = GetEntityCoords(playerPed, true)
                    local tCoords = GetEntityCoords(targetPed, true)
                        if DoesEntityExist(targetPed) and IsEntityAPed(targetPed) and not IsPedDeadOrDying(targetPed) then
                            SetEntityAsMissionEntity(targetPed, true, true)
                            if GetDistanceBetweenCoords(pCoords.x, pCoords.y, pCoords.z, tCoords.x, tCoords.y, tCoords.z, true) <= 5.0 then
                                if IsPedInAnyVehicle(targetPed, true) then
                                    local localvehicle = GetVehiclePedIsIn(targetPed, false)
                                    if IsVehicleStopped(localvehicle) then
                                        TaskLeaveVehicle(targetPed, localvehicle, 1)
                                        ClearPedTasks(targetPed)
                                        Citizen.Wait(1000)
                                        if not robbing then
                                            robNpc(targetPed)
                                        end
                                    end
                                elseif not robbing then
                                    robNpc(targetPed)
                                end
                            end
                        end    
                    end
                end
            end
        end  
    end
end)

function robNpc(targetPed)
    Citizen.CreateThread(function()
    local roblocalcoords = GetEntityCoords(targetPed)
    if not currentrobbing then 
    ESX.Game.Utils.DrawText3D(roblocalcoords, "[~g~E~s~] to Mug", 0.25)
    elseif lasttargetPed == targetPed then
    ESX.Game.Utils.DrawText3D(roblocalcoords, "Already Mugged..", 0.25)
    else
    ESX.Game.Utils.DrawText3D(roblocalcoords, "Mugging..", 0.25)
    end
    TaskHandsUp(targetPed, 5500, 0, 0, true)
        if IsControlJustReleased(0, 38) then
            if not currentrobbing then
                if lasttargetPed == targetPed then
                    PlayAmbientSpeech1(targetPed, "GUN_BEG", "SPEECH_PARAMS_FORCE_NORMAL_CLEAR")
                    currentrobbing = true
                    TaskHandsUp(targetPed, 1000, 0, 0, true)
                    ESX.ShowNotification("Already Mugged this person.")
                    SetEntityAsNoLongerNeeded(targetPed)
                    TaskSmartFleePed(targetPed, GetPlayerPed(-1), -1, -1, true, true)
                    Citizen.Wait(3000)
                    robbing = false
                    currentrobbing = false
                else
                    PlayAmbientSpeech1(targetPed, "GUN_BEG", "SPEECH_PARAMS_FORCE_NORMAL_CLEAR")
                    currentrobbing = true
                    TaskHandsUp(targetPed, Config.RobWaitTime * 1000, 0, 0, true)
                    --exports['progressBars']:startUI(Config.RobWaitTime * 1000, "Mugging...")
                    Citizen.Wait(Config.RobWaitTime * 1000)
                    if not IsPedFleeing(targetPed) then
                       if not IsPedDeadOrDying(targetPed) then
                            TriggerServerEvent("esx_muggings:giveMoney")
                            additems = math.random(1,100)
                                if additems <= Config.AddItemsPerctent then
                                        randomitemcount = math.random(1,Config.AddItemsMax)
                                    for i = randomitemcount,1,-1
                                    do
                                        local itemName = giveableItems[GetRandomIntInRange(1,  #giveableItems)]
                                        TriggerServerEvent('esx_muggings:giveItems', (itemName))
                                    end
                                end
                            randomact = math.random(1,10)
                            if randomact > 6 then
                                PlayAmbientSpeech1(targetPed, "GENERIC_INSULT_HIGH", "SPEECH_PARAMS_FORCE_NORMAL_CLEAR")
                            elseif randomact > 3 then
                                PlayAmbientSpeech1(targetPed, "GENERIC_FRIGHTENED_HIGH", "SPEECH_PARAMS_FORCE_NORMAL_CLEAR")
                            end
                            robbing = true
                            lastrobbed = math.random(1, 100)
                            if lastrobbed <= Config.PoliceNotify then
                                    ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin, jobSkin)
                                    local sex = nil
                                    if skin.sex == 0 then
                                        sex = "Male" --male/change it to your language
                                    else
                                        sex = "Female" --female/change it to your language
                                    end
                                    TriggerServerEvent('esx_mugging:muggingPos', plyPos.x, plyPos.y, plyPos.z)

                                    if s2 == 0 then
                                        TriggerServerEvent('esx_mugging:muggingAlertS1', street1, sex)
                                    elseif s2 ~= 0 then
                                        TriggerServerEvent('esx_mugging:muggingAlert', street1, street2, sex)
                                    end
                                end)
                            end
                            SetEntityAsNoLongerNeeded(targetPed)
                            TaskSmartFleePed(targetPed, GetPlayerPed(-1), -1, -1, true, true)
                            Citizen.Wait(3000)

                            lasttargetPed = targetPed
                            robbing = false
                            currentrobbing = false
                        else
                            if Config.AlwaysNotifyonDeath then
                                SetEntityAsNoLongerNeeded(targetPed)
                                ESX.ShowNotification("Target died - Police will be notified")
                                ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin, jobSkin)
                                    local sex = nil
                                    if skin.sex == 0 then
                                        sex = "Male" --male/change it to your language
                                    else
                                        sex = "Female" --female/change it to your language
                                    end
                                    TriggerServerEvent('esx_mugging:muggingPos', plyPos.x, plyPos.y, plyPos.z)
                                    TriggerServerEvent('esx_mugging:muggingAlertS2', street1, sex)

                                end)
                            end
                            robbing = false
                            currentrobbing = false
                        end
                    else
                        ESX.ShowNotification("Target ran away")
                        SetEntityAsNoLongerNeeded(targetPed)
                        lastrobbed = math.random(1, 100)
                        if lastrobbed <= Config.PoliceNotify then
                            ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin, jobSkin)
                                local sex = nil
                                if skin.sex == 0 then
                                    sex = "Male" --male/change it to your language
                                else
                                    sex = "Female" --female/change it to your language
                                end
                                TriggerServerEvent('esx_mugging:muggingPos', plyPos.x, plyPos.y, plyPos.z)
                                if s2 == 0 then
                                    TriggerServerEvent('esx_mugging:muggingAlertS1', street1, sex)
                                elseif s2 ~= 0 then
                                    TriggerServerEvent('esx_mugging:muggingAlert', street1, street2, sex)
                                end
                            end)
                        end
                        robbing = false
                        currentrobbing = false
                    end
                end
            end
        end
    end)
end

GetPlayerName()
RegisterNetEvent('muggingNotify')
AddEventHandler('muggingNotify', function(alert, xPlayer)
        if  ESX.PlayerData.job.name == 'police' then       
        ESX.ShowAdvancedNotification('911 Emergency', 'Mugging', alert, 'CHAR_CALL911', 1)
        end
end)

function Notify(text)
    SetNotificationTextEntry('STRING')
    AddTextComponentString(text)
    DrawNotification(false, false)
end

RegisterNetEvent('esx_mugging:muggingPos')
AddEventHandler('esx_mugging:muggingPos', function(tx, ty, tz)
	if ESX.PlayerData.job.name == 'police' then
		local transT = 250
		local Blip = AddBlipForCoord(tx, ty, tz)
		SetBlipSprite(Blip,  10)
		SetBlipColour(Blip,  1)
		SetBlipAlpha(Blip,  transT)
		SetBlipAsShortRange(Blip,  false)
		while transT ~= 0 do
			Wait(100)
			transT = transT - 1
			SetBlipAlpha(Blip,  transT)
			if transT == 0 then
				SetBlipSprite(Blip,  2)
				return
			end
		end
	end
end)
