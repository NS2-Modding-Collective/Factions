//________________________________
//
//  Factions
//	Made by Jibrail, JimWest, Sewlek
//  Puschen and Winston Smith (MCMLXXXIV)
//  
//  Licensed under LGPL v3.0
//________________________________

// Factions_Pistol.lua

Script.Load("lua/Factions/Weapons/Factions_IronSightMixin.lua")
Script.Load("lua/Factions/Weapons/Factions_LaserSightMixin.lua")

local networkVars = {
}

AddMixinNetworkVars(IronSightMixin, networkVars)
AddMixinNetworkVars(LaserSightMixin, networkVars)

Pistol.kIronSightTexture = "ui/Factions/testing_ironsights.png"
Pistol.kIronSightZoomFOV = 70
Pistol.kIronSightActivateTime = 0.10
Pistol.kLaserSightWorldModelAttachPoint = "fxnode_laser"
Pistol.kLaserSightViewModelAttachPoint = "fxnode_laser"

// Iron Sights
local overrideOnCreate = Pistol.OnCreate
function Pistol:OnCreate()

	overrideOnCreate(self)

	local ironSightParameters = { kIronSightTexture = Pistol.kIronSightTexture,
								  kIronSightZoomFOV = Pistol.kIronSightZoomFOV,
								  kIronSightActivateTime = Pistol.kIronSightActivateTime }
	InitMixin(self, IronSightMixin, ironSightParameters)
	
	local laserSightParameters = { kLaserSightWorldModelAttachPoint = Pistol.kLaserSightWorldModelAttachPoint,
								   kLaserSightViewModelAttachPoint = Pistol.kLaserSightViewModelAttachPoint }
	InitMixin(self, LaserSightMixin, laserSightParameters)
	assert(HasMixin(self, "LaserSight"))
	
end

function Pistol:GetNumStartClips()
	return 6
end

function Pistol:GetClipSize()
	return kPistolClipSize
end

Class_Reload("Pistol", networkVars)