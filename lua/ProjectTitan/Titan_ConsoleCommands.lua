//________________________________
//
//  Project Titan (working title)
//	Made by Jibrail, JimWest,
//  Puschen and Winston Smith (MCMLXXXIV)
//  
//  Licensed under LGPL v3.0
//________________________________

// Titan_ConsoleCommands.lua

function OnCommandGiveMagnoBoots(client)

    local player = client:GetControllingPlayer()
	if (HasMixin(player, "MagnoBootsWearer")) then
		player:GiveMagnoBoots()
	end

end

Event.Hook("Console_magnoboots", OnCommandGiveMagnoBoots) 