//________________________________
//
//  Factions
//	Made by Jibrail, JimWest, Sewlek
//  Puschen and Winston Smith (MCMLXXXIV)
//  
//  Licensed under LGPL v3.0
//________________________________

// Factions_Player_Client.lua

function PlayerUI_GetIsUsingIronSight()

	local player = Client.GetLocalPlayer()
    local ironSightActive = false
    
    if player then
    
        if HasMixin(player, "IronSightViewer") then
			local weapon = player:GetActiveWeapon()
			if weapon and HasMixin(weapon, "IronSight") then
				ironSightActive = player:GetActiveWeapon():GetIronSightActive()
			end
        end
        
    end
    
    return ironSightActive

end