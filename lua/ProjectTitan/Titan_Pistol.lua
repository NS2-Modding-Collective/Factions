//________________________________
//
//  Project Titan (working title)
//	Made by Jibrail, JimWest,
//  Puschen and Winston Smith (MCMLXXXIV)
//  
//  Licensed under LGPL v3.0
//________________________________

// Titan_Pistol.lua

local networkVars = {
}

Pistol.kIronSightTexture = "ui/ProjectTitan/testing_ironsights.png"
Pistol.kIronSightZoomFOV = 70
Pistol.kIronSightActivateTime = 0.10

// Iron Sights
local overrideOnCreate = Pistol.OnCreate
function Pistol:OnCreate()

	overrideOnCreate(self)

	local ironSightParameters = { kIronSightTexture = Pistol.kIronSightTexture,
								  kIronSightZoomFOV = Pistol.kIronSightZoomFOV,
								  kIronSightActivateTime = Pistol.kIronSightActivateTime }
	InitMixin(self, IronSightMixin, ironSightParameters)
	
	assert(HasMixin(self, "IronSight"))
end

function Pistol:GetNumStartClips()
	return 6
end

function Pistol:GetClipSize()
	return kPistolClipSize
end

Class_Reload("Pistol", networkVars)