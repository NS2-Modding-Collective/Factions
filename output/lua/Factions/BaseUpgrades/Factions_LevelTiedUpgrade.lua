//________________________________
//
//  Factions
//	Made by Jibrail, JimWest, Sewlek
//  Puschen and Winston Smith (MCMLXXXIV)
//  
//  Licensed under LGPL v3.0
//________________________________

// Factions_LevelTiedUpgrade.lua

// Base class for all weapons and their upgrades

Script.Load("lua/Factions/BaseUpgrades/Factions_Upgrade.lua")
							
class 'LevelTiedUpgrade' (FactionsUpgrade)

LevelTiedUpgrade.baseCost		= 0										// the 
LevelTiedUpgrade.upgradeType 	= kFactionsUpgradeTypes.LevelTied      	// the type of the upgrade
LevelTiedUpgrade.triggerType 	= kFactionsTriggerTypes.NoTrigger   	// how the upgrade is gonna be triggered
LevelTiedUpgrade.permanent		= true									// Controls whether you get the upgrade back when you respawn
LevelTiedUpgrade.teamType		= kFactionsUpgradeTeamType.AnyTeam		// Team Type
LevelTiedUpgrade.isLevelTied	 = true									// Upgrade is tied to player level

function LevelTiedUpgrade:Initialize()

	FactionsUpgrade.Initialize(self)

	// Never show these in the menu
	self.hideUpgrade = true
	self.cost = { }
	for i = 1, kMaxLvl do
		table.insert(self.cost, LevelTiedUpgrade.baseCost)
	end 
	self.upgradeType = LevelTiedUpgrade.upgradeType
	self.triggerType = LevelTiedUpgrade.triggerType
	self.permanent = LevelTiedUpgrade.permanent
	self.teamType = LevelTiedUpgrade.teamType
	self.isLevelTied = LevelTiedUpgrade.isLevelTied
	
end

function LevelTiedUpgrade:GetClassName()
	return "LevelTiedUpgrade"
end

// Default behaviour is to have no message at all.
function LevelTiedUpgrade:SendAddMessage(player)
end