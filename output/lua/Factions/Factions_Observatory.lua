//________________________________
//
//  Factions
//	Made by Jibrail, JimWest, Sewlek
//  Puschen and Winston Smith (MCMLXXXIV)
//  
//  Licensed under LGPL v3.0
//________________________________

// Factions_Observatory.lua

Script.Load("lua/Factions/Factions_TeamColoursMixin.lua")

local networkVars = {
}

AddMixinNetworkVars(TeamColoursMixin, networkVars)

// Observatory
local overrideOnCreate = Observatory.OnCreate
function Observatory:OnCreate()

	overrideOnCreate(self)

	// Team Colours
	if GetGamerulesInfo():GetUsesMarineColours() then
		InitMixin(self, TeamColoursMixin)
		assert(HasMixin(self, "TeamColours"))
	end
	
	self.isGhostStructure = false
	
end

local overrideOnInitialized = Observatory.OnInitialized
function Observatory:OnInitialized()

	overrideOnInitialized(self)

	if Server and not HasMixin(self, "MapBlip") then
        InitMixin(self, MapBlipMixin)
    end
end

Class_Reload("Observatory", networkVars)