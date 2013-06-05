//________________________________
//
//  Factions
//	Made by Jibrail, JimWest, Sewlek
//  Puschen and Winston Smith (MCMLXXXIV)
//  
//  Licensed under LGPL v3.0
//________________________________

// Factions_Sword.lua

Script.Load("lua/Weapons/Marine/Axe.lua")

class 'Sword' (Axe)

Sword.kMapName = "knife"

Sword.kModelName = PrecacheAsset("models/marine/axe/axe.model")
local kViewModelName = PrecacheAsset("models/marine/knife/knife_view.model")
local kAnimationGraph = PrecacheAsset("models/marine/axe/axe_view.animation_graph")

// 4 degrees in NS1
local kSpread = Vector(0, 0, 0)

local networkVars =
{
}

function Sword:OnTag(tagName)
	
	if tagName == "swipe_sound" then
        self:TriggerEffects("axe_attack")
    elseif tagName == "hit" then
    
        local player = self:GetParent()
        if player then
            AttackMeleeCapsuleMulti(self, player, kAxeDamage, self:GetRange())
        end
        
    elseif tagName == "attack_end" then
        self.sprintAllowed = true
    end
end

function Sword:GetAnimationGraphName()
    return kAnimationGraph
end

function Sword:GetViewModelName()
    return kViewModelName
end

function Sword:GetSpread()
    return kSpread
end

function Sword:GetWeight()
    return kLightMachineGunWeight
end

function Sword:OverrideWeaponName()
    return "sword"
end

Shared.LinkClassToMap("Sword", Sword.kMapName, networkVars)