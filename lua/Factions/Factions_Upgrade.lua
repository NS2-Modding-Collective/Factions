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

FactionsUpgrade.upgradeType = kUpgradeTypes.Tech        // the type of the upgrade
FactionsUpgrade.triggerType = kTriggerTypes.NoTrigger   // how the upgrade is gonna be triggered
FactionsUpgrade.levels = 0                                      // if the upgrade has more than one lvl, like weapon or armor ups
FactionsUpgrade.cost = 9999                                     // cost of the upgrade in xp
FactionsUpgrade.upgradeName = "nil"                         // name of the upgrade
FactionsUpgrade.upgradeDesc = "No discription"                  // discription of the upgrade
FactionsUpgrade.upgradeTechId =  kTechId.Move                   // techId of the upgrade, default is kTechId.Move cause its the first entry
FactionsUpgrade.requirements = nil                              // upgrade you need to buy first before buying this
FactionsUpgrade.hardCapScale = 0                                // how many people of your team can max. take this upgrade, 1/5 for 1 upgrade per 5 player
FactionsUpgrade.mutuallyExclusive = nil                         // upgrades that can not bought when you got this (like no jp when have exo)

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

function FactionsUpgrade:GetUpgradeDesc()
    return self.upgradeDesc
end

function FactionsUpgrade:GetUpgradeTechId()
    return self.upgradeTechId
end

function FactionsUpgrade:GetRequirements()
    return self.requirements
end

function FactionsUpgrade:GetId()
    for i, upgrade in ipairs(kAllUpgrades) do
        if _G[upgrade] and _G[upgrade] == self then
            return i
        end
    end
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
