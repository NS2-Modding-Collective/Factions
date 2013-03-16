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

kFactionsUpgradeTypes = enum({'Ability', 'Attribute', 'Tech', 'Weapon'})
kFactionsTriggerTypes = enum({'NoTrigger', 'ByTime', 'ByKey'})

function FactionsUpgrade:Initialize()
	self.upgradeType = kFactionsUpgradeTypes.Tech       // the type of the upgrade
	self.triggerType = kFactionsTriggerTypes.NoTrigger  // how the upgrade is gonna be triggered
	self.currentLevel = 0                               // The default level of the upgrade. This is incremented when we buy the upgrade
	self.levels = 1                                     // if the upgrade has more than one lvl, like weapon or armor ups. Default is 1.
	self.cost = { 9999 }                                // cost of each level of the upgrade in xp
	self.upgradeName = "nil"                         	// name of the upgrade as used in the console, e.g. smg
	self.upgradeTitle = "nil"                         	// Title of the upgrade, e.g. Submachine Gun
	self.upgradeDesc = "No discription"                 // discription of the upgrade
	self.upgradeTechId = { kTechId.Move }             	// Table of the techIds of the upgrade
	self.hardCapScale = 0                               // how many people of your team can max. take this upgrade, 1/5 for 1 upgrade per 5 player
	self.mutuallyExclusive = { }                        // upgrades that can not bought when you got this (like no jp when have exo)
	self.permanent = true								// Controls whether you get the upgrade back when you respawn
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

function FactionsUpgrade:ResetLevel()
	self.currentLevel = 0
end

function FactionsUpgrade:GetCostForNextLevel()
	if self:GetIsAtMaxLevel() then
		return 9999
	else
		return self:GetCost(self:GetCurrentLevel() + 1)
	end
end

function FactionsUpgrade:GetCost(level)
    return self.cost[level]
end

function FactionsUpgrade:GetUpgradeName()
    return self.upgradeName
end

function FactionsUpgrade:GetUpgradeTitle()
    return self.upgradeTitle
end

function FactionsUpgrade:GetUpgradeDesc()
    return self.upgradeDesc
end

function FactionsUpgrade:GetUpgradeTechId(level)
    return self.upgradeTechId[level]
end

function FactionsUpgrade:GetIsPermanent()
	return self.permanent
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

// called from the UpgradeMixin when upgrade will be triggered by a key or by time
function FactionsUpgrade:OnTrigger(player)
end

// called when the Player is resetted so we can reset all the changes the upgrade has made
function FactionsUpgrade:Reset(player)
end

