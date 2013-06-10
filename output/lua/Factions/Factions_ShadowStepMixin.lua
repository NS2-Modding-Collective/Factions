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

ShadowStepAbilityMixin = CreateMixin( ShadowStepAbilityMixin )
ShadowStepAbilityMixin.type = "ShadowStepAbility"

ShadowStepAbilityMixin.stepDistance = kFadeShadowStepDistance

ShadowStepAbilityMixin.expectedMixins =
{
}

ShadowStepAbilityMixin.expectedCallbacks =
{
}

ShadowStepAbilityMixin.expectedConstants =
{
}

ShadowStepAbilityMixin.networkVars =
{
	shadowStepLevel = "integer (0 to " .. #ShadowStepUpgrade.cost .. ")",
}

function ShadowStepAbilityMixin:__initmixin()

	if Server then
		self.shadowStepLevel = 0
	end

end

function ShadowStepAbilityMixin:CopyPlayerDataFrom(player)

	if Server then
		self.shadowStepLevel = player.shadowStepLevel
	end

end

function ShadowStepAbilityMixin:OnSecondaryAttack()
	// Copy Shadow Step code here
	
end