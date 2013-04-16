//________________________________
//
//  Factions
//	Made by Jibrail, JimWest, Sewlek
//  Puschen and Winston Smith (MCMLXXXIV)
//  
//  Licensed under LGPL v3.0
//________________________________

// Factions_Weapon.lua

local networkVars = {
}

AddMixinNetworkVars(FireRateMixin, networkVars)

// Reload Speed etc.
local overrideOnCreate = Weapon.OnCreate
function Weapon:OnCreate()

	overrideOnCreate(self)

	InitMixin(self, FireRateMixin)
	
	assert(HasMixin(self, "VariableFireRate"))
	
end

Class_Reload("Weapon", networkVars)