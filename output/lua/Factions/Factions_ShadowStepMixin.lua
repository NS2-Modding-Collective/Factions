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

ShadowStepAbilityMixin.kBaseSpeedScalar = 1.2
ShadowStepAbilityMixin.kSpeedScalarIncrease = 0.1
ShadowStepAbilityMixin.kBaseTimeBetweenAttacks = 0.4
ShadowStepAbilityMixin.kTimeBetweenAttacksDecrease = 0.07
ShadowStepAbilityMixin.kBaseStaminaDrainRate = 0.5
ShadowStepAbilityMixin.kStaminaDrainRateDecrease = 0.15

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
	shadowStepping = "boolean",
	shadowStepStartTime = "time",
}

function ShadowStepAbilityMixin:__initmixin()

	if Server then
		self.shadowStepLevel = 0
	end
	
	self.shadowStepAttackCooldowns = {}

end

function ShadowStepAbilityMixin:CopyPlayerDataFrom(player)

	if Server then
		self.shadowStepLevel = player.shadowStepLevel
	end

end

function ShadowStepAbilityMixin:GetTimeBetweenAutoAttacks()

	return ShadowStepAbilityMixin.kBaseTimeBetweenAttacks - ShadowStepAbilityMixin.kTimeBetweenAttacksDecrease * self.shadowStepLevel

end

function ShadowStepAbilityMixin:GetSprintBoostScalar()

	return ShadowStepAbilityMixin.kBaseSpeedScalar + ShadowStepAbilityMixin.kSpeedScalarIncrease * self.shadowStepLevel

end

function ShadowStepAbilityMixin:GetStaminaDrainRate()

	return ShadowStepAbilityMixin.kBaseStaminaDrainRate - ShadowStepAbilityMixin.kStaminaDrainRateDecrease * self.shadowStepLevel

end

function ShadowStepAbilityMixin:OnSecondaryAttack()
	// Copy Shadow Step code here
	if self.shadowStepLevel > 0 then
		self.shadowStepping = true	
		self.shadowStepStartTime = Shared.GetTime()
	end
end

function ShadowStepAbilityMixin:OnSecondaryAttackEnd()
	self.shadowStepping = false
	self.shadowStepStartTime = nil
end

function ShadowStepAbilityMixin:OnUpdateRender(deltaTime)
	// Update visual effect
	if self.shadowStepping then
		// Show blink effect, slightky toned down
	end
end

function ShadowStepAbilityMixin:OnUpdate(deltaTime)
	// Update sprint bar

	// Detect nearby enemies
	
	// Hit them and play swing animation!
end