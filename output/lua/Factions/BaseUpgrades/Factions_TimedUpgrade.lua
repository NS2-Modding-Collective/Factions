//________________________________
//
//  Factions
//	Made by Jibrail, JimWest, Sewlek
//  Puschen and Winston Smith (MCMLXXXIV)
//  
//  Licensed under LGPL v3.0
//________________________________

// Factions_UnlockUpgrade.lua

// Base class for all upgrades that use a timer

Script.Load("lua/Factions/BaseUpgrades/Factions_Upgrade.lua")
							
class 'FactionsTimedUpgrade' (FactionsUpgrade)

FactionsTimedUpgrade.upgradeType 		= kFactionsUpgradeTypes.Tech        	// the type of the upgrade
FactionsTimedUpgrade.triggerType 		= kFactionsTriggerTypes.ByTime		   	// how the upgrade is gonna be triggered
FactionsTimedUpgrade.triggerInterval	= { 1 } 								// Specify the timer interval (in seconds) per level.
FactionsTimedUpgrade.permanent			= true									// Controls whether you get the upgrade back when you respawn

function FactionsTimedUpgrade:Initialize()

	FactionsUpgrade.Initialize(self)

	// This is a base class so never show it in the menu.
	if (self:GetClassName() == "FactionsTimedUpgrade") then
		self.hideUpgrade = true
		self.baseUpgrade = true
	end
	self.upgradeType = FactionsTimedUpgrade.upgradeType
	self.triggerType = FactionsTimedUpgrade.triggerType
	self.triggerInterval = FactionsTimedUpgrade.triggerInterval
	self.permanent = FactionsTimedUpgrade.permanent
	
end

function FactionsTimedUpgrade:GetClassName()
	return "FactionsTimedUpgrade"
end

// Override this function to specify which upgrade you're unlocking.
function FactionsTimedUpgrade:GetTimerInterval()
	return self.triggerInterval[self:GetCurrentLevel()]
end

function FactionsTimedUpgrade:GetTimerDescription()
	return "Something will happen every "
end

function FactionsTimedUpgrade:OnTrigger(player)
	Shared.Message("Default timer triggered for upgrade type " .. self:GetClassName() .. " on player " .. player:GetName())
end

function FactionsTimedUpgrade:CanApplyUpgrade(player)
	if Server then
		if not HasMixin(player, "Timer") then
			return "entity must implement TimerMixin!"
		end
	end
	return ""
end

function FactionsTimedUpgrade:OnAdd(player)
	if Server then
		player:AddTimer(self:GetClassName(), self, self.OnTrigger, self:GetTimerInterval())
	end
end

function FactionsTimedUpgrade:SendAddMessage(player)
	player:SendDirectMessage(self:GetUpgradeTitle() .. " upgraded to level " .. self:GetCurrentLevel() .. ".")
	player:SendDirectMessage(self:GetTimerDescription() .. self:GetTimerInterval() .. " seconds.")
end