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

if Client then
	Client.HookNetworkMessage("UpdateUpgrade", OnCommandUpdateUpgrade)
	Client.HookNetworkMessage("ClearUpgrades", OnCommandClearUpgrades)
else
	Predict.HookNetworkMessage("UpdateUpgrade", OnCommandUpdateUpgrade)
	Predict.HookNetworkMessage("ClearUpgrades", OnCommandClearUpgrades)
end

if Client then
	// Do nothing when get the normal ns2 networkmessages, should save some performance
	Client.HookNetworkMessage("ClearTechTree", function() end)
	Client.HookNetworkMessage("TechNodeBase", function() end)
	Client.HookNetworkMessage("TechNodeUpdate", function() end)
else
	// Do nothing when get the normal ns2 networkmessages, should save some performance
	Predict.HookNetworkMessage("ClearTechTree", function() end)
	Predict.HookNetworkMessage("TechNodeBase", function() end)
	Predict.HookNetworkMessage("TechNodeUpdate", function() end)
end
