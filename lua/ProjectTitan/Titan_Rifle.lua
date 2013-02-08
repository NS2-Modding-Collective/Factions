//________________________________
//
//  Project Titan (working title)
//	Made by Jibrail, JimWest,
//  Puschen and Winston Smith (MCMLXXXIV)
//  
//  Licensed under LGPL v3.0
//________________________________

// Titan_Rifle.lua

Script.Load("lua/ProjectTitan/Titan_IronSightMixin.lua")

local networkVars = {
}

AddMixinNetworkVars(IronSightMixin, networkVars)

Rifle.kIronSightTexture = "ui/ProjectTitan/testing_ironsights.png"
Rifle.kIronSightZoomFOV = 55
Rifle.kIronSightActivateTime = 0.15

// Iron Sights
local overrideOnCreate = Rifle.OnCreate
function Rifle:OnCreate()

	overrideOnCreate(self)

	local ironSightParameters = { kIronSightTexture = Rifle.kIronSightTexture,
								  kIronSightZoomFOV = Rifle.kIronSightZoomFOV,
								  kIronSightActivateTime = Rifle.kIronSightActivateTime }
	InitMixin(self, IronSightMixin, ironSightParameters)
	
	assert(HasMixin(self, "IronSight"))
end

Class_Reload("Rifle", networkVars)