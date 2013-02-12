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
    
    if player and player:GetIsAllowedToBuy() then
        local upgrade = player:GetUpgradeById(buyMessage.upgradeId)
        player:BuyUpgrade(upgrade, false)        
    end
    
end


Server.HookNetworkMessage("BuyUpgrade", OnCommandBuyUpgrade)

