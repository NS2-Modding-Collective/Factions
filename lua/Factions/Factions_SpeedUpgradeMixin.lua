//________________________________
//
//  Factions
//	Made by Jibrail, JimWest, Sewlek
//  Puschen and Winston Smith (MCMLXXXIV)
//  
//  Licensed under LGPL v3.0
//________________________________

// Factions_SpeedBoostMixin.lua

Script.Load("lua/Factions/Factions_FactionsClassMixin.lua")

SpeedUpgradeMixin = CreateMixin( SpeedUpgradeMixin )
SpeedUpgradeMixin.type = "SpeedUpgrade"

SpeedUpgrade.speedBoostPerLevel = 0.1

SpeedUpgradeMixin.expectedMixins =
{
	FactionsClass = "Needed for changing the movement speed depending on class.",
}

SpeedUpgradeMixin.expectedCallbacks =
{
	GetBaseMaxSprintSpeed = "The speed that the player runs",
	GetBaseMaxSpeed = "The speed that the player walks",
}

SpeedUpgradeMixin.expectedConstants =
{
}

SpeedUpgradeMixin.networkVars =
{
	upgradeSpeedLevel = "integer (0 to " .. SpeedUpgrade.levels .. ")"
}

function SpeedUpgradeMixin:__initmixin()

	self.upgradeSpeedLevel = 0

end

function SpeedUpgradeMixin:CopyPlayerDataFrom(player)

	self.upgradeSpeedLevel = player.upgradeSpeedLevel

end

// Boost the player's speed by the number of levels taken.
local function ApplySprintScalar(player, originalSpeed)
	return originalSpeed + (originalSpeed * SpeedUpgrade.speedBoostPerLevel * player.upgradeSpeedLevel)
end

function SpeedUpgradeMixin:GetUpgradedSprintAcceleration()

	return Marine.kSprintAcceleration
	
end

function SpeedUpgradeMixin:GetUpgradedAcceleration()

	return Marine.kAcceleration
	
end

function SpeedUpgradeMixin:GetUpgradedMaxSprintSpeed()

	if HasMixin(self, "FactionsClass") then
		local baseSpeed = self:GetBaseMaxSprintSpeed()
		return baseSpeed + baseSpeed*self.upgradeSpeedLevel*SpeedUpgrade.speedBoostPerLevel
	else
		return _G[self:GetClassName()].kRunMaxSpeed
	end

end

function SpeedUpgradeMixin:GetUpgradedMaxSpeed()

	if HasMixin(self, "FactionsClass") then
		local baseSpeed = self:GetBaseMaxSpeed()
		return baseSpeed + baseSpeed*self.upgradeSpeedLevel*SpeedUpgrade.speedBoostPerLevel
	else
		return _G[self:GetClassName()].kWalkMaxSpeed
	end

end