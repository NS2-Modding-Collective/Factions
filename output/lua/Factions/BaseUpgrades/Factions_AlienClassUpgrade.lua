//________________________________
//
//  Factions
//	Made by Jibrail, JimWest, Sewlek
//  Puschen and Winston Smith (MCMLXXXIV)
//  
//  Licensed under LGPL v3.0
//________________________________

// Factions_AlienClassUpgrade.lua

// Base class for all weapons and their upgrades

Script.Load("lua/Factions/BaseUpgrades/Factions_Upgrade.lua")
							
class 'AlienClassUpgrade' (FactionsUpgrade)

AlienClassUpgrade.upgradeType 		= kFactionsUpgradeTypes.Lifeform        // the type of the upgrade
AlienClassUpgrade.triggerType 		= kFactionsTriggerTypes.NoTrigger   	// how the upgrade is gonna be triggered
AlienClassUpgrade.permanent			= true									// Controls whether you get the upgrade back when you respawn
AlienClassUpgrade.teamType			= kFactionsUpgradeTeamType.AlienTeam	// Team Type
AlienClassUpgrade.uniqueSlot		= kUpgradeUniqueSlot.AlienClass			// Unique slot

function AlienClassUpgrade:Initialize()

	FactionsUpgrade.Initialize(self)

	// This is a base class so never show it in the menu.
	if (self:GetClassName() == "AlienClassUpgrade") then
		self.hideUpgrade = true
	end
	self.upgradeType = AlienClassUpgrade.upgradeType
	self.triggerType = AlienClassUpgrade.triggerType
	self.permanent = AlienClassUpgrade.permanent
	self.teamType = AlienClassUpgrade.teamType
	self.uniqueSlot = AlienClassUpgrade.uniqueSlot
	
end

function AlienClassUpgrade:GetClassName()
	return "AlienClassUpgrade"
end

function AlienClassUpgrade:CanApplyUpgrade(player)
	if not player:isa("Alien") then
		return "Player must be an Alien!"
	else
		return ""
	end
end

// Give the weapon to the player when they buy the upgrade.
function AlienClassUpgrade:OnAdd(player)

	// Apply the same logic to the player as OnCommandChangeClass does
	if not player:isa(self:GetUpgradeTitle()) then
		player:Replace(self:GetUpgradeName(), player:GetTeamNumber(), false, nil, nil)
	end

end

function AlienClassUpgrade:SendAddMessage(player)
	player:SendDirectMessage("You are now a " .. self:GetUpgradeTitle() .. "!")
end