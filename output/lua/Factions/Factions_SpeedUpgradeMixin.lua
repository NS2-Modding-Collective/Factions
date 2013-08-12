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
	upgradeSpeedLevel = "integer (0 to " .. #SpeedUpgrade.cost .. ")"
}

SpeedUpgradeMixin.overrideFunctions =
{
	"GetMaxSpeed",
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

	if HasMixin(self, "FactionsClass") and self:GetHasFactionsClass() then
		local baseSpeed = self:GetBaseMaxSprintSpeed()
		return baseSpeed + baseSpeed*self.upgradeSpeedLevel*SpeedUpgrade.speedBoostPerLevel
	else
		return _G[self:GetClassName()].kRunMaxSpeed
	end

end

function SpeedUpgradeMixin:GetUpgradedMaxSpeed(possible)

	local baseSpeed = 0
	if HasMixin(self, "FactionsClass") and self:GetHasFactionsClass() then
		baseSpeed = self:GetBaseMaxSpeed()
	elseif _G[self:GetClassName()].GetMaxSpeed then
		baseSpeed = _G[self:GetClassName()].GetMaxSpeed(self, possible)
	else
		baseSpeed = Player.GetMaxSpeed(self, possible)
	end
	
	return baseSpeed + baseSpeed*self.upgradeSpeedLevel*SpeedUpgrade.speedBoostPerLevel

end

function SpeedUpgradeMixin:GetMaxSpeed(possible)

	local maxSpeed = Marine.kWalkMaxSpeed
	if HasMixin(self, "FactionsMovement") then
		maxSpeed = FactionsMovement.GetMaxSpeed(self, possible)
	else
		maxSpeed = self:GetUpgradedMaxSpeed()
	end
	
	if maxSpeed == nil then
		maxSpeed = Marine.kWalkMaxSpeed
	end
	
	return maxSpeed
	
end