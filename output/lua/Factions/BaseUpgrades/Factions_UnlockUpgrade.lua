//________________________________
//
//  Factions
//	Made by Jibrail, JimWest, Sewlek
//  Puschen and Winston Smith (MCMLXXXIV)
//  
//  Licensed under LGPL v3.0
//________________________________

// Factions_UnlockUpgrade.lua

// Base class for all upgrades that unlock another upgrade

Script.Load("lua/Factions/BaseUpgrades/Factions_Upgrade.lua")
							
class 'FactionsUnlockUpgrade' (FactionsUpgrade)

FactionsUnlockUpgrade.upgradeType 	= kFactionsUpgradeTypes.Tech        	// the type of the upgrade
FactionsUnlockUpgrade.triggerType 	= kFactionsTriggerTypes.NoTrigger   	// how the upgrade is gonna be triggered
FactionsUnlockUpgrade.permanent		= true									// Controls whether you get the upgrade back when you respawn

function FactionsUnlockUpgrade:Initialize()

	FactionsUpgrade.Initialize(self)

	// This is a base class so never show it in the menu.
	if (self:GetClassName() == "FactionsUnlockUpgrade") then
		self.hideUpgrade = true
	end
	self.upgradeType = FactionsUnlockUpgrade.upgradeType
	self.triggerType = FactionsUnlockUpgrade.triggerType
	self.permanent = FactionsUnlockUpgrade.permanent
	
end

function FactionsUnlockUpgrade:GetClassName()
	return "FactionsUnlockUpgrade"
end

// Override this function to specify which upgrade you're unlocking.
function FactionsUnlockUpgrade:GetUnlockUpgradeId()
	return nil
end

function FactionsUnlockUpgrade:GetHideUpgrade()
	local hideUpgrade = FactionsUpgrade.GetHideUpgrade(self)
	if self:GetIsAtMaxLevel() then
		hideUpgrade = true
	end
	
	return hideUpgrade
end

function FactionsUnlockUpgrade:CanApplyUpgrade(player)
	if self:GetUnlockUpgradeId() == nil then
		return "No unlock defined!"
	else
		return ""
	end
end

function FactionsUnlockUpgrade:SendAddMessage(player)
	local unlockUpgradeId = self:GetUnlockUpgradeId()
	local unlockUpgrade = player:GetUpgradeById(unlockUpgradeId)
	player:SendDirectMessage("Unlocked " .. unlockUpgrade:GetUpgradeTitle() .. "!")
	// Special: Also add the locked upgrade for the first time here.
	unlockUpgrade:OnAdd(player)
end