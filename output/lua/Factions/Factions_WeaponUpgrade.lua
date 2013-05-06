//________________________________
//
//  Factions
//	Made by Jibrail, JimWest, Sewlek
//  Puschen and Winston Smith (MCMLXXXIV)
//  
//  Licensed under LGPL v3.0
//________________________________

// Factions_WeaponUpgrade.lua

// Base class for all weapons and their upgrades

Script.Load("lua/Factions/Factions_Upgrade.lua")
							
class 'FactionsWeaponUpgrade' (FactionsUpgrade)

FactionsWeaponUpgrade.upgradeType 	= kFactionsUpgradeTypes.Weapon        	// the type of the upgrade
FactionsWeaponUpgrade.triggerType 	= kFactionsTriggerTypes.NoTrigger   	// how the upgrade is gonna be triggered
FactionsWeaponUpgrade.permanent		= false									// Controls whether you get the upgrade back when you respawn
FactionsWeaponUpgrade.hudSlot		= 4										// Is this a primary weapon?
FactionsWeaponUpgrade.teamType		= kFactionsUpgradeTeamType.MarineTeam	// Team Type

function FactionsWeaponUpgrade:Initialize()

	FactionsUpgrade.Initialize(self)

	// This is a base class so never show it in the menu.
	if (self:GetClassName() == "FactionsWeaponUpgrade") then
		self.hideUpgrade = true
	end
	self.upgradeType = FactionsWeaponUpgrade.upgradeType
	self.triggerType = FactionsWeaponUpgrade.triggerType
	self.permanent = FactionsWeaponUpgrade.permanent
	self.hudSlot = FactionsWeaponUpgrade.hudSlot
	self.teamType = FactionsWeaponUpgrade.teamType
	
end

function FactionsWeaponUpgrade:GetClassName()
	return "FactionsWeaponUpgrade"
end

function FactionsWeaponUpgrade:GetHUDSlot()
    return self.hudSlot
end

// Give the weapon to the player when they buy the upgrade.
function FactionsWeaponUpgrade:OnAdd(player)

	local mapName = LookupTechData(self:GetUpgradeTechId(), kTechDataMapName)
	if mapName then
		// Destroy the old weapon in this slot.
		local weapon = player:GetWeaponInHUDSlot(self:GetHUDSlot())
		if (weapon) then
			player:RemoveWeapon(weapon)
			DestroyEntity(weapon)
		end
	
		player:GiveItem(mapName)
	end          

end

function FactionsWeaponUpgrade:SendAddMessage(player)
	player:SendDirectMessage("You bought a " .. self:GetUpgradeTitle() .. "!")
end