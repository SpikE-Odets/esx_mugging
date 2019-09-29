ESX                           = nil
local lastrobbed, copsConnected, cooldowntime = 0,0,0
local robbing, currentrobbing, notneeded, checkforvoice, IsMuggingAllowed  = false, false, false, false, true
local playerPed, pCoords, tCoords = nil, nil, nil


Citizen.CreateThread(function()
    while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
	while ESX.GetPlayerData().job == nil do
		Citizen.Wait(10)
	end
	ESX.PlayerData = ESX.GetPlayerData()
end)

--[[Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        while checkforvoice do
            Citizen.Wait(0)
            NetworkIsPlayerTalking(PlayerId()) then
            currentrobbing = true
            checkforvoice = false
        end
    end
end)]]

function voicecheck()
   
end


function CoolDown()
    cooldowntime = Config.CoolDownTime
    while not IsMuggingAllowed do
        Wait(1000)
        cooldowntime = cooldowntime - 1
        if cooldowntime == 0 then
            IsMuggingAllowed = true
        end
    end
end


Citizen.CreateThread(function()
    while true do
    Citizen.Wait(0)
    if not robbing and not IsPedInAnyVehicle(GetPlayerPed(-1),true) then
        if IsPlayerFreeAiming(PlayerId()) then
            local aiming, targetPed = GetEntityPlayerIsFreeAimingAt(PlayerId())
            if IsPedArmed(GetPlayerPed(-1), 7) and IsPedArmed(GetPlayerPed(-1), 4) and ESX.PlayerData.job.name ~= 'police' and not IsPedFleeing(targetPed) and not IsPedAPlayer(targetPed) and IsPedHuman(targetPed) and not IsEntityAMissionEntity(targetPed) and copsConnected >= Config.CopsNeeded then
                    if aiming then
                    playerPed = GetPlayerPed(-1)
                    pCoords = GetEntityCoords(playerPed, true)
                    tCoords = GetEntityCoords(targetPed, true)
                        if DoesEntityExist(targetPed) and IsEntityAPed(targetPed) and not IsPedDeadOrDying(targetPed) then
                            if GetDistanceBetweenCoords(pCoords.x, pCoords.y, pCoords.z, tCoords.x, tCoords.y, tCoords.z, true) <= 5.0 then
                                if IsPedInAnyVehicle(targetPed, true) then
                                    local localvehicle = GetVehiclePedIsIn(targetPed, false)
                                    if IsVehicleStopped(localvehicle) and not robbing and IsMuggingAllowed then
                                        TaskLeaveVehicle(targetPed, localvehicle, 1)
					incar = true
					while incar do
					  Citizen.Wait(100)
					  if IsPedInAnyVehicle(targetPed, false) then incar = false end
					end
                                        ResetPedLastVehicle(targetPed)
                                        ClearPedTasks(targetPed)
                                        if targetPed == lasttargetPed then
                                            AddShockingEventAtPosition(99, GetEntityCoords(targetPed),0.5)  
                                        elseif not robbing and IsMuggingAllowed then
                                            robNpc(targetPed)
                                        end
                                    end
                                else 
                                    if targetPed == lasttargetPed then
                                        AddShockingEventAtPosition(99, GetEntityCoords(targetPed),0.5)  
                                    elseif not robbing and IsMuggingAllowed then
                                        robNpc(targetPed)
                                    end
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
        Citizen.Wait(0)
        local roblocalcoords = GetEntityCoords(targetPed)
        if not currentrobbing then 
            if Config.MustUseVoice then
                ESX.Game.Utils.DrawText3D(roblocalcoords, "Mug...", 0.25)
            else
                ESX.Game.Utils.DrawText3D(roblocalcoords, "[~g~E~s~] to Mug", 0.25)
            end
        elseif lasttargetPed == targetPed then
            ESX.Game.Utils.DrawText3D(roblocalcoords, "Already Mugged..", 0.25)
        else
            if not Config.progressBars then
            ESX.Game.Utils.DrawText3D(roblocalcoords, "Mugging..", 0.25)
            end
        end
        TaskHandsUp(targetPed, 5500, 0, 0, true)
        if Config.MustUseVoice and NetworkIsPlayerTalking(PlayerId()) then notneeded = true end
        if not Config.MustUseVoice and IsControlJustReleased(0,38) then notneeded = true end
        if notneeded then
            notneeded = false
            local plyPos = GetEntityCoords(GetPlayerPed(-1),  true)
            local s1, s2 = Citizen.InvokeNative( 0x2EB41072B4C1E4C0, plyPos.x, plyPos.y, plyPos.z, Citizen.PointerValueInt(), Citizen.PointerValueInt() )
            local street1 = GetStreetNameFromHashKey(s1)
            local street2 = GetStreetNameFromHashKey(s2)
            local reportcoords = {
                x = plyPos.x,
                y = plyPos.y,
                z = plyPos.z - 1,
            }
            if not currentrobbing then
                PlayAmbientSpeech1(targetPed, "GUN_BEG", "SPEECH_PARAMS_FORCE_NORMAL_CLEAR")
                currentrobbing = true
                TaskHandsUp(targetPed, Config.RobWaitTime * 1000, 0, 0, true)
                if Config.progressBars then
                    exports['progressBars']:startUI(Config.RobWaitTime * 1000, "Mugging...")
                end 
                Citizen.Wait(Config.RobWaitTime * 1000)
                playerPed = GetPlayerPed(-1)
                pCoords = GetEntityCoords(playerPed, true)
                tCoords = GetEntityCoords(targetPed, true)
                if GetDistanceBetweenCoords(pCoords.x, pCoords.y, pCoords.z, tCoords.x, tCoords.y, tCoords.z, true) <= 5.0 then 
                    if not IsPedDeadOrDying(targetPed) then
                        AddShockingEventAtPosition(99, GetEntityCoords(targetPed),0.5)
                        TriggerServerEvent("esx_mugging:giveMoney")
                        additems = math.random(1,100)
                            if additems <= Config.AddItemsPerctent then
                                    randomitemcount = math.random(1,Config.AddItemsMax)
                                for i = randomitemcount,1,-1
                                do
                                    local randomitempull = math.random(1, #Config.giveableItems)
                                    local itemName = Config.giveableItems[randomitempull]
                                    TriggerServerEvent('esx_mugging:giveItems', (itemName))
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
                                    TriggerServerEvent('esx_mugging:muggingAlertS1', street1, sex, reportcoords)
                                elseif s2 ~= 0 then
                                    TriggerServerEvent('esx_mugging:muggingAlert', street1, street2, sex, reportcoords)
                                end
                            end)
                        end
                        lasttargetPed = targetPed
                        robbing = false
                        currentrobbing = false
                        if Config.CoolDownTime ~= 0 then
                            IsMuggingAllowed = false
                            CoolDown()
                        end
                    else
                        
                        if Config.CoolDownTime ~= 0 then
                            IsMuggingAllowed = false
                            CoolDown()
                        end
                        if Config.AlwaysNotifyonDeath then
                            ESX.ShowNotification("Target died - Police will be notified")
                            ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin, jobSkin)
                                local sex = nil
                                if skin.sex == 0 then
                                    sex = "Male" --male/change it to your language
                                else
                                    sex = "Female" --female/change it to your language
                                end
                                TriggerServerEvent('esx_mugging:muggingPos', plyPos.x, plyPos.y, plyPos.z)
                                TriggerServerEvent('esx_mugging:muggingAlertS2', street1, sex, reportcoords)

                            end)
                        end
                        robbing = false
                        currentrobbing = false
                    end
                else
                    if Config.CoolDownTime ~= 0 then
                        IsMuggingAllowed = false
                        CoolDown()
                    end
                    ESX.ShowNotification("To far away from target")
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
                                TriggerServerEvent('esx_mugging:muggingAlertS1', street1, sex, plyPos)
                            elseif s2 ~= 0 then
                                TriggerServerEvent('esx_mugging:muggingAlert', street1, street2, sex, reportcoords)
                            end
                        end)
                    end
                    robbing = false
                    currentrobbing = false
                end
            end
        end
    end)
end

RegisterNetEvent('esx_mugging:copsConnected')
AddEventHandler('esx_mugging:copsConnected', function(copsNumber)
    copsConnected = copsNumber
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
	ESX.PlayerData.job = job
end)

RegisterNetEvent('muggingNotify')
AddEventHandler('muggingNotify', function(alert, xPlayer, coords)
        if  ESX.PlayerData.job.name == 'police' then  
            if Config.GCPhone then 
                TriggerServerEvent('esx_phone:send', "police", alert, true, coords)    
            else
                ESX.ShowAdvancedNotification('911 Emergency', 'Mugging', alert, 'CHAR_CALL911', 1)
            end
        end
end)



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


