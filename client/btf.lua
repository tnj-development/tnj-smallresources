QBCore = exports['qb-core']:GetCoreObject()

local ffires = {}
RegisterNetEvent('utils:btf')
AddEventHandler("utils:btf", function()
    QBCore.Functions.Notify("Let's go back to the future! Get to 88MPH.", "success") -- [text] = message, [type] = primary | error | success, [length] = time till fadeout.
	Citizen.CreateThread(function()
		while GetEntitySpeed(GetVehiclePedIsIn(PlayerPedId(), true)) * 2.236936 < 88 do
			Wait(50)
		end
		
		local count = 0
		
		while count < 60 do
			if count == 44 then
				TriggerServerEvent("TBH:SyncAll", "TBH:EndBtf", GetEntityCoords(PlayerPedId()))
			end
			Wait(10)
			SetEntityInvincible(PlayerPedId(), true)
			local x, y, z = table.unpack(GetOffsetFromEntityInWorldCoords(PlayerPedId(), -1.0, -1.0, 0.0))
			
			--table.insert(fires, StartScriptFire(x, y, z, 1, true))
			--table.insert(fires, StartScriptFire(x2, y2, z2, 1, true))
			TriggerServerEvent("TBH:SyncAll", "TBH:SyncFire", {x, y, z})
			x, y, z = table.unpack(GetOffsetFromEntityInWorldCoords(PlayerPedId(), 1.0, -1.0, 0.0))
			TriggerServerEvent("TBH:SyncAll", "TBH:SyncFire", {x, y, z})
			count = count + 2
		end
		
		local WaypointHandle = GetFirstBlipInfoId(8)

        if DoesBlipExist(WaypointHandle) then
            local waypointCoords = GetBlipInfoIdCoord(WaypointHandle)

            for height = 1, 1000 do
                SetPedCoordsKeepVehicle(PlayerPedId(), waypointCoords["x"], waypointCoords["y"], height + 0.0)

                local foundGround, zPos = GetGroundZFor_3dCoord(waypointCoords["x"], waypointCoords["y"], height + 0.0)

                if foundGround then
                    SetPedCoordsKeepVehicle(PlayerPedId(), waypointCoords["x"], waypointCoords["y"], height + 0.0)

                    break
                end

                Citizen.Wait(5)
            end
        end
	end)
end)

RegisterNetEvent("TBH:EndBtf")
AddEventHandler("TBH:EndBtf", function(x, y, z)
	ForceLightningFlash()
	local plyPos = GetEntityCoords(PlayerPedId())
	if GetDistanceBetweenCoords(x, y, z, plyPos.x, plyPos.y, plyPos.z) < 100 then
		Citizen.CreateThread(function()
			AnimpostfxPlay("Dont_tazeme_bro", 1000, false)
			ShakeGameplayCam("LARGE_EXPLOSION_SHAKE", 0.4)
			Wait(1000)
			AnimpostfxStop("Dont_tazeme_bro")
			local amp = 0.4
			while amp > 0 do
				Wait(100)
				amp = amp - 0.05
				SetGameplayCamShakeAmplitude(amp)
			end
			StopGameplayCamShaking(true)
			Wait(60000)
			while #ffires > 0 do
				Wait(500)
				RemoveScriptFire(table.remove(ffires, 1))
				if #ffires > 0 then
					RemoveScriptFire(table.remove(ffires, 1))
				end
			end
		end)
	end
end)

RegisterNetEvent("TBH:SyncFire")
AddEventHandler("TBH:SyncFire", function(x, y, z)
	if #ffires > 20 then
		RemoveScriptFire(table.remove(ffires, 1))
	end
	table.insert(ffires, StartScriptFire(x, y, z, 1, true))
end)