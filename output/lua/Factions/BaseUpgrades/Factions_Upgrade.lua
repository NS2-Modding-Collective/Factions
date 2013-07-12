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

kFactionsUpgradeTypes = enum({'LevelTied', 'Lifeform', 'Attribute', 'Ability', 'Tech', 'Weapon'})
kFactionsTriggerTypes = enum({'NoTrigger', 'ByTime', 'ByKey'})
kFactionsUpgradeTeamType = enum({'MarineTeam', 'AlienTeam', 'AnyTeam'})
kUpgradeUniqueSlot = enum({'None', 'Weapon1', 'Weapon2', 'Weapon3', 'Weapon4', 'Weapon5', 'Weapon6', 'AlienClass', 'LessReloads' })

kRefundPenalty = 0.2 // 20% is taken away from any refunded amount of xp.

FactionsUpgrade.upgradeType = kFactionsUpgradeTypes.Tech       	// The type of the upgrade
FactionsUpgrade.triggerType = kFactionsTriggerTypes.NoTrigger  	// How the upgrade is gonna be triggered
FactionsUpgrade.currentLevel = 0                               	// The default level of the upgrade. This is incremented when we buy the upgrade
FactionsUpgrade.cost = { 9999 }                                	// Cost of each level of the upgrade in xp
FactionsUpgrade.upgradeName = "nil"                         	// Name of the upgrade as used in the console, e.g. smg
FactionsUpgrade.upgradeTitle = "nil"                         	// Title of the upgrade, e.g. Submachine Gun
FactionsUpgrade.upgradeDesc = "No discription"                 	// Description of the upgrade
FactionsUpgrade.upgradeTechId = { kTechId.Move }             	// Table of the techIds of the upgrade
FactionsUpgrade.requirements = { }                        		// Upgrades you must get before you can get this one.
FactionsUpgrade.permanent = true								// Controls whether you get the upgrade back when you respawn
FactionsUpgrade.disallowedGameModes = { }						// Controls which game modes this applies to
FactionsUpgrade.teamType = kFactionsUpgradeTeamType.AnyTeam		// Controls which team type this applies to
FactionsUpgrade.uniqueSlot = kUpgradeUniqueSlot.None			// Use this to specify that an upgrade occupies a unique slot. When you buy another upgrade in this slot you get a refund for any previous ones.
FactionsUpgrade.mutuallyExclusive = false						// Cannot buy another upgrade in this slot when you have this one.
FactionsUpgrade.hardCapScale = 0                               	// How many people of your team can max. take this upgrade, 1/5 for 1 upgrade per 5 player
FactionsUpgrade.minPlayerLvl = 1								// Controls whether this upgrade requires the recipient to be a minimum level
FactionsUpgrade.isLevelTied = false								// Upgrade is tied to player level

function FactionsUpgrade:Initialize()
	// This is a base class so never show it in the menu.
	if (self:GetClassName() == "FactionsUpgrade") then
		self.hideUpgrade = true
		self.baseUpgrade = true
	end
	self.upgradeType = FactionsUpgrade.upgradeType
	self.triggerType = FactionsUpgrade.triggerType
	self.currentLevel = FactionsUpgrade.currentLevel
	self.cost = FactionsUpgrade.cost
	self.upgradeName = FactionsUpgrade.upgradeName
	self.upgradeTitle = FactionsUpgrade.upgradeTitle
	self.upgradeDesc = FactionsUpgrade.upgradeDesc
	self.upgradeTechId = FactionsUpgrade.upgradeTechId
	self.permanent = FactionsUpgrade.permanent
	self.disallowedGameModes = FactionsUpgrade.disallowedGameModes
	self.teamType = FactionsUpgrade.teamType
	self.uniqueSlot = FactionsUpgrade.uniqueSlot
	self.mutuallyExclusive = FactionsUpgrade.mutuallyExclusive
	self.hardCapScale = FactionsUpgrade.hardCapScale
	self.minPlayerLevel = FactionsUpgrade.minPlayerLevel
	self.isLevelTied = FactionsUpgrade.isLevelTied
end

function FactionsUpgrade:GetIsBaseUpgrade()
	// Convert nil to false!
	if self.baseUpgrade then
		return true
	else
		return false
	end
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
    return #self.cost
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
	return self.currentLevel == self:GetMaxLevels()
end

function FactionsUpgrade:AddLevel()
	if self.currentLevel < self:GetMaxLevels() then
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

function FactionsUpgrade:GetRefundAmount()
	local currentLevel = self:GetCurrentLevel()
	if currentLevel == 0 then
		return 0
	elseif currentLevel == 1 then
		return self:GetCost(currentLevel)*kRefundPenalty
	else
		local previousLevelCost = self:GetCost(currentLevel - 1)
		return (self:GetCost(currentLevel)-previousLevelCost)*kRefundPenalty
	end
end

function FactionsUpgrade:GetCompleteRefundAmount()
	local currentLevel = self:GetCurrentLevel()
	if currentLevel == 0 then
		return 0
	else
		return self:GetCost(currentLevel)*kRefundPenalty
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

function FactionsUpgrade:GetUniqueSlot()
	return self.uniqueSlot
end

function FactionsUpgrade:GetMinPlayerLvl()
	return self.minPlayerLvl
end

function FactionsUpgrade:GetIsTiedToPlayerLvl()
	return self.isLevelTied
end

function FactionsUpgrade:GetHardcapScale()
	return self.hardCapScale
end

function FactionsUpgrade:GetIsMutuallyExclusive()
	return self.mutuallyExclusive
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

function FactionsUpgrade:GetIsAllowedForTeam(teamNumber)

	local playerTeamType = GetGamerulesInfo():GetTeamType(teamNumber)
	
	if  ((self.teamType == kFactionsUpgradeTeamType.MarineTeam and playerTeamType == kMarineTeamType)
		or 
		(self.teamType == kFactionsUpgradeTeamType.AlienTeam and playerTeamType == kAlienTeamType)
		or
		(self.teamType == kFactionsUpgradeTeamType.AnyTeam)
		or 
		(self.teamType == nil)) then
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

// Check for any prerequisite mixins etc here.
function FactionsUpgrade:CanApplyUpgrade(player)
	// Tie the logic into the message... "" == true!
	return ""
end

// Called from the UpgradeMixin when the upgraded is added to a player, old upgradeFunc
// Use this to perform a custom action on add.
function FactionsUpgrade:OnAdd(player)
end

function FactionsUpgrade:SendAddMessage(player)
	// Provide a sensible default here
	player:SendDirectMessage("Purchased " .. self:GetCurrentLevel() .. " of the " .. self:GetUpgradeTitle() .. " upgrade.")
end

// called when the Player is resetted so we can reset all the changes the upgrade has made
function FactionsUpgrade:Reset(player)
end

