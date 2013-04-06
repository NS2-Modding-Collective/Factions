//________________________________
//
//  Factions
//	Made by Jibrail, JimWest, Sewlek
//  Puschen and Winston Smith (MCMLXXXIV)
//  
//  Licensed under LGPL v3.0
//________________________________

// Factions_ClipWeapon.lua

local networkVars = {
}

// Reload Speed etc.
local overrideOnCreate = ClipWeapon.OnCreate
function ClipWeapon:OnCreate()

	overrideOnCreate(self)

	InitMixin(self, ReloadSpeedMixin)
	
	assert(HasMixin(self, "VariableReloadSpeed"))
	
end

Class_Reload("ClipWeapon", networkVars)