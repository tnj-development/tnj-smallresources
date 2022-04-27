QBCore = exports['qb-core']:GetCoreObject()

RegisterServerEvent("TBH:SyncAll")
AddEventHandler("TBH:SyncAll", function(event, args)
	if args ~= nil then
		TriggerClientEvent(event, -1, table.unpack(args))
	else
		TriggerClientEvent(event, -1)
	end
end)

QBCore.Commands.Add("btf", "BTF", {}, false, function(source, args)
    TriggerClientEvent("utils:btf", source)
end, "god")