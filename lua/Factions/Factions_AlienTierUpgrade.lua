//________________________________
//
//  Factions
//	Made by Jibrail, JimWest, Sewlek
//  Puschen and Winston Smith (MCMLXXXIV)
//  
//  Licensed under LGPL v3.0
//________________________________

// Factions_AlienTierUpgrade.lua

// Base class for all weapons and their upgrades

Script.Load("lua/Factions/Factions_Upgrade.lua")
							
class 'AlienTierUpgrade' (FactionsUpgrade)

AlienTierUpgrade.upgradeType 		= kFactionsUpgradeTypes.Lifeform        	// the type of the upgrade
AlienTierUpgrade.triggerType 		= kFactionsTriggerTypes.NoTrigger   	// how the upgrade is gonna be triggered
AlienTierUpgrade.permanent			= true									// Controls whether you get the upgrade back when you respawn
AlienTierUpgrade.teamType			= kFactionsUpgradeTeamType.AlienTeam	// Team Type

function AlienTierUpgrade:Initialize()

	FactionsUpgrade.Initialize(self)

	// This is a base class so never show it in the menu.
	if (self:GetClassName() == "AlienTierUpgrade") then
		self.hideUpgrade = true
	end
	self.upgradeType = AlienTierUpgrade.upgradeType
	self.triggerType = AlienTierUpgrade.triggerType
	self.permanent = AlienTierUpgrade.permanent
	self.teamType = AlienTierUpgrade.teamType
	
end

function AlienTierUpgrade:GetClassName()
	return "AlienTierUpgrade"
end

// Give the weapon to the player when they buy the upgrade.
function AlienTierUpgrade:OnAdd(player)

end
