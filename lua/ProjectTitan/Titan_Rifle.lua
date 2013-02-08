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
Rifle.kIronSightActivateTime = 0.3
Rifle.kIronSightDeactivateTime = 0.3

// Use the new Mixins here.
local overrideOnCreate = Rifle.OnCreate
function Rifle:OnCreate()

	overrideOnCreate(self)

	// Init mixins on client.
	if Client then
		local ironSightParameters = { kIronSightTexture = Rifle.kIronSightTexture,
									  kIronSightActivateTime = Rifle.kIronSightActivateTime,
									  kIronSightDeactivateTime = Rifle.kIronSightDeactivateTime }
		InitMixin(self, IronSightMixin, ironSightParameters)
		
		assert(HasMixin(self, "IronSight"))
	end
end

Class_Reload("Rifle", networkVars)