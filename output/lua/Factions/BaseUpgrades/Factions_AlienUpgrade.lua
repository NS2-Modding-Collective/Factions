//________________________________
//
//  Factions
//	Made by Jibrail, JimWest, Sewlek
//  Puschen and Winston Smith (MCMLXXXIV)
//  
//  Licensed under LGPL v3.0
//________________________________

// Factions_AlienUpgrade.lua

// Base class for all weapons and their upgrades

Script.Load("lua/Factions/BaseUpgrades/Factions_Upgrade.lua")
							
class 'FactionsAlienUpgrade' (FactionsUpgrade)

FactionsAlienUpgrade.upgradeType 		= kFactionsUpgradeTypes.Ability        	// the type of the upgrade
FactionsAlienUpgrade.triggerType 		= kFactionsTriggerTypes.NoTrigger   	// how the upgrade is gonna be triggered
FactionsAlienUpgrade.permanent			= true									// Controls whether you get the upgrade back when you respawn
FactionsAlienUpgrade.teamType			= kFactionsUpgradeTeamType.AlienTeam	// Team Type

function FactionsAlienUpgrade:Initialize()

	FactionsUpgrade.Initialize(self)

	// This is a base class so never show it in the menu.
	if (self:GetClassName() == "FactionsAlienUpgrade") then
		self.hideUpgrade = true
	end
	self.upgradeType = FactionsAlienUpgrade.upgradeType
	self.triggerType = FactionsAlienUpgrade.triggerType
	self.permanent = FactionsAlienUpgrade.permanent
	self.teamType = FactionsAlienUpgrade.teamType
	
end

function FactionsAlienUpgrade:GetClassName()
	return "FactionsAlienUpgrade"
end

function FactionsAlienUpgrade:CanApplyUpgrade(player)
	if not player:isa("Alien") then
		return "Player must be an Alien!"
	else
		return ""
	end
end

// Give the alien upgrade to the player when they buy the upgrade.
function FactionsAlienUpgrade:OnAdd(player)

	// Apply the same logic to the player as GiveUpgrade does
	player:GiveUpgrade(self.upgradeTechId)

end
