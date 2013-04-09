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
class 'FactionsUpgrade'

kFactionsUpgradeTypes = enum({'Lifeform', 'Attribute', 'Ability', 'Tech', 'Weapon'})
kFactionsTriggerTypes = enum({'NoTrigger', 'ByTime', 'ByKey'})
kFactionsUpgradeTeamType = enum({'MarineTeam', 'AlienTeam', 'AnyTeam'})

FactionsUpgrade.upgradeType = kFactionsUpgradeTypes.Tech       	// The type of the upgrade
FactionsUpgrade.triggerType = kFactionsTriggerTypes.NoTrigger  	// How the upgrade is gonna be triggered
FactionsUpgrade.currentLevel = 0                               	// The default level of the upgrade. This is incremented when we buy the upgrade
FactionsUpgrade.levels = 1                                     	// If the upgrade has more than one lvl, like weapon or armor ups. Default is 1.
FactionsUpgrade.cost = { 9999 }                                	// Cost of each level of the upgrade in xp
FactionsUpgrade.upgradeName = "nil"                         	// Name of the upgrade as used in the console, e.g. smg
FactionsUpgrade.upgradeTitle = "nil"                         	// Title of the upgrade, e.g. Submachine Gun
FactionsUpgrade.upgradeDesc = "No discription"                 	// Description of the upgrade
FactionsUpgrade.upgradeTechId = { kTechId.Move }             	// Table of the techIds of the upgrade
FactionsUpgrade.hardCapScale = 0                               	// How many people of your team can max. take this upgrade, 1/5 for 1 upgrade per 5 player
FactionsUpgrade.mutuallyExclusive = { }                        	// Upgrades that can not bought when you got this (like no jp when have exo)
FactionsUpgrade.requirements = { }                        		// Upgrades you must get before you can get this one.
FactionsUpgrade.permanent = true								// Controls whether you get the upgrade back when you respawn
FactionsUpgrade.disallowedGameModes = { }							// Controls which game modes this applies to
FactionsUpgrade.teamType = kFactionsUpgradeTeamType.AnyTeam		// Controls which team type this applies to

function FactionsUpgrade:Initialize()
	// This is a base class so never show it in the menu.
	if (self:GetClassName() == "FactionsUpgrade") then
		self.hideUpgrade = true
	end
	self.upgradeType = FactionsUpgrade.upgradeType
	self.triggerType = FactionsUpgrade.triggerType
	self.currentLevel = FactionsUpgrade.currentLevel
	self.levels = FactionsUpgrade.levels
	self.cost = FactionsUpgrade.cost
	self.upgradeName = FactionsUpgrade.upgradeName
	self.upgradeTitle = FactionsUpgrade.upgradeTitle
	self.upgradeDesc = FactionsUpgrade.upgradeDesc
	self.upgradeTechId = FactionsUpgrade.upgradeTechId
	self.hardCapScale = FactionsUpgrade.hardCapScale
	self.mutuallyExclusive = FactionsUpgrade.mutuallyExclusive
	self.permanent = FactionsUpgrade.permanent
	self.disallowedGameModes = FactionsUpgrade.disallowedGameModes
	self.teamType = FactionsUpgrade.teamType
end

function FactionsUpgrade:GetHideUpgrade()
	// Convert nil to false!
	if self.hideUpgrade then
		return true
	else
		return false
	end
end

function FactionsUpgrade:GetUpgradeType()
    return self.upgradeType
end

function FactionsUpgrade:GetTriggerType()
    return self.triggerType
end

function FactionsUpgrade:GetMaxLevels()
    return self.levels
end

function FactionsUpgrade:GetCurrentLevel()
    return self.currentLevel
end

function FactionsUpgrade:GetNextLevel()
	if self:GetIsAtMaxLevel() then
		return self:GetMaxLevels()
	else
		return self.currentLevel + 1
	end
end

function FactionsUpgrade:GetIsAtMaxLevel()
	return self.currentLevel == self.levels
end

function FactionsUpgrade:AddLevel()
	if self.currentLevel < self.levels then
		self.currentLevel = self.currentLevel + 1
	end
end

function FactionsUpgrade:SetLevel(newLevel)
	self.currentLevel = newLevel
end


function FactionsUpgrade:ResetLevel()
	self.currentLevel = 0
end

function FactionsUpgrade:GetCostForNextLevel()
	if self:GetIsAtMaxLevel() then
		return 9999
	else
		return self:GetCost(self:GetNextLevel())
	end
end

function FactionsUpgrade:GetCost(level)
	if level > self:GetMaxLevels() then
		return 9999
	else
		return self.cost[level]
	end
end

function FactionsUpgrade:GetUpgradeName()
	if self.upgradeName == "nil" then
		return self:GetClassName()
	else
		return self.upgradeName
	end
end

function FactionsUpgrade:GetUpgradeTitle()
    return self.upgradeTitle
end

function FactionsUpgrade:GetUpgradeDesc()
    return self.upgradeDesc
end

function FactionsUpgrade:GetUpgradeTechId()
    return self.upgradeTechId
end

function FactionsUpgrade:GetIsPermanent()
	return self.permanent
end

function FactionsUpgrade:GetRequirements()
	return self.requirements
end

function FactionsUpgrade:GetDisallowedGameModes()
	return self.disallowedGameModes
end

function FactionsUpgrade:GetIsAllowedForThisGameMode()

	for index, gamemode in ipairs(self.disallowedGameModes) do
		if GetGamerulesInfo():GetGameType() == gamemode then
			return false
		end
	end
	
	return true
end

function FactionsUpgrade:GetTeamType()
	return self.teamType
end

function FactionsUpgrade:GetIsAllowedForThisTeam(team)

	if  team ~= nil and
		((self.teamType == kFactionsUpgradeTeamType.MarineTeam and team:isa("MarineTeam"))
		or 
		(self.teamType == kFactionsUpgradeTeamType.AlienTeam and team:isa("AlienTeam"))
		or
		(self.teamType == kFactionsUpgradeTeamType.AnyTeam)) then
		return true
	else
		return false
	end
end

if kFactionsUpgradeIdCache == nil then
	kFactionsUpgradeIdCache = {}
end

// Implement caching to speed up this function call.
function FactionsUpgrade:GetId()
	local cachedId = kFactionsUpgradeIdCache[self:GetClassName()]
	
	if cachedId == nil then
		for index, upgradeName in ipairs(kAllFactionsUpgrades) do
			if upgradeName == self:GetClassName() then
				kFactionsUpgradeIdCache[self:GetClassName()] = index
				cachedId = index
			end
		end
	end
	
	return cachedId
end

// IMPORTANT! Override this in every derived class...
// I think that NS2 should fill these in for us but for some reason it isn't...
function FactionsUpgrade:GetClassName()
	return "FactionsUpgrade"
end

// called from the UpgradeMixin when the upgraded is added to a player, old upgradeFunc
function FactionsUpgrade:OnAdd(player)
end

// called when the Player is resetted so we can reset all the changes the upgrade has made
function FactionsUpgrade:Reset(player)
end

