//________________________________
//
//  Factions
//	Made by Jibrail, JimWest, Sewlek
//  Puschen and Winston Smith (MCMLXXXIV)
//  
//  Licensed under LGPL v3.0
//________________________________

// Factions_Rifle.lua

Script.Load("lua/Factions/Weapons/Factions_IronSightMixin.lua")
Script.Load("lua/Factions/Weapons/Factions_LaserSightMixin.lua")
Script.Load("lua/Factions/Weapons/Factions_ClipSizeMixin.lua")

local networkVars = {
}

AddMixinNetworkVars(IronSightMixin, networkVars)
AddMixinNetworkVars(LaserSightMixin, networkVars)
AddMixinNetworkVars(ClipSizeMixin, networkVars)

Rifle.kIronSightTexture = "ui/Factions/testing_ironsights.png"
Rifle.kIronSightZoomFOV = 55
Rifle.kIronSightActivateTime = 0.1
Rifle.kLaserSightWorldModelAttachPoint = "fxnode_riflemuzzle"
Rifle.kLaserSightViewModelAttachPoint = "fxnode_riflemuzzle"

// Iron Sights
local overrideOnCreate = Rifle.OnCreate
function Rifle:OnCreate()

	overrideOnCreate(self)

	local ironSightParameters = { kIronSightTexture = Rifle.kIronSightTexture,
								  kIronSightZoomFOV = Rifle.kIronSightZoomFOV,
								  kIronSightActivateTime = Rifle.kIronSightActivateTime }
	InitMixin(self, IronSightMixin, ironSightParameters)
	assert(HasMixin(self, "IronSight"))	
	
	local laserSightParameters = { kLaserSightWorldModelAttachPoint = Rifle.kLaserSightWorldModelAttachPoint,
								   kLaserSightViewModelAttachPoint = Rifle.kLaserSightViewModelAttachPoint,	}
	InitMixin(self, LaserSightMixin, laserSightParameters)
	assert(HasMixin(self, "LaserSight"))
	
	local clipSizeParameters = { kBaseClipSize = kRifleClipSize,
								 kClipSizeIncrease = 5, }
	InitMixin(self, ClipSizeMixin, clipSizeParameters)
	assert(HasMixin(self, "VariableClipSize"))	

end

function Rifle:GetSpread()
	return ClipWeapon.kCone4Degrees
end

Class_Reload("Rifle", networkVars)