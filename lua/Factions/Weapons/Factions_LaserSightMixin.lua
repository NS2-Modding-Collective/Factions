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
}

function LaserSightMixin:__initmixin()

	self.laserSightActive = false
	
end

function LaserSightMixin:GetLaserSightActive()

	local player = self:GetParent()
	if player and player.laserSightActive then
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