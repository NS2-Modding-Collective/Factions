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

LaserSightMixin = CreateMixin( LaserSightMixin )
LaserSightMixin.type = "LaserSight"

LaserSightMixin.baseAccuracy = 1
LaserSightMixin.accuracyBoostPerLevel = -0.1

LaserSightMixin.expectedMixins =
{
	Laser = "To actually render the laser",
}

LaserSightMixin.expectedCallbacks =
{
}

LaserSightMixin.overrideFunctions =
{
}

LaserSightMixin.expectedConstants =
{
	kLaserSightAttachPoint = "The name of the node to attach the laser to",
}

LaserSightMixin.networkVars =
{
	laserSightAccuracyScalar = "float",
	laserSightLevel = "integer (0 to " .. #LaserSightUpgrade.cost .. ")",
}

function LaserSightMixin:__initmixin()

	self.laserSightAccuracyScalar = LaserSightMixin.baseAccuracy
	self.laserSightLevel = 0
	
end

function LaserSightMixin:GetLaserSightActive()

	local player = self:GetParent()
	if player and HasMixin(player, "WeaponUpgrade") and player:GetLaserSightLevel() > 0 then
		return true
	end
	
	return false
	
end

// Switch on the laser
function LaserSightMixin:OnUpdateRender() 

	if self:GetLaserSightActive() then
		local mixinConstants = self:GetMixinConstants()    
		local laserSightAttachPoint = mixinConstants.kLaserSightAttachPoint
	end
	
end

function LaserSightMixin:UpdateLaserSightLevel()

	local player = self:GetParent()
    if player and HasMixin(player, "WeaponUpgrade") and self.laserSightLevel ~= player:GetLaserSightLevel() then
	
		self:SetLaserSightLevel(player:GetLaserSightLevel())
		
    end

end

function LaserSightMixin:SetLaserSightLevel(newLevel)

	self.laserSightLevel = newLevel
	self.laserSightAccuracyScalar = LaserSightMixin.baseAccuracy * (self.laserSightLevel * LaserSightMixin.accuracyBoostPerLevel)

end