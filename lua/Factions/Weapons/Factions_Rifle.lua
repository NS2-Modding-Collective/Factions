//________________________________
//
//  Factions
//	Made by Jibrail, JimWest,
//  Puschen and Winston Smith (MCMLXXXIV)
//  
//  Licensed under LGPL v3.0
//________________________________

// Factions_Rifle.lua

Script.Load("lua/Factions/Weapons/Factions_IronSightMixin.lua")

local networkVars = {
}

AddMixinNetworkVars(IronSightMixin, networkVars)

Rifle.kIronSightTexture = "ui/Factions/testing_ironsights.png"
Rifle.kIronSightZoomFOV = 55
Rifle.kIronSightActivateTime = 0.1

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