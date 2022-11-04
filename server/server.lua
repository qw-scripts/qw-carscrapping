local QBCore = exports['qb-core']:GetCoreObject()

RegisterNetEvent('qw-carchopping:server:recieveRecycleMaterials', function(currentSkill) 

    local src = source
    local Player = QBCore.Functions.GetPlayer(src)

    local receiveAmount = math.random(4, 10)

    Player.Functions.AddItem(Config.RewardItem, receiveAmount * currentSkill + 5)
    TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items[Config.RewardItem], "add", receiveAmount * currentSkill + 5)

end)