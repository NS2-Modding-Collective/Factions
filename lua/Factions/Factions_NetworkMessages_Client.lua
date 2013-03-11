//________________________________
//
//  Factions
//	Made by Jibrail, JimWest, Sewlek
//  Puschen and Winston Smith (MCMLXXXIV)
//  
//  Licensed under LGPL v3.0
//________________________________

// Factions_NetworkMessages_Client.lua

function OnCommandUpdateUpgrade(msg)
    // The server will send us this message to tell us an ability succeded.
    player = Client.GetLocalPlayer()
    local upgrade = player:GetUpgradeById(msg.upgradeId)
    if upgrade then    
        player:SetUpgrade(upgrade, msg.upgradeLevel)
    end

end

function OnCommandClearUpgrades()

    // The server will send us this message to tell us an ability succeded.
    player = Client.GetLocalPlayer()
    player:ClearUpgrades()

end

Client.HookNetworkMessage("UpdateUpgrade", OnCommandUpdateUpgrade)
Client.HookNetworkMessage("ClearUpgrades", OnCommandClearUpgrades)

// Do nothing when get the normal ns2 networkmessages, should save some performance
Client.HookNetworkMessage("ClearTechTree", function() end)
Client.HookNetworkMessage("TechNodeBase", function() end)
Client.HookNetworkMessage("TechNodeUpdate", function() end)

function OnCommandChangeClass(newClass)

    // The server will send us this message when we successfully change class.
    player = Client.GetLocalPlayer()
    player:ChangeFactionsClass(newClass)

end

Client.HookNetworkMessage("ChangePlayerClass", OnCommandClearUpgrades)

