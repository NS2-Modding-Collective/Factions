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

LightMachineGun.kIronSightTexture = "ui/Factions/testing_ironsights.png"
LightMachineGun.kIronSightZoomFOV = 80
LightMachineGun.kIronSightActivateTime = 0.1

LightMachineGun.kLaserSightWorldModelAttachPoint = "fxnode_riflemuzzle"
LightMachineGun.kLaserSightViewModelAttachPoint = "fxnode_riflemuzzle"

// 4 degrees in NS1
local kSpread = Vector(0, 0, 0)

local networkVars =
{
}

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