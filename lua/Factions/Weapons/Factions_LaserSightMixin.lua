//________________________________
//
//  Factions
//	Made by Jibrail, JimWest, Sewlek
//  Puschen and Winston Smith (MCMLXXXIV)
//  
//  Licensed under LGPL v3.0
//________________________________

// Factions_LaserSightMixin.lua

Script.Load("lua/FunctionContracts.lua")

LaserSightMixin = CreateMixin( IronSightMixin )
LaserSightMixin.type = "LaserSight"

LaserSightMixin.baseAccuracy = 1
LaserSightMixin.accuracyBoostPerLevel = 0.1

LaserSightMixin.expectedMixins =
{
	Laser = "To actually render the laser"
}

LaserSightMixin.expectedCallbacks =
{
}

LaserSightMixin.overrideFunctions =
{
}

LaserSightMixin.expectedConstants =
{
}

LaserSightMixin.networkVars =
{
	accuracyScalar = "float",
	laserSightLevel = "integer (0 to " .. LaserSightUpgrade.levels .. ")",
}

function LaserSightMixin:__initmixin()

	self.accuracyScalar = LaserSightMixin.baseAccuracy
	self.laserSightLevel = 0
	
end

function LaserSightMixin:GetLaserSightActive()

	local player = self:GetParent()
	if player and HasMixin("WeaponUpgrade") and player:GetLaserSightLevel() > 0 then
		return true
	end
	
	return false
	
end

// Switch on the laser
function LaserSightMixin:OnSetActive() 

	local active = self:GetLaserSightActive()
	if active then
		// activate lazors
	end
	
end

function LaserSightMixin:UpdateLaserSightLevel()

	local player = self:GetParent()
    if player and and HasMixin("WeaponUpgrade") and self.laserSightLevel ~= player:GetLaserSightLevel() then
	
		self:SetLaserSightLevel(player:GetLaserSightLevel())
		
    end

end

function LaserSightMixin:SetLaserSightLevel(newLevel)

	self.laserSightLevel = newLevel
	self.accuracyScalar = LaserSightMixin.baseAccuracy - (self.reloadSpeedLevel * LaserSightMixin.accuracyBoostPerLevel)

end