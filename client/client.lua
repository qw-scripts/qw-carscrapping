local QBCore = exports['qb-core']:GetCoreObject()
local zoneData = {}
local isInsideEntranceTarget = false

RegisterNetEvent('qw-carscraping:client:beginCarScrap', function() 

    local canOpen = checkInZone()

    if canOpen then
        local closestVehicle = QBCore.Functions.GetClosestVehicle()
        local choppingSkill = exports["mz-skills"]:GetCurrentSkill("Chopping")
        SetVehicleDoorsLocked(closestVehicle, 2)
		SetVehicleEngineOn(closestVehicle, false, false, true)
		SetVehicleUndriveable(closestVehicle, false)
        TriggerEvent('animations:client:EmoteCommandStart', {"weld"})
        SetVehicleDoorOpen(closestVehicle, 0, false, true)
		Wait(3000)
		TriggerEvent('InteractSound_CL:PlayOnOne', 'chop', 0.4)
		SetVehicleDoorBroken(closestVehicle, 0, false)
        TriggerServerEvent('qw-carchopping:server:recieveRecycleMaterials', choppingSkill.Current)
        Wait(3000)
        SetVehicleDoorOpen(closestVehicle, 1, false, true)
        Wait(3000)
        TriggerEvent('InteractSound_CL:PlayOnOne', 'chop', 0.4)
        SetVehicleDoorBroken(closestVehicle, 1, false)
        TriggerServerEvent('qw-carchopping:server:recieveRecycleMaterials', choppingSkill.Current)
        Wait(3000)
        SetVehicleDoorOpen(closestVehicle, 2, false, true)
        Wait(3000)
        TriggerEvent('InteractSound_CL:PlayOnOne', 'chop', 0.4)			
        SetVehicleDoorBroken(closestVehicle, 2, false)
        TriggerServerEvent('qw-carchopping:server:recieveRecycleMaterials', choppingSkill.Current)
        Wait(3000)			
        SetVehicleDoorOpen(closestVehicle, 3, false, true)
        Wait(3000)
        TriggerEvent('InteractSound_CL:PlayOnOne', 'chop', 0.4)
        SetVehicleDoorBroken(closestVehicle, 3, false)
        TriggerServerEvent('qw-carchopping:server:recieveRecycleMaterials', choppingSkill.Current)
        Wait(3000)
        SetVehicleDoorOpen(closestVehicle, 4, false, true)
        Wait(3000)
        TriggerEvent('InteractSound_CL:PlayOnOne', 'chop', 0.4)
        SetVehicleDoorBroken(closestVehicle, 4, false)
        TriggerServerEvent('qw-carchopping:server:recieveRecycleMaterials', choppingSkill.Current)
        Wait(3000)
        SetVehicleDoorOpen(closestVehicle, 5, false, true)
        Wait(3000)
        TriggerEvent('InteractSound_CL:PlayOnOne', 'chop', 0.4)
        SetVehicleDoorBroken(closestVehicle, 5, false)
        TriggerServerEvent('qw-carchopping:server:recieveRecycleMaterials', choppingSkill.Current)
        SetEntityAsMissionEntity(closestVehicle , true, true )
        DeleteEntity(closestVehicle)
        if (DoesEntityExist(closestVehicle)) then
            DeleteEntity(closestVehicle)
        end
        Wait(1000)
        QBCore.Functions.Notify(Lang:t("success.success_chop"), 'success', choppingSkill.Current)
        TriggerEvent('animations:client:EmoteCommandStart', {"c"})

        local random_chance = math.random(1, 10)
        local test_number = math.random(1, 10)

        if random_chance == test_number then
            exports["mz-skills"]:UpdateSkill("Chopping", math.random(1, 3))
        end
    end

end)

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