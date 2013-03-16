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

FactionsUpgrade.upgradeType = kFactionsUpgradeTypes.Tech       	// the type of the upgrade
FactionsUpgrade.triggerType = kFactionsTriggerTypes.NoTrigger  	// how the upgrade is gonna be triggered
FactionsUpgrade.currentLevel = 0                               	// The default level of the upgrade. This is incremented when we buy the upgrade
FactionsUpgrade.levels = 1                                     	// if the upgrade has more than one lvl, like weapon or armor ups. Default is 1.
FactionsUpgrade.cost = { 9999 }                                	// cost of each level of the upgrade in xp
FactionsUpgrade.upgradeName = "nil"                         	// name of the upgrade as used in the console, e.g. smg
FactionsUpgrade.upgradeTitle = "nil"                         	// Title of the upgrade, e.g. Submachine Gun
FactionsUpgrade.upgradeDesc = "No discription"                 	// Description of the upgrade
FactionsUpgrade.upgradeTechId = { kTechId.Move }             	// Table of the techIds of the upgrade
FactionsUpgrade.hardCapScale = 0                               	// how many people of your team can max. take this upgrade, 1/5 for 1 upgrade per 5 player
FactionsUpgrade.mutuallyExclusive = { }                        	// upgrades that can not bought when you got this (like no jp when have exo)
FactionsUpgrade.permanent = true								// Controls whether you get the upgrade back when you respawn

function FactionsUpgrade:Initialize()
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

