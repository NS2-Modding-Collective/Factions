//________________________________
//
//  Factions
//	Made by Jibrail, JimWest, Sewlek
//  Puschen and Winston Smith (MCMLXXXIV)
//  
//  Licensed under LGPL v3.0
//________________________________

// Factions_InfantryPortal.lua

Script.Load("lua/Factions/Factions_TeamColoursMixin.lua")

local networkVars = {
}

AddMixinNetworkVars(TeamColoursMixin, networkVars)

// Iron Sights
local overrideOnCreate = InfantryPortal.OnCreate
function InfantryPortal:OnCreate()

	overrideOnCreate(self)

	InitMixin(self, TeamColoursMixin)
	
	assert(HasMixin(self, "TeamColours"))
end

function InfantryPortal:GetRequiresPower()
   return false
end

Class_Reload("InfantryPortal", networkVars)