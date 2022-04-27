QBCore = exports['qb-core']:GetCoreObject()

RegisterNetEvent('tnj-smallresources:practicelaptop')
AddEventHandler('tnj-smallresources:practicelaptop', function(data)
    exports['hacking']:OpenHackingGame(7, 4, 1, function(Success)
        if Success then
            QBCore.Functions.Notify("Completed Successfully.", "primary") -- [text] = message, [type] = primary | error | success, [length] = time till fadeout.
        else
            QBCore.Functions.Notify("Failed.", "error")
        end
    end)
end)
