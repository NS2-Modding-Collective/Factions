//________________________________
//
//  Factions
//	Made by Jibrail, JimWest, Sewlek
//  Puschen and Winston Smith (MCMLXXXIV)
//  
//  Licensed under LGPL v3.0
//________________________________

// Factions_Rifle.lua

Script.Load("lua/Factions/Weapons/Factions_LaserSightMixin.lua")

local networkVars = {
}

AddMixinNetworkVars(LaserSightMixin, networkVars)

Rifle.kIronSightTexture = "ui/Factions/testing_ironsights.png"
Rifle.kIronSightZoomFOV = 55
Rifle.kIronSightActivateTime = 0.1
Rifle.kLaserSightWorldModelAttachPoint = "fxnode_riflemuzzle"
Rifle.kLaserSightViewModelAttachPoint = "fxnode_riflecasing"

// Iron Sights
local overrideOnCreate = Rifle.OnCreate
function Rifle:OnCreate()

	overrideOnCreate(self)
	
	local laserSightParameters = { kLaserSightWorldModelAttachPoint = Rifle.kLaserSightWorldModelAttachPoint,
								   kLaserSightViewModelAttachPoint = Rifle.kLaserSightViewModelAttachPoint,	}
	InitMixin(self, LaserSightMixin, laserSightParameters)
	
	//assert(HasMixin(self, "LaserSight"))

end

function Rifle:GetIronSightParameters()	
		return { 	kIronSightTexture = Rifle.kIronSightTexture,
					kIronSightZoomFOV = Rifle.kIronSightZoomFOV,
					kIronSightActivateTime = Rifle.kIronSightActivateTime }
end

function Rifle:GetSpread()
	return ClipWeapon.kCone4Degrees
end

Class_Reload("Rifle", networkVars)