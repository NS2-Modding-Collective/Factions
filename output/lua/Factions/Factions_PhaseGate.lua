//________________________________
//
//  Factions
//	Made by Jibrail, JimWest, Sewlek
//  Puschen and Winston Smith (MCMLXXXIV)
//  
//  Licensed under LGPL v3.0
//________________________________

// Factions_PhaseGate.lua

Script.Load("lua/Factions/Factions_TeamColoursMixin.lua")

local networkVars = {
}

AddMixinNetworkVars(TeamColoursMixin, networkVars)

// PhaseGate
local overrideOnCreate = PhaseGate.OnCreate
function PhaseGate:OnCreate()

	overrideOnCreate(self)

	// Team Colours
	if GetGamerulesInfo():GetUsesMarineColours() then
		InitMixin(self, TeamColoursMixin)
		assert(HasMixin(self, "TeamColours"))
	end
	
	self.isGhostStructure = false
	
end

local overrideOnInitialized = PhaseGate.OnInitialized
function PhaseGate:OnInitialized()

	overrideOnInitialized(self)

	if not HasMixin(self, "MapBlip") then
        InitMixin(self, MapBlipMixin)
    end
end

Class_Reload("PhaseGate", networkVars)