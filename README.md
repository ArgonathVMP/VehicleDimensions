![Argonath RPG](https://media.moddb.com/images/mods/1/29/28082/auto/WbuHmXG.png)

# Vehicle Dimensions API for Real World use [FIVEM]

Join our discord for more developments as we build our FiveM server for Argonath RPG. (https://discord.gg/dfTe9M9eTu)

***This is our first public release on FiveM :grinning:***

# Key Features
* Ability to pass Entity to get vehicle layout in the GTA world consisting of Front, Centre and Back and sizing information
* These API takes into account the vehicle being rotate and displays the correct co-ordinates
* API for checking if near Front or Back of Vehicle
* Debug to show where the Front or Back of a Vehicle is located (uncommented by default to prevent resource lag of 0.4% CPU)

# Examples on what it can be used for
* Finding the trunk/boot/bonnet/hood and if the player is near it
* Can the player reach any section of the vehicle
* Mounting objects at the correct point on a vehicle
* Finding the Refuelling position on the vehicle


# Download - **FREE**
* Github: https://github.com/ArgonathVMP/VehicleDimensions


# API Request / Response


## **vehicleLayout** - Vehicle Layout API
```lua
exports['vehicle_dimensions']:vehicleLayout(entity);
```

- Response
``` lua
{
    front = {x = 0, y = 0, z = 0}, -- Real world coords
    back = {x = 0, y = 0, z = 0}, -- Real world coords
    center= {x = 0, y = 0, z = 0}, -- Real world coords
    size = { -- Relative size for vehicle
        lengthX = 0,
        lengthY = 0,
        min = { x = 0, y = 0 },
        max = { x = 0, y = 0 },
        z = 0
    }
};
```

<br>

## **isCloseToEntity** - Is Player near Front or Back of Vehicle
```lua
exports['vehicle_dimensions']:isCloseToEntity(entity);
```

- Response
``` lua
{
    front = distFromFront < 1.5, -- Boolean resposne based on being near 1.5
    frontDistance = distFromFront, -- Distance response to entity
    back = distFromBack < 1.5, -- Boolean resposne based on being near 1.5
    backDistance = distFromBack -- Distance response to entity
};
```

<br>

## Debug

### The following is commented out so you must uncomment for it to work.
#### **showNearbyVehicle** - Show Debug for Vehicle (must be enabled in client.lua)
```lua
exports['vehicle_dimensions']:showNearbyVehicle(entity);
```
- Pass in fake entity to hide it



<br>

# Change Logs

### 1.0
* Initial release

# Issues and Suggestions
Please use the GitHub issues system to report issues or make suggestions, when making suggestion, please keep [Suggestion] in the title to make it clear that it is a suggestion.
