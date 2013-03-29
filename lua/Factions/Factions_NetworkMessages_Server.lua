//________________________________
//
//  Factions
//	Made by Jibrail, JimWest, Sewlek
//  Puschen and Winston Smith (MCMLXXXIV)
//  
//  Licensed under LGPL v3.0
//________________________________

// Factions_NetworkMessages_Server.lua


local function OnCommandBuyUpgrade(client, buyMessage)

    local player = client:GetControllingPlayer()
    
    if player and player:GetIsAllowedToBuy(buyMessage.upgradeId) then
        player:BuyUpgrade(buyMessage.upgradeId, false)
    end
    
end

Server.HookNetworkMessage("BuyUpgrade", OnCommandBuyUpgrade)

function OnCommandMarineBuildStructure(client, message)

    local player = client:GetControllingPlayer()
    local origin, direction, structureIndex, lastClickedPosition = ParseMarineBuildMessage(message)
    
    local dropStructureAbility = player:GetWeapon(DropStructureAbility.kMapName)
    // The player may not have an active weapon if the message is sent
    // after the player has gone back to the ready room for example.
    if dropStructureAbility then
        dropStructureAbility:OnDropStructure(origin, direction, structureIndex, lastClickedPosition)
    end
    
end

Server.HookNetworkMessage("MarineBuildStructure", OnCommandMarineBuildStructure)