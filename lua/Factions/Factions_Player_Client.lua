//________________________________
//
//  Factions
//	Made by Jibrail, JimWest, Sewlek
//  Puschen and Winston Smith (MCMLXXXIV)
//  
//  Licensed under LGPL v3.0
//________________________________

// Factions_Player_Client.lua

// Close the menu when a player dies.
local overrideAddTakeDamageIndicator = Player.AddTakeDamageIndicator
function Player:AddTakeDamageIndicator(damagePosition)    
    if not self:GetIsAlive() and not self.deathTriggered then    
		self:CloseMenu(true)        
    end
	
	overrideAddTakeDamageIndicator(self, damagePosition)
end

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

/**
 * Get the Y position of the crosshair image in the atlas.
 * Listed in this order:
 *   Rifle, Pistol, Axe, Shotgun, Minigun, Rifle with GL, Flamethrower
 */
function PlayerUI_GetCrosshairY()

    local player = Client.GetLocalPlayer()

    if(player and not player:GetIsThirdPerson()) then  
      
        local weapon = player:GetActiveWeapon()
        if(weapon ~= nil) then
        
            // Get class name and use to return index
            local index 
            local mapname = weapon:GetMapName()
            
            if mapname == Rifle.kMapName then 
                index = 0
			elseif mapname == LightMachineGun.kMapName then 
                index = 0
            elseif mapname == Pistol.kMapName then
                index = 1
            elseif mapname == Shotgun.kMapName then
                index = 3
            elseif mapname == Minigun.kMapName then
                index = 4
            elseif mapname == Flamethrower.kMapName then
                index = 5
            // All alien crosshairs are the same for now
            elseif mapname == LerkBite.kMapName or mapname == Spores.kMapName or mapname == LerkUmbra.kMapName or mapname == Parasite.kMapName then
                index = 6
            elseif mapname == SpitSpray.kMapName or mapname == BabblerAbility.kMapName then
                index = 7
            // Blanks (with default damage indicator)
            else
                index = 8
            end
        
            return index * 64
            
        end
        
    end

end