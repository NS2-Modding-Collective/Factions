//________________________________
//
//  Factions
//	Made by Jibrail, JimWest, Sewlek
//  Puschen and Winston Smith (MCMLXXXIV)
//  
//  Licensed under LGPL v3.0
//________________________________

// Factions_StaminaMixin.lua

Script.Load("lua/Factions/Factions_FactionsClassMixin.lua")

StaminaMixin = CreateMixin( StaminaMixin )
StaminaMixin.type = "StaminaMixin"

StaminaMixin.expectedMixins =
{
}

StaminaMixin.expectedCallbacks =
{
}

StaminaMixin.expectedConstants =
{
}

StaminaMixin.networkVars =
{
}

function StaminaMixin:__initmixin()

end

function StaminaMixin:CopyPlayerDataFrom(player)

end

function StaminaMixin:OnUpdate(deltaTime)
	// Update sprint bar
end