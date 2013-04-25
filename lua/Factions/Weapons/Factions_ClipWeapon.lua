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

Script.Load("lua/Factions/Weapons/Factions_ReloadSpeedMixin.lua")
Script.Load("lua/Factions/Weapons/Factions_SpreadMixin.lua")

AddMixinNetworkVars(ReloadSpeedMixin, networkVars)
AddMixinNetworkVars(SpreadMixin, networkVars)

// Reload Speed etc.
local overrideOnCreate = ClipWeapon.OnCreate
function ClipWeapon:OnCreate()

	overrideOnCreate(self)

	InitMixin(self, ReloadSpeedMixin)
	InitMixin(self, SpreadMixin)
	
	assert(HasMixin(self, "VariableReloadSpeed"))
	assert(HasMixin(self, "Spread"))
	
end

Class_Reload("ClipWeapon", networkVars)