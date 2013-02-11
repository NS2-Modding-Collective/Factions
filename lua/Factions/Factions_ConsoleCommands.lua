//________________________________
//
//  Factions
//	Made by Jibrail, JimWest,
//  Puschen and Winston Smith (MCMLXXXIV)
//  
//  Licensed under LGPL v3.0
//________________________________

// Factions_ConsoleCommands.lua

function OnCommandGiveMagnoBoots(client)

    local player = client:GetControllingPlayer()
	if (HasMixin(player, "MagnoBootsWearer")) then
		player:GiveMagnoBoots()
	end

end


function OnCommandGiveXp(client, amount)

    local player = client:GetControllingPlayer()
	if player and  Shared.GetCheatsEnabled() then
	    if not amount then
	        amount = 10
        end	        
		player:AddScore(amount)
	end

end

Event.Hook("Console_magnoboots", OnCommandGiveMagnoBoots) 
Event.Hook("Console_givexp", OnCommandGiveXp) 