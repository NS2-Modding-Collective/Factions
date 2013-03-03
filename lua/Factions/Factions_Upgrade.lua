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

FactionsUpgrade.upgradeType = kUpgradeTypes.Tech        		// the type of the upgrade
FactionsUpgrade.triggerType = kTriggerTypes.NoTrigger   		// how the upgrade is gonna be triggered
FactionsUpgrade.levels = 1                                      // if the upgrade has more than one lvl, like weapon or armor ups. Default is 1.
FactionsUpgrade.cost = 9999                                     // cost of the upgrade in xp
FactionsUpgrade.upgradeName = "nil"                         	// name of the upgrade as used in the console, e.g. smg
FactionsUpgrade.upgradeTitle = "nil"                         	// Title of the upgrade, e.g. Submachine Gun
FactionsUpgrade.upgradeDesc = "No discription"                  // discription of the upgrade
FactionsUpgrade.upgradeTechId = kTechId.Move               		// techId of the upgrade, default is kTechId.Move cause its the first entry
FactionsUpgrade.hardCapScale = 0                                // how many people of your team can max. take this upgrade, 1/5 for 1 upgrade per 5 player
FactionsUpgrade.mutuallyExclusive = { }                         // upgrades that can not bought when you got this (like no jp when have exo)

function FactionsUpgrade:GetUpgradeType()
    return self.upgradeType
end

function FactionsUpgrade:GetTriggerType()
    return self.triggerType
end

function FactionsUpgrade:GetLevels()
    return self.levels
end

function FactionsUpgrade:GetCost()
    return self.cost
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

function FactionsUpgrade:GetUpgradeTechId()
    return self.upgradeTechId
end

if kFactionsUpgradeIdCache == nil then
	kFactionsUpgradeIdCache = {}
end

// Implement caching to speed up this function call.
function FactionsUpgrade:GetId()
	local cachedId = kFactionsUpgradeIdCache[self:GetUpgradeName()]
	
	if cachedId == nil then
		for i, factionsUpgrade in ipairs(kAllFactionsUpgrades) do
			if _G[factionsUpgrade] and _G[factionsUpgrade] == self then
				kFactionsUpgradeIdCache[self:GetUpgradeName()] = i
				cachedId = i
			end
		end
	end
	
	return cachedId
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

