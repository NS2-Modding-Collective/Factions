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
}

SpeedUpgradeMixin.expectedCallbacks =
{
	GetBaseMaxSprintSpeed = "The speed that the player runs",
	GetBaseSprintAcceleration = "The speed that the player runs",
	GetBaseMaxSpeed = "The speed that the player walks",
	GetBaseAcceleration = "The speed that the player walks",
	
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

	if self:GetHasFactionsClass() then
		return Marine.kSprintAcceleration
	else
		return self:GetBaseSprintAcceleration()
	end
	
end

function SpeedUpgradeMixin:GetUpgradedAcceleration()

	if self:GetHasFactionsClass() then
		return Marine.kAcceleration
	else
		return self:GetBaseAcceleration()
	end
	
end

function SpeedUpgradeMixin:GetUpgradedMaxSprintSpeed()

	if self:GetHasFactionsClass() then
		return Marine.kRunMaxSpeed
	else
		return self:GetBaseMaxSprintSpeed()
	end

end

function SpeedUpgradeMixin:GetUpgradedMaxSpeed()

	if self:GetHasFactionsClass() then
		return Marine.kWalkMaxSpeed
	else
		return self:GetBaseMaxSpeed()
	end

end