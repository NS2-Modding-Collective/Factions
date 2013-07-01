//________________________________
//
//  Factions
//	Made by Jibrail, JimWest, Sewlek
//  Puschen and Winston Smith (MCMLXXXIV)
//  
//  Licensed under LGPL v3.0
//________________________________

// Factions_SwordHolderMixin.lua

Script.Load("lua/Factions/Factions_FactionsClassMixin.lua")

SwordHolderMixin = CreateMixin( SwordHolderMixin )
SwordHolderMixin.type = "SwordHolder"

SwordHolderMixin.kBaseSpeedScalar = 1.2
SwordHolderMixin.kSpeedScalarIncrease = 0.1
SwordHolderMixin.kBaseTimeBetweenAttacks = 0.4
SwordHolderMixin.kTimeBetweenAttacksDecrease = 0.07
SwordHolderMixin.kBaseStaminaDrainRate = 0.5
SwordHolderMixin.kStaminaDrainRateDecrease = 0.15

SwordHolderMixin.expectedMixins =
{
}

SwordHolderMixin.expectedCallbacks =
{
}

SwordHolderMixin.expectedConstants =
{
}

SwordHolderMixin.networkVars =
{
	swordDashLevel = "integer (0 to " .. #ShadowStepUpgrade.cost .. ")",
	swordDashing = "boolean",
}

function SwordHolderMixin:__initmixin()

	if Server then
		self.swordDashLevel = 0
	end
	
	self.shadowStepAttackCooldowns = {}

end

function SwordHolderMixin:CopyPlayerDataFrom(player)

	if Server then
		self.swordDashLevel = player.swordDashLevel
	end

end

function SwordHolderMixin:GetSwordDashLevel()
	return self.swordDashLevel
end

function SwordHolderMixin:SetSwordDashLevel(newValue)
	self.swordDashLevel = newValue
end

function SwordHolderMixin:GetIsSwordDashing()
	return self.swordDashing
end

function SwordHolderMixin:SetIsSwordDashing(newValue)
	self.swordDashing = newValue
end

function SwordHolderMixin:GetIsSwordDashAvailable()

	return self:GetSwordDashLevel() > 0

end

function SwordHolderMixin:GetTimeBetweenAutoAttacks()

	return SwordHolderMixin.kBaseTimeBetweenAttacks - SwordHolderMixin.kTimeBetweenAttacksDecrease * self:GetShadowStepLevel()

end

function SwordHolderMixin:GetSprintBoostScalar()

	return SwordHolderMixin.kBaseSpeedScalar + SwordHolderMixin.kSpeedScalarIncrease * self:GetShadowStepLevel()

end

function SwordHolderMixin:GetStaminaDrainRate()

	return SwordHolderMixin.kBaseStaminaDrainRate - SwordHolderMixin.kStaminaDrainRateDecrease * self:GetShadowStepLevel()

end

function SwordHolderMixin:OnUpdateRender(deltaTime)
	// Update visual effect
	if self:GetIsSwordDashing() then
		// Show blink effect, slightly toned down
	end
end

function SwordHolderMixin:OnUpdate(deltaTime)
	// Update sprint bar
end