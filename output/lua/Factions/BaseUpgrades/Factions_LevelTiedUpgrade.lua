//________________________________
//
//  Factions
//	Made by Jibrail, JimWest, Sewlek
//  Puschen and Winston Smith (MCMLXXXIV)
//  
//  Licensed under LGPL v3.0
//________________________________

// Factions_FactionsLevelTiedUpgrade.lua

// Base class for all weapons and their upgrades

Script.Load("lua/Factions/BaseUpgrades/Factions_Upgrade.lua")
							
class 'FactionsLevelTiedUpgrade' (FactionsUpgrade)

FactionsLevelTiedUpgrade.baseCost		= 0										// the 
FactionsLevelTiedUpgrade.upgradeType 	= kFactionsUpgradeTypes.LevelTied      	// the type of the upgrade
FactionsLevelTiedUpgrade.triggerType 	= kFactionsTriggerTypes.NoTrigger   	// how the upgrade is gonna be triggered
FactionsLevelTiedUpgrade.permanent		= true									// Controls whether you get the upgrade back when you respawn
FactionsLevelTiedUpgrade.teamType		= kFactionsUpgradeTeamType.AnyTeam		// Team Type

function FactionsLevelTiedUpgrade:Initialize()

	FactionsUpgrade.Initialize(self)

	// Never show these in the menu
	self.hideUpgrade = true
	self.cost = { }
	for i = 1, kMaxLvl do
		table.insert(self.cost, FactionsLevelTiedUpgrade.baseCost)
	end 
	self.upgradeType = FactionsLevelTiedUpgrade.upgradeType
	self.triggerType = FactionsLevelTiedUpgrade.triggerType
	self.permanent = FactionsLevelTiedUpgrade.permanent
	self.teamType = FactionsLevelTiedUpgrade.teamType
	
end

function FactionsLevelTiedUpgrade:GetClassName()
	return "FactionsLevelTiedUpgrade"
end

// Default behaviour is to have no message at all.
function FactionsLevelTiedUpgrade:SendAddMessage(player)
end