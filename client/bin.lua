local canHide = true
local dumpsters = {
    "prop_dumpster_01a",
    "prop_dumpster_02a",
    "prop_dumpster_02b",
    "prop_dumpster_4a",
    "prop_dumpster_4b"
}
local inTrash = false

RegisterNetEvent('tnj-dumpsters:getInBin', function()
    if canHide then
        local ped = PlayerPedId()
        local pos = GetEntityCoords(ped)

        for i = 1, #dumpsters do
            local dumpster = GetClosestObjectOfType(pos.x, pos.y, pos.z, 1.0, dumpsters[i], false, false, false)
            local dumpPos = GetEntityCoords(dumpster)
            local dist = GetDistanceBetweenCoords(pos.x, pos.y, pos.z, dumpPos.x, dumpPos.y, dumpPos.z, true)

            if dist < 1.8 then
                if not inTrash then
                AttachEntityToEntity(PlayerPedId(), dumpster, -1, 0.0, -0.3, 2.0, 0.0, 0.0, 0.0, false, false, false, false, 20, true)
                loadDict('timetable@floyd@cryingonbed@base')
                TaskPlayAnim(PlayerPedId(), 'timetable@floyd@cryingonbed@base', 'base', 8.0, -8.0, -1, 1, 0, false, false, false)
                Wait(50)
                SetEntityVisible(PlayerPedId(), false, false)
                inTrash = true
                exports['qb-core']:PersistentAlert('start', binNotif, 'inform', "[E] to get out.")
                else
                    QBCore.Functions.Notify("Someone is already hiding in here.", "error") -- [text] = message, [type] = primary | error | success, [length] = time till fadeout.
                end
            end
        end
    end
end)

local binNotif = "BIN_NOTIF"

Citizen.CreateThread(function()
    while true do
        Wait(0)
        if inTrash then
            local dumpster = GetEntityAttachedTo(PlayerPedId())
            local dumpPos = GetEntityCoords(dumpster)
            if DoesEntityExist(dumpster) or not IsPedDeadOrDying(PlayerPedId()) or not IsPedFatallyInjured(PlayerPedId()) then
                SetEntityCollision(PlayerPedId(), false, false)
                if not IsEntityPlayingAnim(PlayerPedId(), 'timetable@floyd@cryingonbed@base', 3) then
                    loadDict('timetable@floyd@cryingonbed@base')
                    TaskPlayAnim(PlayerPedId(), 'timetable@floyd@cryingonbed@base', 'base', 8.0, -8.0, -1, 1, 0, false, false, false)
                end
                if IsControlJustReleased(0, 38) and inTrash then
                    SetEntityCollision(PlayerPedId(), true, true)
                    inTrash = false
                    DetachEntity(PlayerPedId(), true, true)
                    SetEntityVisible(PlayerPedId(), true, false)
                    ClearPedTasks(PlayerPedId())
                    SetEntityCoords(PlayerPedId(), GetOffsetFromEntityInWorldCoords(PlayerPedId(), 0.0, -0.7, -0.75))
                    Wait(250)
                end
            else
                SetEntityCollision(PlayerPedId(), true, true)
                DetachEntity(PlayerPedId(), true, true)
                SetEntityVisible(PlayerPedId(), true, false)
                ClearPedTasks(PlayerPedId())
                SetEntityCoords(PlayerPedId(), GetOffsetFromEntityInWorldCoords(PlayerPedId(), 0.0, -0.7, -0.75))
                exports['qb-core']:PersistentAlert('end', binNotif)
            end
        end
    end
end)

loadDict = function(dict)
    while not HasAnimDictLoaded(dict) do Wait(0) RequestAnimDict(dict) end
end

RegisterCommand("resetTrash", function(source, args, rawCommand)

    --SetEntityCollision(PlayerPedId(), true, true)

    inTrash = false
    DetachEntity(PlayerPedId(), true, true)
    SetEntityVisible(PlayerPedId(), true, false)
    ClearPedTasks(PlayerPedId())
    SetEntityCoords(PlayerPedId(), GetOffsetFromEntityInWorldCoords(PlayerPedId(), 0.0, -0.5, -0.75))

    print("Reset Trash")
end, false)
