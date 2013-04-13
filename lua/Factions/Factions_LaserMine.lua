//________________________________
//
//  Factions
//	Made by Jibrail, JimWest, Sewlek
//  Puschen and Winston Smith (MCMLXXXIV)
//  
//  Licensed under LGPL v3.0
//________________________________

// Factions_LaserMine.lua

Script.Load("lua/Factions/Factions_TeamColoursMixin.lua")

local networkVars = {
}

class 'LaserMine' (ScriptActor)

LaserMine.kMapName = "active_laser_mine"

LaserMine.kModelName = PrecacheAsset("models/marine/mine/mine.model")

// Frickin Lasers!
function LaserMine:OnCreate()

	LaserMine.OnCreate(self)
	
	InitMixin(self, LaserMixin)
	assert(HasMixin(self, "LaserMixin"))

	// Team Colours
	if GetGamerulesInfo():GetUsesMarineColours() then
		InitMixin(self, TeamColoursMixin)
		assert(HasMixin(self, "TeamColours"))
	end
end

Shared.LinkClassToMap("LaserMine", Mine.kMapName, networkVars)