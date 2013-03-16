//________________________________
//
//  Factions
//	Made by Jibrail, JimWest, Sewlek
//  Puschen and Winston Smith (MCMLXXXIV)
//  
//  Licensed under LGPL v3.0
//________________________________

// Factions_Upgrade.lua

// Base class for all upgrades

Script.Load("lua/Factions/Factions_Upgrade.lua")
							
class 'FactionsWeaponUpgrade' (FactionsUpgrade)

FactionsWeaponUpgrade.upgradeType = kUpgradeTypes.Weapon        		// the type of the upgrade
FactionsWeaponUpgrade.triggerType = kTriggerTypes.NoTrigger   			// how the upgrade is gonna be triggered
FactionsWeaponUpgrade.levels = 1                                        // if the upgrade has more than one lvl, like weapon or armor ups. Default is 1.
FactionsWeaponUpgrade.permanent = true									// Controls whether you get the upgrade back when you respawn
FactionsWeaponUpgrade.primaryWeapon = false								// Is this a primary weapon?

function FactionsWeaponUpgrade:GetIsPrimaryWeapon()
    return self.primaryWeapon
end

// Give the weapon to the player when they buy the upgrade.
function FactionsWeaponUpgrade:OnAdd(player)

	local mapName = LookupTechData(self:GetUpgradeTechId(1), kTechDataMapName)
	if mapName then
		// if this is a primary weapon, destroy the old one.
		if self:GetIsPrimaryWeapon() then
			local weapon = player:GetWeaponInHUDSlot(1)
			if (weapon) then
				player:RemoveWeapon(weapon)
				DestroyEntity(weapon)
			end
		end
	
		player:GiveItem(mapName)
	end          

end
