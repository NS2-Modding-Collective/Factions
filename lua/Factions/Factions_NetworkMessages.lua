//________________________________
//
//  Factions
//	Made by Jibrail, JimWest, Sewlek
//  Puschen and Winston Smith (MCMLXXXIV)
//  
//  Licensed under LGPL v3.0
//________________________________

// Factions_NetworkMessages.lua

// load the upgrade base class
Script.Load("lua/Factions/Factions_UpgradeMixin.lua")

local kUpdateUpgrade =
{
    upgradeId = "integer (0 to 127)",
    upgradeLevel = "integer (0 to 31)",
}

function BuildUpdateUpgradeMessage(upgradeId, level)

    local message = { }
    
    message.upgradeId = upgradeId
    message.upgradeLevel = level
    
    return message
end


local kBuyUpgrade =
{
    upgradeId = "integer (0 to 127)",
}

function BuildBuyUpgradeMessage(upgrade)

    local message = { }
    
    message.upgradeId = upgrade:GetId() 
    
    return message
end

Shared.RegisterNetworkMessage( "UpdateUpgrade", kUpdateUpgrade )
Shared.RegisterNetworkMessage( "BuyUpgrade", kBuyUpgrade )
Shared.RegisterNetworkMessage( "ClearUpgrades", {} )