//________________________________
//
//  Factions
//	Made by Jibrail, JimWest, Sewlek
//  Puschen and Winston Smith (MCMLXXXIV)
//  
//  Licensed under LGPL v3.0
//________________________________

// Factions_Alien.lua

Script.Load("lua/Factions/Factions_BuyMenuMixin.lua")

local networkVars = {
	canCamouflage = "boolean",
}

AddMixinNetworkVars(SpeedUpgradeMixin, networkVars)
AddMixinNetworkVars(WeaponUpgradeMixin, networkVars)
AddMixinNetworkVars(HealthUpgradeMixin, networkVars)
AddMixinNetworkVars(ArmorUpgradeMixin, networkVars)
AddMixinNetworkVars(SpawnProtectMixin, networkVars)
AddMixinNetworkVars(CamouflageMixin, networkVars)
AddMixinNetworkVars(FireRateMixin, networkVars)

// Use the new Mixins here.
local overrideOnCreate = Alien.OnCreate
function Alien:OnCreate()

	overrideOnCreate(self)

	// Init mixins
	InitMixin(self, SpeedUpgradeMixin)
	InitMixin(self, WeaponUpgradeMixin)
	InitMixin(self, HealthUpgradeMixin)
	InitMixin(self, ArmorUpgradeMixin)
	InitMixin(self, SpawnProtectMixin)	
	InitMixin(self, BuyMenuMixin)
	InitMixin(self, FireRateMixin)
	
	assert(HasMixin(self, "SpeedUpgrade"))
	assert(HasMixin(self, "WeaponUpgrade"))
	assert(HasMixin(self, "HealthUpgrade"))
	assert(HasMixin(self, "ArmorUpgrade"))
	assert(HasMixin(self, "SpawnProtect"))
	assert(HasMixin(self, "BuyMenu"))
	assert(HasMixin(self, "VariableFireRate"))
	assert(HasMixin(self, "Xp"))
	assert(HasMixin(self, "FactionsUpgrade"))
	
	// Server-only mixins
	if Server then
		InitMixin(self, TimerMixin)
		assert(HasMixin(self, "Timer"))
	end
	
	// Team Colours
	if GetGamerulesInfo():GetUsesAlienColours() then
		InitMixin(self, TeamColoursMixin)
		assert(HasMixin(self, "TeamColours"))
	end
	
end

local overrideOnInitialized = Alien.OnInitialized
function Alien:OnInitialized()

	overrideOnInitialized(self)

	// Alien-specific stuff
	InitMixin(self, CamouflageMixin)	
	assert(HasMixin(self, "Camouflage"))
	
end

function Alien:GetCanCamouflage()
	return self.canCamouflage
end

function Alien:SetCanCamouflage(value)
	self.canCamouflage = value
end

// These let the upgrade system work unimpeded.
function Alien:GetHasTwoHives()
	return true
end

function Alien:GetHasThreeHives()
	return true
end

Class_Reload("Alien", networkVars)