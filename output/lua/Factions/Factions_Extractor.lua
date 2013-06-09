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

AddMixinNetworkVars(TeamColoursMixin, networkVars)

// Team Colours
local overrideOnInitialized = Extractor.OnInitialized
function Extractor:OnInitialized()

	overrideOnInitialized(self)

	// Team Colours
	if GetGamerulesInfo():GetUsesMarineColours() then
		InitMixin(self, TeamColoursMixin)
		assert(HasMixin(self, "TeamColours"))
	end
	
end


Class_Reload("Extractor", networkVars)