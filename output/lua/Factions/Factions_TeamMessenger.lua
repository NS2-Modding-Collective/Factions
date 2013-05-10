//________________________________
//
//  Factions
//	Made by Jibrail, JimWest, Sewlek
//  Puschen and Winston Smith (MCMLXXXIV)
//  
//  Licensed under LGPL v3.0
//________________________________

// Factions_TeamMessenger.lua

function SendTeamMessage(team, messageType, optionalData)

	local function SendToPlayer(player)
		Server.SendNetworkMessage(player, "TeamMessage", { type = messageType, data = optionalData or 0 }, true)
	end   

	// Don't send certain messages, for now.
	if not ((messageType == kTeamMessageTypes.NoCommander) or
			(messageType == kTeamMessageTypes.CannotSpawn)) then
			
			team:ForEachPlayer(SendToPlayer)
			
	end
		
end