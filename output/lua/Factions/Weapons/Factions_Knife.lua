//________________________________
//
//  Factions
//	Made by Jibrail, JimWest, Sewlek
//  Puschen and Winston Smith (MCMLXXXIV)
//  
//  Licensed under LGPL v3.0
//________________________________

// Factions_Knife.lua

Script.Load("lua/Weapons/Marine/Axe.lua")

class 'Knife' (Axe)

Knife.kMapName = "knife"

Knife.kModelName = PrecacheAsset("models/marine/axe/axe.model")
local kViewModelName = PrecacheAsset("models/marine/knife/knife_view.model")
local kAnimationGraph = PrecacheAsset("models/marine/axe/axe_view.animation_graph")

// 4 degrees in NS1
local kSpread = Vector(0, 0, 0)

local networkVars =
{
}

/*
function Knife:OnTag(tagName)
	// Do some multiple-hit logic here
	// A cone?
	local teamNumber = 2
	local hits = Shared.FindEntitiesForTeamInRange(teamNumber, kAxeAttackRange)
	for index, victim in ientitylist(hits) do
		victim:TakeDamage(kKnifeDamage)
	end
end
*/

function Knife:GetAnimationGraphName()
    return kAnimationGraph
end

function Knife:GetViewModelName()
    return kViewModelName
end

function Knife:GetSpread()
    return kSpread
end

function Knife:GetWeight()
    return kLightMachineGunWeight
end

function Knife:OverrideWeaponName()
    return "knife"
end

Shared.LinkClassToMap("Knife", Knife.kMapName, networkVars)