QBCore = exports['qb-core']:GetCoreObject()

--- Trunk logic ---
DecorRegister('Vehicle.trunkInUse', 2)

local blacklistModels = {
    [1] = "jester",
    [2] = "infernus",
    [3] = "zentorno",
    [4] = "turismor",
    [5] = "bullet",
    [6] = "panto",
    [7] = "brioso",
    [8] = "comet2",
    [9] = "comet3",
    [10] = "comet4",
    [11] = "comet5",
    [12] = "ninef",
    [13] = "ninef2",
    [14] = "furoregt",
    [15] = "trophytruck",
    [16] = "guardian",
}

function blacklistedModel(veh)
    for i=1,#blacklistModels do
        if GetEntityModel(veh) == GetHashKey(blacklistModels[i]) then
            return true
        end
    end
    return false
end

local trunkVeh = nil
local inTrunk = false
RegisterCommand("git", function() TriggerEvent('gameplay:getintrunk'); end)
TriggerEvent("chat:addSuggestion", "/git", 'Get in the trunk of closest vehicle (Get in trunk)')

AddEventHandler('gameplay:getintrunk', function()
    local veh = QBCore.Functions.VehicleInFront()
    if veh == 0 then QBCore.Functions.Notify("No vehicle found",'error') return; end
    local lockStatus = GetVehicleDoorLockStatus(veh)
    if lockStatus ~= 1 and lockStatus ~= 0 then
        QBCore.Functions.Notify("The vehicle is locked", 'error')
        return
    end
    if GetVehicleDoorAngleRatio(veh, 5) == 0.0 then
        QBCore.Functions.Notify("The trunk is closed",'error')
        return
    end
    putinTrunk(veh)
end)

RegisterCommand("pit", function() TriggerEvent('gameplay:putintrunk'); end)
TriggerEvent("chat:addSuggestion", "/pit", 'Put person in trunk (Put in trunk)')

AddEventHandler('gameplay:putintrunk', function()
    local closestPlayer = QBCore.Functions.GetClosestPlayerRadius(3)
    if closestPlayer then
        local closestPed = GetPlayerPed(closestPlayer)
		local veh = QBCore.Functions.VehicleInFront()
        if veh == 0 then QBCore.Functions.Notify("No vehicle found",'error') return; end
        local lockStatus = GetVehicleDoorLockStatus(veh)
        if lockStatus ~= 1 and lockStatus ~= 0 then
            QBCore.Functions.Notify("The vehicle is locked", 'error')
            return
        end
        if GetVehicleDoorAngleRatio(veh, 5) == 0.0 then
            QBCore.Functions.Notify("The trunk is closed",'error')
            return
        end
		--StopLift()
		TriggerServerEvent("qb_gameplay:requestTrunk", GetPlayerServerId(closestPlayer), veh, false)
    else
        QBCore.Functions.Notify("No person nearby",'error')
    end
end)

RegisterCommand("dot", function() TriggerEvent('dragouttrunk'); end)
TriggerEvent("chat:addSuggestion", "/dot", 'Drag person out of trunk (Drag out trunk)')

AddEventHandler('gameplay:dragouttrunk', function()
    local closestPlayer = QBCore.Functions.GetClosestPlayerRadius(3)
    if closestPlayer then
        local veh = QBCore.Functions.VehicleInFront()
        if veh == 0 then QBCore.Functions.Notify("No vehicle found",'error') return; end
        local lockStatus = GetVehicleDoorLockStatus(veh)
        if lockStatus ~= 1 and lockStatus ~= 0 then
            QBCore.Functions.Notify("The vehicle is locked", 'error')
            return
        end
        if GetVehicleDoorAngleRatio(veh, 5) == 0.0 then
            QBCore.Functions.Notify("The trunk is closed",'error')
            return
        end
        TriggerServerEvent("qb_gameplay:requestTrunk", GetPlayerServerId(closestPlayer), false, true)
    else
        QBCore.Functions.Notify("No person nearby",'error')
    end
end)

RegisterNetEvent('qb_gameplay:handleTrunk')
AddEventHandler('qb_gameplay:handleTrunk', function(veh)
    if veh then
        putinTrunk()
    else
        inTrunk = false
        TriggerServerEvent("QBCore:Server:SetMetaData", "intrunk", false)
    end
end)

local cam = nil
function trunkCam()
    if not DoesCamExist(cam) then
        cam = CreateCam('DEFAULT_SCRIPTED_CAMERA', true)
        local plyPed = PlayerPedId()
        SetCamCoord(cam, GetEntityCoords(plyPed))
        SetCamRot(cam, 0.0, 0.0, 0.0)
        SetCamActive(cam,  true)
        RenderScriptCams(true,  false,  0,  true,  true)
        SetCamCoord(cam, GetEntityCoords(plyPed))
    end
    AttachCamToEntity(cam, PlayerPedId(), 0.0, -2.5, 1.0, true)
    SetCamRot(cam, -30.0, 0.0, GetEntityHeading(PlayerPedId()))
end

function disableCam()
    RenderScriptCams(false, false, 0, 1, 0)
    DestroyCam(cam, false)
end

local trunkNotif = "TRNK_NOTIF"
function putinTrunk(veh)
    if veh == nil or veh == 0 then veh = QBCore.Functions.VehicleInFront(); end
	local blacklist = blacklistedModel(veh)
	if blacklist then QBCore.Functions.Notify("Trunk not available on this model", 'error') return; end
	if not DecorGetBool(veh, 'Vehicle.trunkInUse') then
		local model = GetEntityModel(veh)
		if not DoesVehicleHaveDoor(veh, 6) and DoesVehicleHaveDoor(veh, 5) and IsThisModelACar(model) then
			SetVehicleDoorOpen(veh, 5, 1)
			local plyPed = PlayerPedId()

			local d1,d2 = GetModelDimensions(model)

			local trunkDic = "fin_ext_p1-7"
			local trunkAnim = "cs_devin_dual-7"
			QBCore.Functions.LoadAnimDict(trunkDic)

			SetBlockingOfNonTemporaryEvents(plyPed, true)
			--SetPedKeepTask(plyPed, true)
			DetachEntity(plyPed)
			ClearPedTasks(plyPed)
			ClearPedSecondaryTask(plyPed)
			ClearPedTasksImmediately(plyPed)
			TaskPlayAnim(plyPed, trunkDic, trunkAnim, 8.0, 8.0, -1, 1, 999.0, 0, 0, 0)

			AttachEntityToEntity(plyPed, veh, 0, -0.1,d1["y"]+0.85,d2["z"]-0.87, 0, 0, 40.0, 1, 1, 1, 1, 1, 1)
			inTrunk = true
			trunkVeh = veh
			TriggerServerEvent("QBCore:Server:SetMetaData", "intrunk", true)
			DecorSetBool(veh, 'Vehicle.trunkInUse', true)
			exports['qb-core']:PersistentAlert('start', trunkNotif, 'inform', "Controls: [F] Exit vehicle | [H] Open/Close Trunk")

			while inTrunk do
				trunkCam()

				if IsPedCuffed(plyPed) then
					Citizen.Wait(0)
				else
					Citizen.Wait(0)
					if IsControlJustReleased(0, 74) then
						TriggerServerEvent("gameplay:server:toggleTrunkDoor",VehToNet(veh))
					end

					if IsControlJustReleased(0, 23) then
						inTrunk = false
					end
				end

				if not IsEntityPlayingAnim(plyPed, trunkDic, trunkAnim, 3) then
					TaskPlayAnim(plyPed, trunkDic, trunkAnim, 8.0, 8.0, -1, 1, 999.0, 0, 0, 0)
				end

				if not DoesEntityExist(veh) then
					inTrunk = false
				end
			end
            exports['qb-core']:PersistentAlert('end', trunkNotif)
            TriggerServerEvent("QBCore:Server:SetMetaData", "intrunk", false)
			DecorSetBool(veh, 'Vehicle.trunkInUse', false)
			QBCore.Functions.RemoveAnimDict(trunkDic)
			SetVehicleDoorOpen(veh, 5, 1, 0)
			disableCam()
			DetachEntity(plyPed)
			Citizen.Wait(10)
			if DoesEntityExist(veh) then
				local dropPosition = GetOffsetFromEntityInWorldCoords(veh, 0.0,d1["y"]-0.6,0.0)
				SetEntityCoords(plyPed,dropPosition["x"],dropPosition["y"],dropPosition["z"])
			else
				ClearPedTasks(plyPed)
				local plyCoords = GetEntityCoords(plyPed)
				SetEntityCoords(plyped, plyCoords.x, plyCoords.y, plyCoords.x+2)
			end
			trunkVeh = nil
		end
	else
		QBCore.Functions.Notify("Trunk occupied",'error')
	end
end

RegisterNetEvent("gameplay:client:toggleTrunkDoor")
AddEventHandler("gameplay:client:toggleTrunkDoor", function(veh)
	local veh = NetToVeh(veh)
	if GetVehicleDoorAngleRatio(veh, 5) > 0.0 then
		SetVehicleDoorShut(veh, 5, false)
	else
		SetVehicleDoorOpen(veh, 5, false)
	end
end)
