local QBCore = exports['qb-core']:GetCoreObject()
local zoneData = {}
local isInsideEntranceTarget = false
local currentCarDoor = 0
local isHoldingCarDoor = false
local numberOfDoors = 0

RegisterNetEvent('qw-carscraping:client:beginCarScrap', function() 

    local canOpen = checkInZone()

    if canOpen and isHoldingCarDoor == false then
        local closestVehicle = QBCore.Functions.GetClosestVehicle()
        numberOfDoors = GetNumberOfVehicleDoors(closestVehicle)
        if currentCarDoor == 0 then
            SetVehicleDoorsLocked(closestVehicle, 2)
            SetVehicleEngineOn(closestVehicle, false, false, true)
            SetVehicleUndriveable(closestVehicle, false)
        end

        TriggerEvent('animations:client:EmoteCommandStart', {"weld"})
        QBCore.Functions.Progressbar("open_locker_drill", Lang:t('general.scrap_vehicle'), 5000, false, true, {
            disableMovement = true,	disableCarMovement = true, disableMouse = false, disableCombat = true, }, {}, {}, {}, function()
                SetVehicleDoorOpen(closestVehicle, currentCarDoor, false, true)
                Wait(500)
                TriggerEvent('InteractSound_CL:PlayOnOne', 'chop', 0.4)
                SetVehicleDoorBroken(closestVehicle, currentCarDoor, false)
                ClearPedTasksImmediately(PlayerPedId())
                
                if currentCarDoor + 1 == numberOfDoors then
                    SetEntityAsMissionEntity(closestVehicle , true, true )
                    DeleteEntity(closestVehicle)
                    if (DoesEntityExist(closestVehicle)) then
                        DeleteEntity(closestVehicle)
                    end
                    TriggerEvent('qw-carscraping:client:holdCarDoor')
                else
                    TriggerEvent('qw-carscraping:client:holdCarDoor')
                end
            end, function()
            end)
    end

end)

RegisterNetEvent('qw-carscraping:client:holdCarDoor', function()
    isHoldingCarDoor = true

    loadAnimDict("anim@heists@box_carry@")
    TaskPlayAnim(PlayerPedId(), "anim@heists@box_carry@" ,"idle", 5.0, -1, -1, 50, 0, false, false, false)

    v = { model = `prop_car_door_01`, xPos = 0.35, yPos = 0.0, zPos = 0.36, xRot = 136.0, yRot = 114.0, zRot = 181.0 }

    loadModel(v.model)
    doorProp = CreateObject(v.model, GetEntityCoords(PlayerPedId(), true), true, true, true)
    AttachEntityToEntity(doorProp, PlayerPedId(), GetPedBoneIndex(PlayerPedId(), 18905), v.xPos, v.yPos, v.zPos, v.xRot, v.yRot, v.zRot, 20.0, true, true, false, true, 1, true)


    exports['qb-target']:AddBoxZone("dropoff-door", vector3(-473.4, -1675.91, 18.93), 1.5, 1.6, { -- The name has to be unique, the coords a vector3 as shown, the 1.5 is the length of the boxzone and the 1.6 is the width of the boxzone, the length and width have to be float values
        name = "dropoff-door", -- This is the name of the zone recognized by PolyZone, this has to be unique so it doesn't mess up with other zones
        heading = 152.0, -- The heading of the boxzone, this has to be a float value
        debugPoly = false, -- This is for enabling/disabling the drawing of the box, it accepts only a boolean value (true or false), when true it will draw the polyzone in green
        minZ = 18.7, -- This is the bottom of the boxzone, this can be different from the Z value in the coords, this has to be a float value
        maxZ = 21.9, -- This is the top of the boxzone, this can be different from the Z value in the coords, this has to be a float value
        }, {
        options = { -- This is your options table, in this table all the options will be specified for the target to accept
            { -- This is the first table with options, you can make as many options inside the options table as you want
            num = 1, -- This is the position number of your option in the list of options in the qb-target context menu (OPTIONAL)
            type = "client", -- This specifies the type of event the target has to trigger on click, this can be "client", "server", "command" or "qbcommand", this is OPTIONAL and will only work if the event is also specified
            event = "qw-carscraping:client:DropOffDoor", -- This is the event it will trigger on click, this can be a client event, server event, command or qbcore registered command, NOTICE: Normal command can't have arguments passed through, QBCore registered ones can have arguments passed through
            icon = 'fas fa-hand', -- This is the icon that will display next to this trigger option
            label = Lang:t('info.drop_off_door'), -- This is the label of this option which you would be able to click on to trigger everything, this has to be a string
            }
        },
        distance = 2.5, -- This is the distance for you to be at for the target to turn blue, this is in GTA units and has to be a float value
    })

end)

RegisterNetEvent('qw-carscraping:client:DropOffDoor', function()
    local choppingSkill = exports["mz-skills"]:GetCurrentSkill("Chopping")

    if isHoldingCarDoor then
        exports['qb-target']:RemoveZone("dropoff-door")
    end

    local dict = "mp_car_bomb" 
    loadAnimDict("mp_car_bomb")
	
    local anim = "car_bomb_mechanic"

    FreezeEntityPosition(PlayerPedId(), true)
	Wait(100)
	TaskPlayAnim(PlayerPedId(), dict, anim, 3.0, 3.0, -1, 2.0, 0, 0, 0, 0)
	Wait(3000)

    destroyProp(doorProp)
    doorProp = nil
	ClearPedTasks(PlayerPedId())
	FreezeEntityPosition(PlayerPedId(), false)

    TriggerServerEvent('qw-carchopping:server:recieveRecycleMaterials', choppingSkill.Current)
    isHoldingCarDoor = false

    if currentCarDoor + 1 == numberOfDoors then
        QBCore.Functions.Notify(Lang:t("success.success_chop"), 'success')
        local random_chance = math.random(1, 10)
        local test_number = math.random(1, 10)

        if random_chance == test_number then
            exports["mz-skills"]:UpdateSkill("Chopping", math.random(1, 3))
        end
        currentCarDoor = 0
        numberOfDoors = 0
    else
        currentCarDoor += 1
    end


end)

-- Thanks to jimathy for these load and destroy functions: https://github.com/jimathy/jim-recycle/blob/main/shared/functions.lua
function loadAnimDict(dict) if Config.Debug then print("^5Debug^7: ^2Loading Anim Dictionary^7: '^6"..dict.."^7'") end while not HasAnimDictLoaded(dict) do RequestAnimDict(dict) Wait(5) end end

function loadModel(model)
    local time = 1000
    if not HasModelLoaded(model) then if Config.Debug then print("^5Debug^7: ^2Loading Model^7: '^6"..model.."^7'") end
	while not HasModelLoaded(model) do if time > 0 then time = time - 1 RequestModel(model)
		else time = 1000 print("^5Debug^7: ^3LoadModel^7: ^2Timed out loading model ^7'^6"..model.."^7'") break end
		Wait(10) end
	end
end

function destroyProp(entity)
	if Config.Debug then print("^5Debug^7: ^2Destroying Prop^7: '^6"..entity.."^7'") end
	SetEntityAsMissionEntity(entity) Wait(5)
	DetachEntity(entity, true, true) Wait(5)
	DeleteEntity(entity)
end

function createPolyZone() 
    local zone = PolyZone:Create(Config.ScrappingZone, {
        name = 'car-scraping-zone',
        minZ = 18,
        maxZ = 20,
    })

    zone:onPlayerInOut(function (isPointInside)
        local closestVehicle = QBCore.Functions.GetClosestVehicle()

        if isPointInside then
            exports['ps-ui']:DisplayText(Lang:t("info.scrap_zone"), "info")

            exports['qb-target']:AddTargetEntity(closestVehicle, {
                options = {
                    {
                        type = "client",
                        event = "qw-carscraping:client:beginCarScrap",
                        icon = "fa-solid fa-screwdriver-wrench",
                        label = Lang:t('general.scrap_vehicle'),
                    },
                },
                distance = 3.0
            })
        else
            exports['ps-ui']:HideText()
            exports['qb-target']:RemoveTargetEntity(closestVehicle, Lang:t('general.scrap_vehicle'))
        end

        isInsideEntranceTarget = isPointInside
    end)

    zoneData.created = true
    zoneData.zone = zone
end

function checkInZone() 
    if isInsideEntranceTarget then
        return true
    else
        return false
    end
end

RegisterNetEvent('QBCore:Client:OnPlayerLoaded', function()
    createPolyZone()
end)

AddEventHandler('onResourceStart', function(resourceName)
    if GetCurrentResourceName() == resourceName then
        createPolyZone()
    end
end)

AddEventHandler('onResourceStop', function(resourceName)
    if GetCurrentResourceName() == resourceName then
        zoneData.zone:destroy()
    end
end)