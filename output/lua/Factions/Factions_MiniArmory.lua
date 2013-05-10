//________________________________
//
//  Factions
//	Made by Jibrail, JimWest, Sewlek
//  Puschen and Winston Smith (MCMLXXXIV)
//  
//  Licensed under LGPL v3.0
//________________________________

// Factions_Armory_Mini.lua

Script.Load("lua/ExtraEntitiesMod/ScaledModelMixin.lua")

class 'MiniArmory' (Armory)

MiniArmory.kMapName = "mini_armory"
MiniArmory.kModelName = Armory.kModelName
MiniArmory.kAnimationGraph = Armory.kAnimationGraph
MiniArmory.kScale = Vector(0.3, 0.3, 0.3)

local networkVars =
{
}

AddMixinNetworkVars(ScaledModelMixin, networkVars)

function MiniArmory:OnInitialized()
	Armory.OnInitialized(self)
	
	self:SetScaledModel(MiniArmory.kModelName, MiniArmory.kAnimationGraph)
	if not self.scale then
        self.scale = MiniArmory.kScale
    end
end

Shared.LinkClassToMap("MiniArmory", MiniArmory.kMapName, networkVars)