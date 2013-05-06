//________________________________
//
//  Factions
//	Made by Jibrail, JimWest, Sewlek
//  Puschen and Winston Smith (MCMLXXXIV)
//  
//  Licensed under LGPL v3.0
//________________________________

// Factions_GrenadeLauncher.lua

Script.Load("lua/Factions/Weapons/Factions_LaserSightMixin.lua")
Script.Load("lua/Factions/Weapons/Factions_ClipSizeMixin.lua")

local networkVars = {
}

AddMixinNetworkVars(ClipSizeMixin, networkVars)

local overrideOnCreate = GrenadeLauncher.OnCreate
function GrenadeLauncher:OnCreate()

	overrideOnCreate(self)
	
	local clipSizeParameters = { kBaseClipSize = kGrenadeLauncherClipSize,
								 kClipSizeIncrease = 1, }
	InitMixin(self, ClipSizeMixin, clipSizeParameters)
	assert(HasMixin(self, "VariableClipSize"))	
	
end

Class_Reload("GrenadeLauncher", networkVars)