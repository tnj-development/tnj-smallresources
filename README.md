# tnj-smallresources

In this resource are some standalone addons which you can add to the current 'qb-smallresources' resource.

All .lua's in client should go into the client folder in 'qb-smallresources'.

All .lua's in server should go into the server folder in 'qb-smallresources'




bin.lua

This gives players the ability to hide in bins using qb-target.




btf.lua

This gives players the ability to 'travel back to the future' (to a waypoint) using a deluxo at 88mph. It will leave particles as you teleport.

Commands: /btf




practiselaptop.lua

This gives players the ability to 'practise' the bank hacks using a laptop item.

in 'qb-core/shared/items.lua'

["practicelaptop"] 		 	 	 = {["name"] = "practicelaptop",           		["label"] = "Practice Laptop",	 		["weight"] = 2500, 		["type"] = "item", 		["image"] = "boostinglaptop.png", 		["unique"] = false, 	["useable"] = true, 	["shouldClose"] = true,   	["combinable"] = nil,   ["description"] = "A laptop"},




trunk.lua

Allows for players to enter the trunk of a vehicle.

Commands:

/git - Get in the trunk of closest vehicle
/pit - Put person in trunk
/dot - Drag person out of trunk

Installation:

in 'qb-core/client/functions.lua'

function QBCore.Functions.RequestAnimDict(animDict)
	if not HasAnimDictLoaded(animDict) then
		RequestAnimDict(animDict)

		while not HasAnimDictLoaded(animDict) do
			Wait(4)
		end
	end
end

QBCore.Functions.LoadAnimDict = function(dict)
	while (not HasAnimDictLoaded(dict)) do RequestAnimDict(dict) Citizen.Wait(5); end
end

QBCore.Functions.RemoveAnimDict = function(dict)
	RemoveAnimDict(dict)
end

QBCore.Functions.VehicleInFront = function()
    local pos = GetEntityCoords(PlayerPedId())
    local entityWorld = GetOffsetFromEntityInWorldCoords(PlayerPedId(), 0.0, 3.0, 0.0)
    local rayHandle = CastRayPointToPoint(pos.x, pos.y, pos.z, entityWorld.x, entityWorld.y, entityWorld.z, 10, PlayerPedId(), 0)
    local a, b, c, d, result = GetRaycastResult(rayHandle)
    return result
end

QBCore.Functions.GetClosestPlayerRadius = function(radius)
    local players = QBCore.Functions.GetPlayers()
    local closestDistance = -1
    local closestPlayer = -1
    local ply = PlayerPedId()
    local plyCoords = GetEntityCoords(ply)

    for index,value in ipairs(players) do
        local target = GetPlayerPed(value)
        if(target ~= ply) then
            local targetCoords = GetEntityCoords(GetPlayerPed(value), 0)
            local distance = #(targetCoords - plyCoords)
            if(closestDistance == -1 or closestDistance > distance) then
                closestPlayer = value
                closestDistance = distance
            end
        end
    end
	print("closest player is dist: " .. tostring(closestDistance))
	if closestDistance ~= -1 and closestDistance <= radius then
		return closestPlayer
	else
		return nil
	end
end

function PersistentAlert(action, id, ttype, text, style)
	if ttype == 'inform' then ttype = 'primary'; end
	QBCore.Functions.PersistentNotify(action, id, text, ttype, style)
end

exports('PersistentAlert', PersistentAlert);

QBCore.Functions.PersistentNotify = function(action, id, text, textype, style)
	if action:upper() == 'START' then
		SendNUIMessage({
			persist = action,
			id = id,
			type = textype,
			text = text,
			style = style
		})
	elseif action:upper() == 'END' then
		SendNUIMessage({
			persist = action,
			id = id
		})
	end
end
