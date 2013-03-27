//________________________________
//
//  Factions
//	Made by Jibrail, JimWest, Sewlek
//  Puschen and Winston Smith (MCMLXXXIV)
//  
//  Licensed under LGPL v3.0
//________________________________

// Factions_Extractor.lua

Script.Load("lua/Factions/Factions_TeamColoursMixin.lua")

local networkVars = {
}

// Iron Sights
local overrideOnCreate = Extractor.OnCreate
function Extractor:OnCreate()

	overrideOnCreate(self)

	InitMixin(self, TeamColoursMixin)
	
	assert(HasMixin(self, "TeamColours"))
end

Class_Reload("Extractor", networkVars)