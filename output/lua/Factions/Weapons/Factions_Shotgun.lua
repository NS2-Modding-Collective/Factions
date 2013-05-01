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
Shotgun.kLaserSightWorldModelAttachPoint = "shotgun_barrels"
Shotgun.kLaserSightViewModelAttachPoint = "shotgun_barrels"

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