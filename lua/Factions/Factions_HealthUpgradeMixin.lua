//________________________________
//
//  Factions
//	Made by Jibrail, JimWest, Sewlek
//  Puschen and Winston Smith (MCMLXXXIV)
//  
//  Licensed under LGPL v3.0
//________________________________

// Factions_HealthUpgradeMixin.lua

Script.Load("lua/Factions/Factions_FactionsClassMixin.lua")

HealthUpgradeMixin = CreateMixin( HealthUpgradeMixin )
HealthUpgradeMixin.type = "HealthUpgrade"

HealthUpgrade.speedBoostPerLevel = 0.1

HealthUpgradeMixin.expectedMixins =
{
}

HealthUpgradeMixin.expectedCallbacks =
{
	GetBaseMaxSprintSpeed = "The speed that the player runs",
	GetBaseMaxSpeed = "The speed that the player walks",
}

HealthUpgradeMixin.expectedConstants =
{
}

HealthUpgradeMixin.networkVars =
{
	upgradeSpeedLevel = "integer (0 to " .. HealthUpgrade.levels .. ")"
}

function HealthUpgradeMixin:__initmixin()

	self.upgradeSpeedLevel = 0

end

function HealthUpgradeMixin:CopyPlayerDataFrom(player)

	self.upgradeSpeedLevel = player.upgradeSpeedLevel

end

function HealthUpgradeMixin:GetUpgradedSprintAcceleration()

	return Marine.kSprintAcceleration
	
end

function HealthUpgradeMixin:GetUpgradedAcceleration()

	return Marine.kAcceleration
	
end

function HealthUpgradeMixin:GetUpgradedMaxSprintSpeed()

	if self:GetHasFactionsClass() then
		return self:GetBaseMaxSprintSpeed()
	else
		return Marine.kRunMaxSpeed
	end

end

function HealthUpgradeMixin:GetUpgradedMaxSpeed()

	if self:GetHasFactionsClass() then
		return self:GetBaseMaxSpeed()
	else
		return Marine.kWalkMaxSpeed
	end

end