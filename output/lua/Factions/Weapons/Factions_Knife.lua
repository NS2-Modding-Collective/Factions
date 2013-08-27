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
// Load the best model that we can (some servers may not have Assets2)
local kViewModelName = Axe.kViewModelName
local kBestViewModelName = "models/marine/knife/knife_view.model"
local f=io.open(kBestViewModelName,"r")
if f ~= nil then
	io.close(f)
	f = nil
	kViewModelName = PrecacheAsset(kBestViewModelName)
end
local kAnimationGraph = PrecacheAsset("models/marine/axe/axe_view.animation_graph")

// 4 degrees in NS1
local kSpread = Vector(0, 0, 0)

local networkVars =
{
}

function Knife:OnTag(tagName)
	
	if tagName == "swipe_sound" then
        self:TriggerEffects("axe_attack")
    elseif tagName == "hit" then
    
        local player = self:GetParent()
        if player then
            AttackMeleeCapsuleMulti(self, player, kKnifeDamage, self:GetRange())
        end
        
    elseif tagName == "attack_end" then
        self.sprintAllowed = true
    end
	
end

function Knife:GetAnimationGraphName()
    return kAnimationGraph
end

function Knife:GetViewModelName()
    return kViewModelName
end

function Knife:GetRange()
    return kKnifeRange
end

function Knife:GetSpread()
    return kSpread
end

function Knife:GetWeight()
    return kLightMachineGunWeight
end

function Knife:OverrideWeaponName()
    return "axe"
end

Shared.LinkClassToMap("Knife", Knife.kMapName, networkVars)