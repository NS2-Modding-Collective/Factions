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

