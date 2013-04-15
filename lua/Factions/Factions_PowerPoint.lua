//________________________________
//
//  Factions
//	Made by Jibrail, JimWest, Sewlek
//  Puschen and Winston Smith (MCMLXXXIV)
//  
//  Licensed under LGPL v3.0
//________________________________

// Factions_PowerPoint.lua

Script.Load("lua/Factions/Factions_TeamColoursMixin.lua")

local networkVars = {
}

// Team Colours
local overrideOnInitialized = PowerPoint.OnInitialized
function PowerPoint:OnInitialized()

	overrideOnInitialized(self)

	// Team Colours
	if GetGamerulesInfo():GetUsesMarineColours() then
		InitMixin(self, TeamColoursMixin)
		assert(HasMixin(self, "TeamColours"))
	end

end

function PowerPoint:PowerPointGetCanTakeDamageOverride(self)
    return false
end

Class_Reload("PowerPoint", networkVars)