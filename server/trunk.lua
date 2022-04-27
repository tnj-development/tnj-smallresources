QBCore = exports['qb-core']:GetCoreObject()

--- Trunk functions ---
RegisterNetEvent("tnj-smallresources:requestTrunk")
AddEventHandler("tnj-smallresources:requestTrunk", function(target, veh, remove)
	if remove then
		TriggerClientEvent('tnj-smallresources:handleTrunk', target, false)
	else
		TriggerClientEvent('tnj-smallresources:handleTrunk', target, veh)
	end
end)

RegisterNetEvent("tnj-smallresources:server:toggleTrunkDoor")
AddEventHandler("tnj-smallresources:server:toggleTrunkDoor", function(veh)
    local _source = source
    local owner = NetworkGetEntityOwner(NetworkGetEntityFromNetworkId(veh))
    TriggerClientEvent("tnj-smallresources:client:toggleTrunkDoor", owner, veh)
end)
