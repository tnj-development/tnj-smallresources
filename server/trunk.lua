QBCore = exports['qb-core']:GetCoreObject()

--- Trunk functions ---
RegisterNetEvent("qb_gameplay:requestTrunk")
AddEventHandler("qb_gameplay:requestTrunk", function(target, veh, remove)
	if remove then
		TriggerClientEvent('qb_gameplay:handleTrunk', target, false)
	else
		TriggerClientEvent('qb_gameplay:handleTrunk', target, veh)
	end
end)

RegisterNetEvent("gameplay:server:toggleTrunkDoor")
AddEventHandler("gameplay:server:toggleTrunkDoor", function(veh)
    local _source = source
    local owner = NetworkGetEntityOwner(NetworkGetEntityFromNetworkId(veh))
    TriggerClientEvent("gameplay:client:toggleTrunkDoor", owner, veh)
end)