//________________________________
//
//  Factions
//	Made by Jibrail, JimWest, Sewlek
//  Puschen and Winston Smith (MCMLXXXIV)
//  
//  Licensed under LGPL v3.0
//________________________________

// Factions_Lerk.lua

Script.Load("lua/Factions/Factions_TimerMixin.lua")
Script.Load("lua/Factions/Factions_SpeedUpgradeMixin.lua")
Script.Load("lua/Factions/Factions_WeaponUpgradeMixin.lua")
Script.Load("lua/Factions/Factions_HealthUpgradeMixin.lua")
Script.Load("lua/Factions/Factions_ArmorUpgradeMixin.lua")
Script.Load("lua/Factions/Factions_SpawnProtectMixin.lua")

local networkVars = {
}

AddMixinNetworkVars(SpeedUpgradeMixin, networkVars)
AddMixinNetworkVars(WeaponUpgradeMixin, networkVars)
AddMixinNetworkVars(HealthUpgradeMixin, networkVars)
AddMixinNetworkVars(ArmorUpgradeMixin, networkVars)
AddMixinNetworkVars(SpawnProtectMixin, networkVars)

// Use the new Mixins here.
local overrideOnCreate = Lerk.OnCreate
function Lerk:OnCreate()

	overrideOnCreate(self)

	// Init mixins
	InitMixin(self, SpeedUpgradeMixin)
	InitMixin(self, WeaponUpgradeMixin)
	InitMixin(self, HealthUpgradeMixin)
	InitMixin(self, ArmorUpgradeMixin)
	InitMixin(self, SpawnProtectMixin)
	
	assert(HasMixin(self, "SpeedUpgrade"))
	assert(HasMixin(self, "WeaponUpgrade"))
	assert(HasMixin(self, "HealthUpgrade"))
	assert(HasMixin(self, "ArmorUpgrade"))
	assert(HasMixin(self, "SpawnProtect"))
	assert(HasMixin(self, "Xp"))
	assert(HasMixin(self, "FactionsUpgrade"))
	
	// Server-only mixins
	if Server then
		InitMixin(self, TimerMixin)
		assert(HasMixin(self, "Timer"))
	end
	
end

Class_Reload("Lerk", networkVars)