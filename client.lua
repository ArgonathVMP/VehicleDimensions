local config = {
    lineLength = 0.5
}

local foundVeh = nil;
local foundVehicleLayout = nil;
local debug = {
    front = true,
    back = true,
}

-- Rotate the box to suit the vehicle heading
function rotateRect(angle, ox, oy, x, y, w, h)
    local xAx = math.cos(angle);
    local xAy = math.sin(angle);
    x -= ox;
    y -= oy;
    local res = {}
    res[1] = {}
    res[1][1] = x * xAx - y * xAy + ox;
    res[1][2] = x * xAy + y * xAx + oy;

    res[2] = {}
    res[2][1] =  (x + w) * xAx - y * xAy + ox;
    res[2][2] = (x + w) * xAy + y * xAx + oy;

    res[3] = {}
    res[3][1] = (x + w) * xAx - (y + h) * xAy + ox;
    res[3][2] = (x + w) * xAy + (y + h) * xAx + oy;

    res[4] = {}
    res[4][1] =  x * xAx - (y + h) * xAy + ox;
    res[4][2] = x * xAy + (y + h) * xAx + oy;

    return res
end

-- Get all the vehicle data from the model dimensions, conver it to real world and rotate to suit heading
function vehicleLayout(Vehicle)

    local min, max = GetModelDimensions(GetEntityModel(Vehicle))
    local vehicleRotation = GetEntityRotation(Vehicle, 2);
    local Xwidth = (0 - min.x) + (max.x);
    local Ywidth = (0 - min.y) + (max.y);
    local degree = (vehicleRotation.z + 180) * math.pi / 180;
    local position = GetEntityCoords(Vehicle)


    local newDegrees = rotateRect(degree, position.x, position.y, position.x - max.x, position.y - max.y, Xwidth, Ywidth);

    local frontX = newDegrees[1][1] + ((newDegrees[2][1] - newDegrees[1][1]) / 2);
    local frontY = newDegrees[1][2] + ((newDegrees[2][2] - newDegrees[1][2]) / 2);

    local bottomX = newDegrees[3][1] + ((newDegrees[4][1] - newDegrees[3][1]) / 2);
    local bottomY = newDegrees[3][2] + ((newDegrees[4][2] - newDegrees[3][2]) / 2);

    return {
        front = {x = frontX, y = frontY, z = position.z},
        back = {x = bottomX, y = bottomY, z = position.z},
        center= {x = position.x, y = position.y, z = position.z},
        size = {
            lengthX = Xwidth,
            lengthY = Ywidth,
            min = { x = min.x, y = min.y },
            max = { x = max.x, y = max.y },
            z = min.z
        }
    };

end


function isCloseToEntity(entity)
    local player = GetPlayerPed(-1)
    local playerPos = GetEntityCoords(player)
    local layout = vehicleLayout(entity)
    local distFromFront = #(playerPos - vector3(layout.front.x, layout.front.y, layout.front.z))
    local distFromBack = #(playerPos - vector3(layout.back.x, layout.back.y, layout.back.z))
    return {
        front = distFromFront < 1.5,
        frontDistance = distFromFront,
        back = distFromBack < 1.5,
        backDistance = distFromBack
    }
end

function showNearbyVehicle(entity)
    if DoesEntityExist(entity) then
        foundVeh = entity;
        foundVehicleLayout = vehicleLayout(entity)
    else
        foundVeh = nil;
        foundVehicleLayout = nil;
    end
end


function displayTrunk(x, y, z)
    DrawLine(x - config.lineLength, y, z, x + config.lineLength, y, z, 255, 0, 0, 255)
    DrawLine(x, y - config.lineLength, z, x, y + config.lineLength, z, 0, 255, 0, 255)
    DrawLine(x, y, z - config.lineLength, x, y, z + config.lineLength, 0, 0, 255, 255)
end


Citizen.CreateThread(function()
	while true do
		if foundVeh and debug.back and foundVehicleLayout then
            displayTrunk(foundVehicleLayout.back.x, foundVehicleLayout.back.y, foundVehicleLayout.back.z)
		end
		if foundVeh and debug.front and foundVehicleLayout then
            displayTrunk(foundVehicleLayout.front.x, foundVehicleLayout.front.y, foundVehicleLayout.front.z)
		end
		Wait(0)
	end
end)
