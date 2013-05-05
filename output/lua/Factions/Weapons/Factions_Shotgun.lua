//________________________________
//
//  Factions
//	Made by Jibrail, JimWest, Sewlek
//  Puschen and Winston Smith (MCMLXXXIV)
//  
//  Licensed under LGPL v3.0
//________________________________

// Factions_Shotgun.lua

Script.Load("lua/Factions/Weapons/Factions_LaserSightMixin.lua")

local networkVars = {
}

AddMixinNetworkVars(LaserSightMixin, networkVars)

//"shotgun_reloader"
Shotgun.kLaserSightWorldModelAttachPoint = "fxnode_shotgunmuzzle"
Shotgun.kLaserSightViewModelAttachPoint = "shotgun_frontExtender"

local overrideOnCreate = Shotgun.OnCreate
function Shotgun:OnCreate()

	overrideOnCreate(self)
	
	local laserSightParameters = { kLaserSightWorldModelAttachPoint = Shotgun.kLaserSightWorldModelAttachPoint,
								   kLaserSightViewModelAttachPoint = Shotgun.kLaserSightViewModelAttachPoint }
	InitMixin(self, LaserSightMixin, laserSightParameters)
	assert(HasMixin(self, "LaserSight"))
	
end

function Shotgun:GetNumStartClips()
	return 7
end

Class_Reload("Shotgun", networkVars)