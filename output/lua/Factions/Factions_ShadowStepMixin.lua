//________________________________
//
//  Factions
//	Made by Jibrail, JimWest, Sewlek
//  Puschen and Winston Smith (MCMLXXXIV)
//  
//  Licensed under LGPL v3.0
//________________________________

// Factions_ShadowStepMixin.lua

Script.Load("lua/Factions/Factions_FactionsClassMixin.lua")

ShadowStepMixin = CreateMixin( ShadowStepMixin )
ShadowStepMixin.type = "ShadowStepMixin"

ShadowStepMixin.stepDistance = kFadeShadowStepDistance

ShadowStepMixin.expectedMixins =
{
}

ShadowStepMixin.expectedCallbacks =
{
}

ShadowStepMixin.expectedConstants =
{
}

ShadowStepMixin.networkVars =
{
	shadowStepLevel = "integer (0 to " .. #ShadowStepUpgrade.cost .. ")",
}

function ShadowStepMixin:__initmixin()

	if Server then
		self.shadowStepLevel = 0
	end

end

function ShadowStepMixin:CopyPlayerDataFrom(player)

	if Server then
		self.shadowStepLevel = player.shadowStepLevel
	end

end

function ShadowStepMixin:OnSprint()
	// Copy Shadow Step code here
	
end