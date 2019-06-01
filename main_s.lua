ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
local copsConnected = 0


function CountCops()

    local xPlayers = ESX.GetPlayers()
    copsConnected = 0

    for i=1, #xPlayers, 1 do
        local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
        if xPlayer.job.name == 'police' then
            copsConnected = copsConnected + 1
        end
    end
    TriggerClientEvent('esx_mugging:copsConnected', -1, copsConnected)

    SetTimeout(60000, CountCops)

end
CountCops()

RegisterServerEvent('esx_mugging:giveMoney')
AddEventHandler('esx_mugging:giveMoney', function()
    local _source = source
    local player = ESX.GetPlayerFromId(_source)
    local amount = math.random(Config.MinMoney, Config.MaxMoney)
    if Config.DirtyMoney then
        print('trying to add dirty money')
        player.addAccountMoney('black_money', amount)
    else
        print('tring to add cash')
        player.addMoney(amount)
    end
    TriggerClientEvent("esx:showNotification", source, ("You stole $%s"):format(amount))
end)

RegisterServerEvent('esx_mugging:giveItems')
AddEventHandler('esx_mugging:giveItems', function(itemName)
    local _source = source
	local xPlayer  = ESX.GetPlayerFromId(_source)
        xPlayer.addInventoryItem(itemName, 1)

end)



RegisterServerEvent('esx_mugging:muggingAlert')
AddEventHandler('esx_mugging:muggingAlert', function(street1, street2, sex, coords)
    if Config.GCPhone  then
        TriggerClientEvent("muggingNotify", -1, "Reported Mugging by "..sex.." near "..street1.." and "..street2, coords)
    else
	    TriggerClientEvent("muggingNotify", -1, "~r~Reported Mugging by ~w~ "..sex.." ~r~near~w~ "..street1.." and "..street2, coords)
    end
end)


RegisterServerEvent('esx_mugging:muggingAlertS1')
AddEventHandler('esx_mugging:muggingAlertS1', function(street1, sex, coords)
    if Config.GCPhone  then
        TriggerClientEvent("muggingNotify", -1, "Reported Mugging by "..sex.." near "..street1, coords)
    else
	    TriggerClientEvent("muggingNotify", -1, "~r~Reported Mugging by~w~ "..sex.." ~r~near~w~ "..street1, coords)
    end
end)
RegisterServerEvent('esx_mugging:muggingAlertS2')
AddEventHandler('esx_mugging:muggingAlertS2', function(street1, sex, coords)
    if Config.GCPhone then
        TriggerClientEvent("muggingNotify", -1, "Reported Murder by "..sex.." near "..street1, coords)
    else
        TriggerClientEvent("muggingNotify", -1, "~r~Reported Murder by~w~ "..sex.." ~r~near~w~ "..street1, coords)
    end
end)

RegisterServerEvent('esx_mugging:muggingPos')
AddEventHandler('esx_mugging:muggingPos', function(gx, gy, gz)
	TriggerClientEvent('esx_mugging:muggingPos', -1, gx, gy, gz)
end)

