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

class 'LightMachineGun' (ClipWeapon)

LightMachineGun.kMapName = "lmg"

LightMachineGun.kModelName = PrecacheAsset("models/marine/lightmachinegun/lightmachinegun.model")
local kViewModelName = PrecacheAsset("models/marine/lightmachinegun/lightmachinegun_view.model")
local kAnimationGraph = PrecacheAsset("models/marine/lightmachinegun/lightmachinegun_view.animation_graph")



// Frickin Lasers!
function Mine:OnCreate()

	Mine.OnCreate(self)
	
	InitMixin(self, LaserMixin)
	assert(HasMixin(self, "LaserMixin"))

	// Team Colours
	if GetGamerulesInfo():GetUsesMarineColours() then
		InitMixin(self, TeamColoursMixin)
		assert(HasMixin(self, "TeamColours"))
	end
end

Class_Reload("Mine", networkVars)